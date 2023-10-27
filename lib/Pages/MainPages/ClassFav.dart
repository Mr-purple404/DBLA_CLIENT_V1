import 'package:flutter/material.dart';

class FavPostionClass {
  final int id;
  final String name;
  final String latitude;
  final String longitude;
  final String adresse;
  FavPostionClass({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.adresse,
  });
  factory FavPostionClass.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('id') &&
        json.containsKey('name') &&
        json.containsKey('latitude') &&
        json.containsKey('longitude')) {
      return FavPostionClass(
        id: json['id'],
        name: json['name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        adresse: json['adresse'],
      );
    } else {
      print(
          'Erreur lors de la désérialisation du JSON : certaines propriétés manquent ou ont des valeurs inattendues.');
      print('JSON complet : $json');
      return FavPostionClass(
        id: 0,
        name: '',
        latitude: '',
        longitude: '0',
        adresse: '',
      );
    }
  }
}
