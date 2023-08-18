import 'package:chat/global/environmet.dart';
import 'package:chat/models/user.dart';
import 'package:chat/models/users_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsersService {
  Future<List<User>> getUsers() async {
    try {
      final Uri uri = Uri.parse('${Environment.apiUrl}/users');
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      final usersResponse = UsersResponse.fromJsonString(resp.body);
      return usersResponse.users;
    } catch (e) {
      return [];
    }
  }
}
