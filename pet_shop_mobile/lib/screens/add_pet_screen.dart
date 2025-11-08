import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddPetScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const AddPetScreen({super.key, required this.userData});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final idadeController = TextEditingController();

  final List<String> tipos = ["Cachorro", "Gato", "Peixe", "Pássaro", "Outro"];

  final Map<String, List<String>> racas = {
    "Cachorro": ["SRD", "Labrador", "Poodle", "Pitbull", "Bulldog"],
    "Gato": ["SRD", "Persa", "Siamês", "Maine Coon"],
    "Peixe": ["Betta", "Kingui", "Neon", "Guppy"],
    "Pássaro": ["Calopsita", "Canário", "Papagaio"],
    "Outro": ["Desconhecido"]
  };

  String? tipoSelecionado;
  String? racaSelecionada;

  bool loading = false;

  Future<void> salvarPet() async {
    if (!_formKey.currentState!.validate()) return;
    if (tipoSelecionado == null || racaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione o tipo e a raça')),
      );
      return;
    }

    setState(() => loading = true);

    // 1) Cadastra o pet
    final createPetResult = await ApiService.addPet({
      "nome": nomeController.text,
      "raca": racaSelecionada,
      "idade": int.tryParse(idadeController.text) ?? 0,
      "tipo": tipoSelecionado, // agora é string ✅
    });

    if (createPetResult['status'] == true) {
      final int petId = createPetResult['data']['id'];
      final int userId = widget.userData['id'];

      // 2) Vincula ao usuário
      final linkResult = await ApiService.linkPetToUser(userId, petId);

      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(linkResult['message'] ?? "Pet vinculado com sucesso!")),
      );

      if (linkResult['status'] == true) Navigator.pop(context);
      return;
    }

    setState(() => loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(createPetResult['message'] ?? "Erro ao cadastrar pet")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Cadastrar Pet"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nome
              TextFormField(
                controller: nomeController,
                validator: (v) => v!.isEmpty ? "Preencha o nome" : null,
                style: const TextStyle(color: Colors.white),
                decoration: _input("Nome"),
              ),
              const SizedBox(height: 12),

              // Tipo
              DropdownButtonFormField<String>(
                value: tipoSelecionado,
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                decoration: _input("Tipo"),
                items: tipos
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    tipoSelecionado = v;
                    racaSelecionada = null;
                  });
                },
              ),
              const SizedBox(height: 12),

              // Raça dependente do Tipo
              DropdownButtonFormField<String>(
                value: racaSelecionada,
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                decoration: _input("Raça"),
                items: (tipoSelecionado == null)
                    ? []
                    : racas[tipoSelecionado]!
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => setState(() => racaSelecionada = v),
              ),
              const SizedBox(height: 12),

              // Idade
              TextFormField(
                controller: idadeController,
                validator: (v) => v!.isEmpty ? "Preencha a idade" : null,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _input("Idade"),
              ),
              const SizedBox(height: 24),

              loading
                  ? const CircularProgressIndicator(color: Colors.teal)
                  : ElevatedButton(
                onPressed: salvarPet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text("Salvar", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _input(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}
