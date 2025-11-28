import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const MenuScreen({super.key, required this.userData});

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // limpa dados salvos

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (route) => false, // limpa todo o histórico
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,  // 🔥 impede botão voltar
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('PetCare - Menu'),
          backgroundColor: Colors.black,
          centerTitle: true,
          automaticallyImplyLeading: false, // 🔥 REMOVE A SETA DE VOLTAR
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _menuButton(
                label: "Ver Meus Pets",
                icon: Icons.pets,
                onTap: () => Navigator.pushNamed(context, '/pets', arguments: userData),
              ),
              const SizedBox(height: 20),
              _menuButton(
                label: "Cadastrar Pet",
                icon: Icons.add_circle_outline,
                onTap: () => Navigator.pushNamed(context, '/add_pet', arguments: userData),
              ),
              const SizedBox(height: 20),
              _menuButton(
                label: "Cadastrar Consulta",
                icon: Icons.assignment_add,
                onTap: () => Navigator.pushNamed(context, '/add_consulta', arguments: userData),
              ),
              const SizedBox(height: 20),
              _menuButton(
                label: "Ver Minhas Consultas",
                icon: Icons.calendar_today,
                onTap: () => Navigator.pushNamed(context, '/consultas', arguments: userData),
              ),
              const SizedBox(height: 30),

              // 🔥 BOTÃO DE SAIR
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text("Sair", style: TextStyle(color: Colors.white, fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => logout(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton({required String label, required IconData icon, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 28, color: Colors.white),
        label: Text(label, style: const TextStyle(fontSize: 18, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
