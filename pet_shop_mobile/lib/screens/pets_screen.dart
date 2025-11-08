import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PetsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const PetsScreen({super.key, required this.userData});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  List<dynamic> pets = [];

  @override
  void initState() {
    super.initState();
    carregarPets();
  }

  Future<void> carregarPets() async {
    try {
      final idDono = widget.userData['id'];
      final response = await ApiService.getPetsByOwner(idDono);
      setState(() => pets = response);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao carregar pets")),
      );
    }
  }

  // ✅ Retorna imagem de acordo com o tipo
  String getPetImageUrl(String tipo) {
    switch (tipo.toLowerCase()) {
      case "cachorro":
        return "https://cdn-icons-png.flaticon.com/512/616/616408.png";
      case "gato":
        return "https://cdn-icons-png.flaticon.com/512/1864/1864514.png";
      case "peixe":
        return "https://cdn-icons-png.flaticon.com/512/2990/2990515.png";
      case "pássaro":
        return "https://cdn-icons-png.flaticon.com/512/6622/6622646.png";
      default:
        return "https://cdn-icons-png.flaticon.com/512/8277/8277564.png";
    }
  }

  // ✅ Diálogo de confirmação de exclusão
  Future<void> confirmarExclusao(int petId) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Excluir Pet"),
        content: const Text("Tem certeza que deseja excluir este pet?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Excluir", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmar == true) {
      final result = await ApiService.deletePet(petId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Pet removido")),
      );
      carregarPets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Meus Pets"),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(onPressed: carregarPets, icon: const Icon(Icons.refresh))
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
        itemBuilder: (_, index) {
          final pet = pets[index];

          return Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Image.network(
                getPetImageUrl(pet['tipo']),
                width: 48,
                height: 48,
                errorBuilder: (_, __, ___) => const Icon(Icons.pets, color: Colors.white),
              ),
              title: Text(pet['nome'], style: const TextStyle(color: Colors.white, fontSize: 18)),
              subtitle: Text(
                "${pet['tipo']}  • ${pet['raca']} • ${pet['idade']} anos",
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => confirmarExclusao(pet['id']),
              ),
            ),
          );
        },
      ),
    );
  }
}
