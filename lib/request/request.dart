import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:framework/utils/time.dart';
import 'package:http/http.dart' as http;

enum RequestMethod {
  POST,
  GET,
  PUT,
  DELETE,
  PATCH,
}

class RequestResponse {
  static final RequestResponse empty = RequestResponse();

  /// content type retrieved from the content-type header (if any)
  String contentType = '';

  /// content length
  int contentLength = 0;

  /// request status code
  int statusCode = 0;

  /// http response object
  http.BaseResponse? response;

  /// dio response object used for dio implementations
  Object? dioResponse;

  /// response data as json
  Map<String, dynamic>? jsonResponse;

  /// response data as string (utf-8)
  String stringResponse = '';

  /// response data as json
  List<dynamic>? jsonArray;

  /// is the response ok
  bool ok = false;

  /// did we get the content type we expect
  bool isExpectedContentType = false;

  /// is the response a StreamedResponse
  bool streamed = false;

  /// system I/O code for I/O exceptions
  OSError? ioError;

  /// reason why the request failed
  String reasonPhrase = '';

  /// request body
  String requestBody = '';

  /// is this response a json
  bool isJson = false;

  /// is this response plain (text or json)
  bool isPlain = false;

  /// is this an xml response
  bool isXml = false;

  /// is this response a text response
  bool get isText => isJson || isPlain || isXml;

  void parseContentType(String? header) {
    var typeHeader = '';
    if (header != null) typeHeader = header;

    contentType = typeHeader.trim().toLowerCase();

    isJson = contentType.contains('application/json');
    isPlain = contentType.contains('text/plain');
    isXml = contentType.contains('text/xml');
  }
}

class Requests {
  static bool log = false;
  static List<String> expectedContentTypes = ['application/json'];
  static Duration timeoutDuration = const Duration(seconds: 3);

  static Future<RequestResponse> request(RequestMethod method,
      String url, {
        String? body,
        Map<String, String>? headers,
        bool multipart = false,
        bool form = false,
        List<http.MultipartFile>? files,
        Map<String, String>? fields,
        List<String>? expectedContentTypes,
        String? acceptType,
        bool isJsonArray = false,
        Duration? timeout,
      }) async {
    DateTime? start;

    if (log) start = DateTime.now();

    var uri = Uri.parse(url);
    var result = RequestResponse();

    if (log) print('req (${method.name}) > start: $url');
    if (log && body != null) print('req > body: $body');

    http.BaseResponse? response;
    String responseBody = '';
    http.BaseRequest? req;
    if (body != null) result.requestBody = body;

    var timeoutDuration = timeout ?? Requests.timeoutDuration;

    Map<String, String>? useHeaders = {};

    if (headers != null) useHeaders.addAll(headers);
    if (acceptType != null) useHeaders.addAll({'Accept': acceptType!});

    try {
      if (multipart) {
        // log all sent files
        if (files != null) {
          for (var f in files) {
            if (log) {
              print('req > file: ${f.contentType.toString()} ${f.length} ${f.field} ${f.filename} ${f.isFinalized}');
            }
          }
        }

        var multipartReq = http.MultipartRequest(method.name, uri);
        req = multipartReq;

        if (useHeaders != null && useHeaders.isNotEmpty) multipartReq.headers.addAll(useHeaders);
        if (files != null) multipartReq.files.addAll(files);
        if (fields != null) multipartReq.fields.addAll(fields);

        response = await multipartReq.send().timeout(timeoutDuration);
      } else {
        late Future<http.Response> future;

        if (method == RequestMethod.GET) {
          future = http.get(uri, headers: useHeaders).timeout(timeoutDuration);
        } else if (method == RequestMethod.POST) {
          future = http.post(uri, body: body, headers: useHeaders).timeout(timeoutDuration);
        } else if (method == RequestMethod.PUT) {
          future = http.put(uri, headers: useHeaders).timeout(timeoutDuration);
        } else if (method == RequestMethod.PATCH) {
          future = http.patch(uri, headers: useHeaders).timeout(timeoutDuration);
        } else if (method == RequestMethod.DELETE) {
          future = http.delete(uri, headers: useHeaders).timeout(timeoutDuration);
        }

        future.then((value) {
          response = value;
          return value;
        });

        await future;

        if (response != null) req = response!.request;
      }
    } catch (e, s) {
      print('req > exception: $e');
      debugPrintStack(stackTrace: s, label: 'req > stacktrace');

      if (e is SocketException) {
        if (e.osError != null) result.ioError = e.osError;
        result.reasonPhrase = e.message;
      } else if (e is TimeoutException) {
        result.reasonPhrase = 'Request timed out';
      }
    }

    if (log) {
      if (req != null) {
        print('req > headers: ${req.headers}');
      } else {
        print('req > headers: $useHeaders');
      }
    }

    var statusCode = response != null ? response!.statusCode : 0;
    result.statusCode = statusCode;
    var contentLength = response != null ? response!.contentLength : 0;
    if (contentLength != null) result.contentLength = contentLength;

    var reqOk = false;
    String errorContentType = '';

    if (response != null) {
      // get content type
      result.parseContentType(response!.headers['content-type']);
    }

    if (result.contentType.isNotEmpty) {
      errorContentType = ' content type: ${result.contentType},';
    }

    if (statusCode < 200 || statusCode >= 400 || response == null) {
      if (response == null) {
        print('response > No response (timeout)');
      } else {
        print(
            'response > Error. Status code:  ($statusCode),$errorContentType content length: $contentLength');
      }
    } else {
      reqOk = true;
      if (log) print(
          'response > Status code:  ($statusCode),$errorContentType content length: $contentLength');
    }

    try {
      if (response != null) {
        // get content type
        result.parseContentType(response!.headers['content-type']);

        if (response!.reasonPhrase != null) result.reasonPhrase = response!.reasonPhrase!;

        if (!multipart) {
          // get response body
          var res = response as http.Response;

          if (res.body.isNotEmpty && result.isText) {
            responseBody = utf8.decode(res.bodyBytes);
            result.stringResponse = responseBody;
          }
        } else {
          result.streamed = true;

          // get streamed response body
          if (result.isText) {
            var r = await http.Response.fromStream(response as http.StreamedResponse);
            responseBody = utf8.decode(r.bodyBytes);
            result.stringResponse = responseBody;
          }
        }
      }

      result.ok = reqOk;
    } catch (e) {
      result.ok = false;
      print('response > Failed to get response body for $url');
      print(e);
    }

    if (response != null && responseBody.isNotEmpty) {
      if (log) print('response > content-type: ${result.contentType}');

      // log only text body
      if (log && result.isText) {
        print('response > body: $responseBody');
      }

      if (log) print('response > headers: ${response!.headers}');

      if (result.isJson) {
        try {
          if (!isJsonArray) {
            result.jsonResponse = json.decode(responseBody);
          } else {
            result.jsonArray = json.decode(responseBody);
          }
        } catch (e) {
          result.ok = false;
          print('response > Failed to parse json for $url');
          print(e);
        }
      }
    }

    if (result.ok) {
      validateResponse(result, expectedContentTypes);
    }

    if (log) print('req > done (ok: $reqOk, elapsed: ${start!.elapsed().toStringAsFixed(3)}s): $url');

    result.response = response;
    return result;
  }

  static bool validateResponse(RequestResponse response, List<String>? expectedContentTypes) {
    expectedContentTypes ??= Requests.expectedContentTypes;

    var contains = false;

    if (expectedContentTypes != null) {
      var base = response.contentType;

      for (var type in expectedContentTypes) {
        if (response.contentType.contains(type)) contains = true;
      }
    } else {
      contains = true;
    }


    if (contains) {
      response.isExpectedContentType = true;
      return true;
    } else {
      // no content, so no content type expected
      if (response.contentLength == 0) {
        response.isExpectedContentType = true;
        return true;
      }

      response.ok = false;
      response.isExpectedContentType = false;
      print('req > No expected content type returned: $expectedContentTypes, actual: ${response.contentType}');
      return false;
    }
  }

  static String formEndpoint(String baseUrl, String route) {
    // remove unnecessary trailing slash
    if (baseUrl.isNotEmpty && baseUrl[baseUrl.length - 1] == '/') {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }

    route = cleanupRoute(route);

    return '$baseUrl/$route';
  }

  static String cleanupRoute(String route) {
    // remove unnecessary leading slash
    if (route.isNotEmpty && route[0] == '/') {
      return route.substring(1, route.length);
    }

    return route;
  }
}
