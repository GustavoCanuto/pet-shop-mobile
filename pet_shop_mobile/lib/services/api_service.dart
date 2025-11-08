import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService {
  static const baseUrl = 'http://144.22.203.109:80/api'; // IP real do servidor

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

  // Buscar pets filtrando por dono
  static Future<List<dynamic>> getPetsByOwner(int idDono) async {
    final result = await _get('pets?id_dono=$idDono');

    if (result['status'] == false) {
      throw Exception(result['message']);
    }

    return result['data'] ?? [];
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

  // Vincular pet ao usuário logado
  static Future<Map<String, dynamic>> linkPetToUser(int userId, int petId) async {
    return _post('users/$userId/pets/$petId', {});
  }

  // Deletar pet
  static Future<Map<String, dynamic>> deletePet(int petId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/pets/$petId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 60));

      final body = jsonDecode(response.body);
      return body;
    } catch (e) {
      return {'status': false, 'message': 'Erro ao remover pet'};
    }
  }

  static Future<List<dynamic>> getPetsByDono(int donoId) async {
    final result = await _get('pets?id_dono=$donoId');
    if (result['status'] == false) throw Exception(result['message']);
    return result['data'] ?? [];
  }

  static Future<List<dynamic>> getVeterinarios() async {
    final result = await _get('users?permissao=2');
    if (result['status'] == false) throw Exception(result['message']);
    return result['data'] ?? [];
  }

  static Future<Map<String, dynamic>> addConsulta(Map<String, dynamic> data) async {
    return _post('consultas', data);
  }

  // Buscar consultas por dono
  static Future<Map<String, dynamic>> getConsultas(int donoId) async {
    return _get('consultas?id_dono=$donoId');
  }

// Excluir consulta
  static Future<Map<String, dynamic>> deleteConsulta(int consultaId) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/consultas/$consultaId'))
          .timeout(const Duration(seconds: 60));
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 204) {
        return {'status': true, 'message': 'Consulta excluída com sucesso'};
      } else {
        return {'status': false, 'message': body['message'] ?? 'Erro ao excluir consulta'};
      }
    } catch (e) {
      return {'status': false, 'message': 'Erro: ${e.toString()}'};
    }
  }


}
