import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestService {
  String url;
  dynamic body;

  RequestService({this.body, required this.url});

  Future<http.Response> post() async {
    return await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
  }

  Future<http.Response> getRequest() async {
    return await http.get(
      Uri.parse(url),
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
  }

  Future<http.Response> deleteCategory() async {
    return await http.delete(
      Uri.parse(url),
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
  }
}
