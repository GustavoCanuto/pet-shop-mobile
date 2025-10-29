import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddConsultaScreen extends StatefulWidget {
  const AddConsultaScreen({super.key});

  @override
  State<AddConsultaScreen> createState() => _AddConsultaScreenState();
}

class _AddConsultaScreenState extends State<AddConsultaScreen> {
  final _formKey = GlobalKey<FormState>();
  final dataController = TextEditingController();
  final veterinarioController = TextEditingController();
  final donoController = TextEditingController();
  final petController = TextEditingController();

  bool loading = false;

  Future<void> salvarConsulta() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    // final result = await ApiService._post("consultas", {
    //   "data": dataController.text,
    //   "id_veterinario": veterinarioController.text,
    //   "id_dono": donoController.text,
    //   "id_pet": petController.text,
    // });
    //
    // setState(() => loading = false);
    //
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text(result['message'] ?? 'Erro ao salvar')),
    // );

    //if (result['status'] == true) Navigator.pop(context);
  }

  Widget campo(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (v) => v!.isEmpty ? "Preencha este campo" : null,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Cadastrar Consulta"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              campo("Data (YYYY-MM-DD HH:mm:ss)", dataController),
              const SizedBox(height: 12),
              campo("ID Veterinário", veterinarioController),
              const SizedBox(height: 12),
              campo("ID Dono", donoController),
              const SizedBox(height: 12),
              campo("ID Pet", petController),
              const SizedBox(height: 24),
              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: salvarConsulta,
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
}
