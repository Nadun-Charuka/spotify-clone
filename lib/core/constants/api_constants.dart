import 'dart:io';

class ApiConstants {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    } else {
      return 'http://127.0.0.1:8000';
    }
  }

  static String signupEndpoint = '$baseUrl/auth/signup';
  static String loginEndpoint = '$baseUrl/auth/login';
  static String currentUserEndpoint = '$baseUrl/auth/me';
}
