import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_dev_mobile/data/models/user_model.dart';

class AuthRepository {
  final FlutterSecureStorage _secureStorage;
  //static const String _baseUrl = 'https://apimw.sistemagiv.com.br/TestMobile';
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';

  AuthRepository(this._secureStorage);

  Future<bool> login(String username, String password) async {
    if (username == 'teste.mobile' && password == '1234') {
      final mockResponseData = _getMockResponseData();
      final user = UserModel.fromJson(mockResponseData['user']);
      
      // Store user data
      await _secureStorage.write(
        key: _userKey,
        value: jsonEncode(user.toJson()),
      );
      
      return true;
    }
    return false;

    /*
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          final user = UserModel.fromJson(data['user']);
          
          // Store user data and token
          await _secureStorage.write(
            key: _userKey,
            value: jsonEncode(user.toJson()),
          );
          
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
    */
  }

  Future<bool> isLoggedIn() async {
    final userData = await _secureStorage.read(key: _userKey);
    return userData != null;
  }

  Future<UserModel?> getUser() async {
    try {
      final userData = await _secureStorage.read(key: _userKey);
      if (userData != null) {
        return UserModel.fromJson(jsonDecode(userData));
      }
      return null;
    } catch (e) {
      log('Get user error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _userKey);
    await _secureStorage.delete(key: _tokenKey);
  }
  
  // Mock response data
  Map<String, dynamic> _getMockResponseData() {
    return {
      "success": true,
      "user": {
        "name": "Paulo",
        "profile": "Desenvolvedor",
        "tasks": [
          {
            "id": 1,
            "task_name": "Tarefa número 1",
            "description": "Informe o nome e preço do produto",
            "fields": [
              {
                "id": 1,
                "label": "Nome do produto",
                "required": true,
                "field_type": "text"
              },
              {
                "id": 2,
                "label": "Informe o preço",
                "required": true,
                "field_type": "mask_price"
              }
            ]
          },
          {
            "id": 2,
            "task_name": "Tarefa número 2",
            "description": "Informe o nome do produto e data de vencimento",
            "fields": [
              {
                "id": 1,
                "label": "Nome do produto",
                "required": true,
                "field_type": "text"
              },
              {
                "id": 2,
                "label": "data de vencimento",
                "required": true,
                "field_type": "mask_date"
              }
            ]
          },
          {
            "id": 3,
            "task_name": "Tarefa número 3",
            "description": "Informe o nome do cliente e nome da loja",
            "fields": [
              {
                "id": 1,
                "label": "Nome do cliente",
                "required": true,
                "field_type": "text"
              },
              {
                "id": 2,
                "label": "nome da loja",
                "required": true,
                "field_type": "text"
              }
            ]
          }
        ]
      }
    };
  }
}