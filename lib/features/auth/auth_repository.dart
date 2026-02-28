import '../../core/api_client.dart';

class AuthRepository {
  final ApiClient api;

  AuthRepository(this.api);

  Future<String> login() async {
    final data = await api.post(
      '/auth/login',
      {
        "username": "mor_2314",
        "password": "83r5^_"
      },
    );
    return data['token'];
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    return await api.get('/users/1');
  }
}