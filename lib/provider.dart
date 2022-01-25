import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_provider_sample/data/postal_code.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final postalCodeProvider = StateProvider<String>((ref) {
  return '';
});

final apiProvider = FutureProvider<PostalCode>((ref) async {
  final postalCode = ref.watch(postalCodeProvider);
  if (postalCode.length != 7) {
    throw Exception('Postal code must be 7 characters');
  }

  // 123-4567
  final upper = postalCode.substring(0, 3); // 123
  final lower = postalCode.substring(3); // 4567

  // https://madefor.github.io/postal-code-api/api/v1/100/0014.json
  final apiUrl =
      'https://madefor.github.io/postal-code-api/api/v1/$upper/$lower.json';
  final apiUri = Uri.parse(apiUrl);

  final response = await http.get(apiUri);

  if (response.statusCode != 200) {
    throw Exception('No postal code: $postalCode');
  }

  final jsonData = json.decode(response.body);
  return PostalCode.fromJson(jsonData);
});

final apiFamilyProvider = FutureProvider.family
    .autoDispose<PostalCode, String>((ref, postalCode) async {
  if (postalCode.length != 7) {
    throw Exception('Postal code must be 7 characters');
  }

  // 123-4567
  final upper = postalCode.substring(0, 3); // 123
  final lower = postalCode.substring(3); // 4567

  // https://madefor.github.io/postal-code-api/api/v1/100/0014.json
  final apiUrl =
      'https://madefor.github.io/postal-code-api/api/v1/$upper/$lower.json';
  final apiUri = Uri.parse(apiUrl);

  final response = await http.get(apiUri);

  if (response.statusCode != 200) {
    throw Exception('No postal code: $postalCode');
  }

  final jsonData = json.decode(response.body);
  return PostalCode.fromJson(jsonData);
});
