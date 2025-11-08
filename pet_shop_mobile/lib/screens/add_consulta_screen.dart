import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddConsultaScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const AddConsultaScreen({super.key, required this.userData});

  @override
  State<AddConsultaScreen> createState() => _AddConsultaScreenState();
}

class _AddConsultaScreenState extends State<AddConsultaScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? selectedPetId;
  int? selectedVetId;

  List<Map<String, dynamic>> pets = [];
  List<Map<String, dynamic>> veterinarios = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    carregarPets();
    carregarVeterinarios();
  }

  Future<void> carregarPets() async {
    try {
      final result = await ApiService.getPetsByDono(widget.userData['id']);
      setState(() {
        pets = List<Map<String, dynamic>>.from(result);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar pets: $e")),
      );
    }
  }

  Future<void> carregarVeterinarios() async {
    try {
      final result = await ApiService.getVeterinarios();
      setState(() {
        veterinarios = List<Map<String, dynamic>>.from(result);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar veterinários: $e")),
      );
    }
  }

  Future<void> selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> selecionarHora() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  Future<void> salvarConsulta() async {
    // Corrigido: validar corretamente
    if (!_formKey.currentState!.validate()) return;

    if (selectedDate == null || selectedTime == null || selectedPetId == null || selectedVetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    setState(() => loading = true);

    final dataStr =
        "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2,'0')}-${selectedDate!.day.toString().padLeft(2,'0')}";
    final horaStr =
        "${selectedTime!.hour.toString().padLeft(2,'0')}:${selectedTime!.minute.toString().padLeft(2,'0')}";

    final result = await ApiService.addConsulta({
      "data": dataStr,
      "hora": horaStr,
      "id_veterinario": selectedVetId,
      "id_dono": widget.userData['id'],
      "id_pet": selectedPetId,
    });

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? "Consulta cadastrada")),
    );

    if (result['status'] == true) Navigator.pop(context);
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Combo Pets
              DropdownButtonFormField<int>(
                value: selectedPetId,
                items: pets.map((pet) {
                  return DropdownMenuItem<int>(
                    value: pet['id'],
                    child: Text("${pet['nome']} (${pet['raca']})"),
                  );
                }).toList(),
                onChanged: (v) => setState(() => selectedPetId = v),
                decoration: InputDecoration(
                  labelText: "Selecione o Pet",
                  filled: true,
                  fillColor: Colors.grey[900],
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                dropdownColor: Colors.grey[900],
                validator: (v) => v == null ? "Selecione um pet" : null,
              ),
              const SizedBox(height: 12),

              // Combo Veterinários
              DropdownButtonFormField<int>(
                value: selectedVetId,
                items: veterinarios.map((vet) {
                  return DropdownMenuItem<int>(
                    value: vet['id'],
                    child: Text(vet['nome']),
                  );
                }).toList(),
                onChanged: (v) => setState(() => selectedVetId = v),
                decoration: InputDecoration(
                  labelText: "Selecione o Veterinário",
                  filled: true,
                  fillColor: Colors.grey[900],
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                dropdownColor: Colors.grey[900],
                validator: (v) => v == null ? "Selecione um veterinário" : null,
              ),
              const SizedBox(height: 12),

              // Data
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                    text: selectedDate == null
                        ? ""
                        : "${selectedDate!.day.toString().padLeft(2,'0')}/${selectedDate!.month.toString().padLeft(2,'0')}/${selectedDate!.year}"),
                onTap: selecionarData,
                decoration: InputDecoration(
                  labelText: "Data",
                  filled: true,
                  fillColor: Colors.grey[900],
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  suffixIcon: const Icon(Icons.calendar_today, color: Colors.white70),
                ),
                validator: (v) => v!.isEmpty ? "Selecione a data" : null,
              ),
              const SizedBox(height: 12),

              // Hora
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                    text: selectedTime == null
                        ? ""
                        : "${selectedTime!.hour.toString().padLeft(2,'0')}:${selectedTime!.minute.toString().padLeft(2,'0')}"),
                onTap: selecionarHora,
                decoration: InputDecoration(
                  labelText: "Hora",
                  filled: true,
                  fillColor: Colors.grey[900],
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  suffixIcon: const Icon(Icons.access_time, color: Colors.white70),
                ),
                validator: (v) => v!.isEmpty ? "Selecione a hora" : null,
              ),
              const SizedBox(height: 24),

              // Botão Salvar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : salvarConsulta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Salvar", style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 12),

              // Botão Ver Consultas
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/consultas', arguments: widget.userData),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text("Ver Consultas", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}