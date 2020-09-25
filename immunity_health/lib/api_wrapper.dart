import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

const String SERVER_URI = "https://test-immunity-health.free.beeceptor.com/";

class Api {
  var client = http.Client();



  Future<Map> getCurrentUser() async {
    try {
      var resp = await client.get("$SERVER_URI");
      return {"status": "success", "info": (resp.body)};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

}