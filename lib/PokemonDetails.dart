import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonDetails {
  final String pName;
  late final String apiUrl;
  late Map<String, dynamic> pData;



  PokemonDetails(this.pName) {
    String pNameLower = pName.toLowerCase();
    apiUrl = 'https://pokeapi.co/api/v2/pokemon/$pNameLower';
  }

  Future<Map<String, dynamic>> fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch data. Status code: ${response.statusCode}');
      } else {
        pData = json.decode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return pData;
  }
}
