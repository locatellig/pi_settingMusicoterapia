import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';

class AgendaConsulta extends StatelessWidget {
  final TextEditingController _nomeController = TextEditingController();
  final MaskedTextController _dataController =
      MaskedTextController(mask: '00/00/0000');
  final MaskedTextController _horaController =
      MaskedTextController(mask: '00:00');

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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome do Paciente',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Lógica para buscar o paciente na tabela
                    _abrirBuscaPaciente(context);
                  },
                ),
              ],
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
              onPressed: () async {
                // Lógica para agendar a consulta
                String nome = _nomeController.text;
                String data = _dataController.text;
                String hora = _horaController.text;

                if (nome.isEmpty || data.isEmpty || hora.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Todos os campos devem ser preenchidos para agendar a consulta.'),
                    ),
                  );
                  return;
                }

                // Validação para verificar se a data não é menor que a data atual
                try {
                  DateTime dataConsulta = DateFormat('dd/MM/yyyy').parseStrict(data);
                  DateTime dataAtual = DateTime.now();
                  DateTime dataAtualSemHora = DateTime(dataAtual.year, dataAtual.month, dataAtual.day);
                  if (dataConsulta.isBefore(dataAtualSemHora)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('A data da consulta não pode ser menor que a data atual.'),
                      ),
                    );
                    return;
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Data inválida. Por favor, insira uma data válida no formato dd/mm/aaaa.'),
                    ),
                  );
                  return;
                }

                // Validação para verificar se a hora está no formato correto e é válida
                try {
                  DateTime horaConsulta = DateFormat('HH:mm').parseStrict(hora);
                  if (horaConsulta.hour < 0 || horaConsulta.hour > 23 || horaConsulta.minute < 0 || horaConsulta.minute > 59) {
                    throw FormatException('Hora inválida');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Hora inválida. Por favor, insira uma hora válida no formato hh:mm.'),
                    ),
                  );
                  return;
                }

                // Salvar os dados da consulta no Firestore
                try {
                  await FirebaseFirestore.instance.collection('consultas').add({
                    'nome': nome,
                    'data': data,
                    'hora': hora,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Consulta agendada para $nome em $data às $hora'),
                    ),
                  );

                  // Limpa os campos após o agendamento
                  _nomeController.clear();
                  _dataController.clear();
                  _horaController.clear();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao salvar consulta: $e'),
                    ),
                  );
                }
              },
              child: Text('Agendar Consulta'),
            ),
          ],
        ),
      ),
    );
  }

  void _abrirBuscaPaciente(BuildContext context) async {
    try {
      // Busca na coleção "pacientes" do Firestore, filtrando apenas os que possuem código
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('pacientes')
          .where('codigo', isNotEqualTo: null)
          .get();

      if (snapshot.docs.isEmpty) {
        // Nenhum paciente encontrado
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Nenhum Paciente Encontrado'),
              content: Text('Não há pacientes cadastrados.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Fechar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Lista de pacientes encontrada
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Selecionar Paciente'),
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.docs.length,
                  itemBuilder: (context, index) {
                    var paciente = snapshot.docs[index].data();
                    return ListTile(
                      title: Text(paciente['nome'] ?? 'Nome não disponível'),
                      onTap: () {
                        _nomeController.text = paciente['nome'] ?? '';
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Fechar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Exibe um erro caso a busca falhe
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar pacientes: $e'),
        ),
      );
    }
  }
}
