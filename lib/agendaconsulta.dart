import 'package:flutter/material.dart';

class AgendaConsulta extends StatelessWidget {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar Consulta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome do Paciente',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search), // Ícone de lupa à direita
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _dataController,
              decoration: InputDecoration(
                labelText: 'Data da Consulta (dd/mm/aaaa)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _horaController,
              decoration: InputDecoration(
                labelText: 'Hora da Consulta (hh:mm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Lógica para agendar a consulta
                String nome = _nomeController.text;
                String data = _dataController.text;
                String hora = _horaController.text;

                // Aqui você pode adicionar a lógica para salvar os dados ou enviar para um banco de dados
                // Por exemplo, você pode exibir um SnackBar com a confirmação
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Consulta agendada para $nome em $data às $hora'),
                  ),
                );

                // Limpa os campos após o agendamento
                _nomeController.clear();
                _dataController.clear();
                _horaController.clear();
              },
              child: Text('Agendar Consulta'),
            ),
          ],
        ),
      ),
    );
  }
}
