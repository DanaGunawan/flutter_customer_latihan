import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> deleteCustomer(String userId, VoidCallback onSuccess) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.166.199.58/fluttersql/deleteuser.php'), 
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": userId}),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['message'] == "User Deleted") {
        onSuccess();
      } else {
        throw Exception('Failed to delete customer: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to delete customer. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to delete customer. Error: $e');
  }
}
