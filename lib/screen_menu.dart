import 'package:flutter/material.dart';
import 'pacient_cad.dart';
import 'pacient_list.dart';
import 'func_cad.dart';
import 'agendaconsulta.dart';

class ScreenMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade300, Colors.teal.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 40),
            Image.asset(
              'images/NotaMusical.png',
              height: 150,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // Botão 1 - Cadastro de Pacientes
                    _buildMenuButton(
                      context,
                      'Cadastro de Pacientes',
                      Icons.person_add,
                      Colors.greenAccent,
                      PacientCad(),
                    ),
                    // Botão 2 - Lista de Pacientes
                    _buildMenuButton(
                      context,
                      'Lista de Pacientes',
                      Icons.list,
                      Colors.orangeAccent,
                      PacientList(),
                    ),
                    // Botão 3 - Cadastro de Funcionário
                    _buildMenuButton(
                      context,
                      'Cadastro de Funcionário',
                      Icons.badge,
                      Colors.blueAccent,
                      FuncCad(),
                    ),
                    // Botão 4 - Agendar Consulta
                    _buildMenuButton(
                      context,
                      'Agendar Consulta',
                      Icons.calendar_today,
                      Colors.pinkAccent,
                      AgendaConsulta(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String label, IconData icon, Color color, Widget targetScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 4),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}