import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
        bool isJsonArray = false,
        Duration? timeout,
      }) async {
    var uri = Uri.parse(url);
    var result = RequestResponse();

    if (log) print('req (${method.name}) > start: $url');
    if (log && body != null) print('req > body: $body');

    http.BaseResponse? response;
    String responseBody = '';
    http.BaseRequest? req;
    if (body != null) result.requestBody = body;

    var timeoutDuration = timeout ?? Requests.timeoutDuration;

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

        if (headers != null) multipartReq.headers.addAll(headers);
        if (files != null) multipartReq.files.addAll(files);
        if (files != null) multipartReq.fields.addAll(fields!);

        response = await multipartReq.send().timeout(timeoutDuration);
      } else {
        late Future<http.Response> future;

        if (method == RequestMethod.GET) {
          future = http.get(uri, headers: headers).timeout(timeoutDuration);
        } else if (method == RequestMethod.POST) {
          future = http.post(uri, body: body, headers: headers).timeout(timeoutDuration);
        } else if (method == RequestMethod.PUT) {
          future = http.put(uri, headers: headers).timeout(timeoutDuration);
        } else if (method == RequestMethod.PATCH) {
          future = http.patch(uri, headers: headers).timeout(timeoutDuration);
        } else if (method == RequestMethod.DELETE) {
          future = http.delete(uri, headers: headers).timeout(timeoutDuration);
        }

        future.then((value) {
          response = value;
          return value;
        });

        await future;

        if (response != null) req = response!.request;
      }
    } catch (e) {
      print('req > exception\n$e');

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
        print('req > headers: $headers');
      }
    }

    var statusCode = response != null ? response!.statusCode : 0;
    result.statusCode = statusCode;
    var contentLength = response != null ? response!.contentLength : 0;
    if (contentLength != null) result.contentLength = contentLength;

    var reqOk = false;

    if (statusCode < 200 || statusCode >= 400 || response == null) {
      if (response == null) {
        print('response > No response (timeout)');
      } else {
        print('response > Error. Status code:  ($statusCode), content length: $contentLength');
      }
    } else {
      reqOk = true;
      if (log) print('response > Status code:  ($statusCode), content length: $contentLength');
    }

    try {
      if (response != null) {
        if (response!.reasonPhrase != null) result.reasonPhrase = response!.reasonPhrase!;

        if (!multipart) {
          // get response body
          var res = response as http.Response;

          if (res.body.isNotEmpty) {
            responseBody = utf8.decode(res.bodyBytes);
          }
        } else {
          result.streamed = true;
          // get streamed response body
          var r = await http.Response.fromStream(response as http.StreamedResponse);
          responseBody = utf8.decode(r.bodyBytes);
        }
      }

      result.ok = reqOk;
    } catch (e) {
      result.ok = false;
      print('response > Failed to get response body for $url');
      print(e);
    }

    String typeHeader = '';

    if (response != null) {
      var header = response!.headers['content-type'];
      if (header != null) typeHeader = header;
    }

    var contentType = typeHeader.toLowerCase();
    result.contentType = contentType;

    if (response != null && responseBody.isNotEmpty) {
      if (log) print('response > content-type: $contentType');

      var isJson = contentType.contains('application/json');

      // log only text body
      if (log && (isJson || contentType.contains('text'))) {
        print('response > body: $responseBody');
      }

      if (log) print('response > headers: ${response!.headers}');

      if (isJson) {
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

    if (log) print('req > done ($reqOk): $url');

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
}
