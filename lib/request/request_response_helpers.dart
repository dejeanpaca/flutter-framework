import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'request.dart';

extension RequestResponseHelpers on RequestResponse {
  /// is this a json response
  bool isJson() {
    return contentType.startsWith('application/json');
  }

  /// is this a multipart response
  bool isMultipart() {
    return contentType.startsWith('multipart/');
  }

  /// is the content type an image
  bool isImage() {
    return isJpeg() || isPNG();
  }

  /// is the content type a png
  bool isPNG() {
    return contentType.startsWith('image/png');
  }

  /// is the content type a jpeg
  bool isJpeg() {
    return contentType.startsWith('image/jpeg');
  }

  /// saves response content to file
  Future<bool> saveToFile(String path, {bool flush = true}) async {
    if (response != null) {
      if (response!.contentLength != null && response!.contentLength! > 0) {
        Uint8List? data;

        if (streamed) {
          // get data from streamed response
          var streamedResponse = response as StreamedResponse;

          data = await streamedResponse.stream.toBytes();
        } else {
          // get data from streamed response
          var regularResponse = response as Response;

          data = regularResponse.bodyBytes;
        }

        try {
          var f = File(path);
          f.writeAsBytes(data, flush: flush);

          return true;
        } catch (e) {
          print(e);
        }
      }
    }

    return false;
  }
}
