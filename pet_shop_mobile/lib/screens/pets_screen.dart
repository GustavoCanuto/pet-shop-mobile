import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class PetsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const PetsScreen({super.key, required this.userData});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  List<dynamic> pets = [];

  final String defaultPetImage =
      "https://cdn-icons-png.flaticon.com/512/616/616408.png";

  @override
  void initState() {
    super.initState();
    carregarPetsAtualizados();
  }

  Future<void> carregarPetsAtualizados() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString("email");
      final senha = prefs.getString("senha");

      if (email == null || senha == null) return;

      final loginResult = await ApiService.login(email, senha);

      if (loginResult['status'] == true) {
        setState(() {
          pets = loginResult['data']['pets'] ?? [];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar pets')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Meus Pets"),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: carregarPetsAtualizados,
          )
        ],
      ),
      body: pets.isEmpty
          ? const Center(
        child: Text(
          "Nenhum pet cadastrado 😿",
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];
          return Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(defaultPetImage),
              ),
              title: Text(
                pet["nome"],
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              subtitle: Text(
                "Raça: ${pet['raca']} • Idade: ${pet['idade']} anos",
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          );
        },
      ),
    );
  }
}
