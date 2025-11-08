import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ConsultasScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ConsultasScreen({super.key, required this.userData});

  @override
  State<ConsultasScreen> createState() => _ConsultasScreenState();
}

class _ConsultasScreenState extends State<ConsultasScreen> {
  List<dynamic> consultas = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    carregarConsultas();
  }

  Future<void> carregarConsultas() async {
    setState(() => loading = true);
    try {
      final donoId = widget.userData['id'];
      final result = await ApiService.getConsultas(donoId);

      if (result['status'] == true) {
        final data = result['data'];
        if (data != null && data['data'] != null) {
          setState(() => consultas = List<dynamic>.from(data['data']));
        } else {
          setState(() => consultas = []);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? "Erro ao carregar consultas")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: ${e.toString()}")),
      );
    } finally {
      setState(() => loading = false);
    }
  }


  Future<void> excluirConsulta(int consultaId) async {
    setState(() => loading = true);
    try {
      final result = await ApiService.deleteConsulta(consultaId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Consulta excluída com sucesso")),
      );
      if (result['status'] == true) {
        await carregarConsultas(); // Atualiza lista
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao excluir: ${e.toString()}")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Minhas Consultas"),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: carregarConsultas,
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.tealAccent))
          : consultas.isEmpty
          ? const Center(
        child: Text(
          "Nenhuma consulta agendada 😿",
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: consultas.length,
        itemBuilder: (context, index) {
          final consulta = consultas[index];

          // Pega os dados com segurança
          final pet = consulta['pet'] as Map<String, dynamic>?;
          final vet = consulta['veterinario'] as Map<String, dynamic>?;
          final petNome = pet?['nome'] ?? 'Não informado';
          final vetNome = vet?['nome'] ?? 'Não informado';
          final data = consulta['data'] ?? '---';
          final hora = consulta['hora'] ?? '---';

          return Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(
                "Pet: $petNome",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Veterinário: $vetNome",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "Data: $data - Hora: $hora",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Excluir Consulta"),
                    content: const Text("Deseja realmente excluir esta consulta?"),
                    backgroundColor: Colors.grey[900],
                    titleTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 18),
                    contentTextStyle:
                    const TextStyle(color: Colors.white70),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancelar",
                            style: TextStyle(color: Colors.tealAccent)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          excluirConsulta(consulta['id']);
                        },
                        child: const Text("Excluir",
                            style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
