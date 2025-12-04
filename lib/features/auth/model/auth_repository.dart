import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_client/core/constants/api_constants.dart';
import 'package:spotify_client/core/models/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    client: http.Client(),
    storage: const FlutterSecureStorage(),
  ),
);

class AuthRepository {
  final http.Client client;
  final FlutterSecureStorage storage;

  AuthRepository({required this.client, required this.storage});

  Future<UserModel?> getCurrentUserData() async {
    try {
      String? token = await storage.read(key: 'auth_token');
      if (token == null) return null;

      final response = await client.get(
        Uri.parse(ApiConstants.currentUserEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if (response.statusCode != 200) return null;

      final map = jsonDecode(response.body) as Map<String, dynamic>;
      map['token'] = token;
      return UserModel.fromMap(map);
    } catch (e) {
      return null;
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.signupEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      if (response.statusCode != 200) {
        throw Exception(jsonDecode(response.body)['detail']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode != 200) {
        throw Exception(jsonDecode(response.body)['detail']);
      }
      final token = jsonDecode(response.body)['access_token'];
      await storage.write(key: 'auth_token', value: token);
      return token;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'auth_token');
  }
}
