import 'package:flutter/material.dart';

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
    loadPets();
  }

  void loadPets() {
    final userPets = widget.userData['pets'] as List<dynamic>? ?? [];
    setState(() {
      pets = userPets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Pets')),
      body: pets.isEmpty
          ? const Center(child: Text('Nenhum pet cadastrado.'))
          : ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];
          return ListTile(
            title: Text(pet['nome']),
            subtitle: Text('Raça: ${pet['raca']} | Idade: ${pet['idade']} anos'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add_pet'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
