import 'package:flutter_exam_final/models/hero.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SuperHeroHTTP {
  static const String baseUrl = 'https://superheroapi.com/api';
  final String accessToken = '/3681284758581999';
  final String exampleUrl = '/search/all';

  Future<List<SuperHero>> allHeroes(http.Client client) async {
    final String upComing = baseUrl + accessToken + exampleUrl;

    final response = await client.get(upComing);

    print(response.statusCode);

    if (response.statusCode == 200) {
      print(response.body);
      print('ewqoiuqwoeuqwoiueqowiueqwoi');
      final jsonResponse = json.decode(response.body);
      final parsed = jsonResponse['results'];
      print(parsed);
      print('ewqoiuqwoeuqwoiueqowiueqwoi');
      List<SuperHero> heroes =
          parsed.map<SuperHero>((json) => SuperHero.fromJson(json)).toList();

      // List heroes = parsed.map((value) => SuperHero.fromJson(value)).toList();

      if (heroes.length > 0) heroes.removeAt(0);

      return heroes;
    } else {
      throw Exception('Error: No se cargaron los heroes');
    }
  }

  Future<SuperHero> findHero(String title) async {
    final String upComing = baseUrl + accessToken;
    final response = await http.get(upComing + '/search/' + title);

    print('Busqueda - ' + response.statusCode.toString());

    if (response.statusCode == 200) {
      print("Busqueda - Exito body");
      print(response.body);
      return SuperHero.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to search country');
    }
  }
}
