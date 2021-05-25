import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:family_accounting/providers/APIExceptions.dart';
import 'package:http/http.dart' as http;

class APIProvider {
  static String _baseURL = 'http://localhost:3000';

  Future<dynamic> sendRequest(dynamic body, Map<String, dynamic> options) async {
    http.Response response;
    final Map<String, String> headers = new Map<String, String>();
    headers.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/x-www-form-urlencoded');

    try {
      switch(options['method']) {
        case 'GET': {
          response = await http.get(
            _baseURL + options['endPoint'],
            headers: headers,
          );
          break;
        }
        case 'PUT': {
          response = await http.put(
              _baseURL + options['endPoint'],
              headers: headers,
              body: body
          );
          break;
        }
        case 'POST': {
          response = await http.post(
              _baseURL + options['endPoint'],
              headers: headers,
              body: body
          );
          break;
        }
        case 'DELETE': {
          response = await http.get(
            _baseURL + options['endPoint'],
            headers: headers,
          );
          break;
        }
      }

      if (response != null) {
        final statusCode = response.statusCode;
        if (statusCode >= 200 && statusCode < 299) {
          if (response.body.isEmpty) {
            return List<dynamic>();
          } else {
            return jsonDecode(response.body);
          }
        } else if (statusCode >= 400 && statusCode < 500) {
          throw ClientErrorException();
        } else if (statusCode >= 500 && statusCode < 600) {
          throw ServerErrorException();
        } else {
          throw UnknownException();
        }
      }
    } on TimeoutException catch (e) {
      //handleTimeout();
    } on SocketException catch (e) {
      throw ConnectionException();
      //handleTimeout();
    } on Error catch (e) {
      print('General Error: $e');
      throw UnknownException();
    }
  }
}
