import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'http://192.168.15.2:8000/api'; // IP real do servidor

  // POST genérico com timeout e tratamento de erro
  static Future<Map<String, dynamic>> _post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      )
          .timeout(const Duration(seconds: 60)); // timeout 60s

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body;
      } else {
        return {
          'status': false,
          'message': body['message'] ?? 'Erro inesperado',
        };
      }
    } on http.ClientException {
      return {'status': false, 'message': 'Erro de conexão com o servidor'};
    } on Exception catch (e) {
      return {'status': false, 'message': 'Erro: ${e.toString()}'};
    }
  }

  // GET genérico com timeout e tratamento de erro
  static Future<Map<String, dynamic>> _get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint')).timeout(const Duration(seconds: 60));
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return body;
      } else {
        return {
          'status': false,
          'message': body['message'] ?? 'Erro inesperado',
        };
      }
    } on http.ClientException {
      return {'status': false, 'message': 'Erro de conexão com o servidor'};
    } on Exception catch (e) {
      return {'status': false, 'message': 'Erro: ${e.toString()}'};
    }
  }

  // Criar usuário
  static Future<Map<String, dynamic>> registerUser(Map<String, dynamic> data) async {
    return _post('users', data);
  }

  // Login
  static Future<Map<String, dynamic>> login(String email, String senha) async {
    final result = await _post('users/login', {'email': email, 'senha': senha});

    // Garantir retorno sempre consistente
    if (!result.containsKey('status')) {
      return {'status': false, 'message': 'Erro desconhecido'};
    }

    return result;
  }

  // Listar pets
  static Future<List<dynamic>> getPets() async {
    final result = await _get('pets');

    if (result['status'] == false) {
      // lança exception para poder tratar no Flutter
      throw Exception(result['message']);
    }

    return result['data'] ?? [];
  }

  // Cadastrar pet
  static Future<Map<String, dynamic>> addPet(Map<String, dynamic> data) async {
    final result = await _post('pets', data);

    if (!result.containsKey('status')) {
      return {'status': false, 'message': 'Erro desconhecido'};
    }

    return result;
  }
}
