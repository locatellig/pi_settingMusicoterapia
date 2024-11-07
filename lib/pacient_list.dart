import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import 'pacient_cad.dart'; // Importar a tela de cadastro de pacientes

class PacientList extends StatefulWidget {
  @override
  _PacientListState createState() => _PacientListState();
}

class _PacientListState extends State<PacientList> {
  Map<String, String> filters = {};
  var dataAdmissaoController = MaskedTextController(mask: '00/00/0000');

  void updateFilter(String key, String value) {
    setState(() {
      filters[key] = value;
    });
  }

  bool matchesFilter(Map<String, dynamic> data) {
    for (var key in filters.keys) {
      if (filters[key] != null && filters[key]!.isNotEmpty) {
        if (!data.containsKey(key) || !data[key].toString().toLowerCase().contains(filters[key]!.toLowerCase())) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pacientes'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lista de Pacientes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Cabeçalhos de colunas
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      // Atualizar o filtro de código
                      updateFilter('codigo', value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Código',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      // Atualizar o filtro de nome
                      updateFilter('nome', value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: dataAdmissaoController,
                    onChanged: (value) {
                      // Atualizar o filtro de data de admissão
                      updateFilter('dataAdmissao', value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Data Admissão',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Espaço entre os campos e a lista
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('pacientes').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Nenhum paciente encontrado.'));
                  }

                  final pacientes = snapshot.data!.docs.where((paciente) {
                    final data = paciente.data() as Map<String, dynamic>;
                    return data.containsKey('codigo') && matchesFilter(data);
                  }).toList();

                  // Ordena a lista de pacientes pelo campo 'codigo'
                  pacientes.sort((a, b) {
                    final codigoA = (a.data() as Map<String, dynamic>)['codigo'] ?? '';
                    final codigoB = (b.data() as Map<String, dynamic>)['codigo'] ?? '';
                    return codigoA.toString().compareTo(codigoB.toString());
                  });

                  return ListView.builder(
                    itemCount: pacientes.length,
                    itemBuilder: (context, index) {
                      final paciente = pacientes[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text((paciente.data() as Map<String, dynamic>)['nome'] ?? 'Nome não disponível'),
                          subtitle: Text('Código: ${(paciente.data() as Map<String, dynamic>)['codigo'] ?? 'N/A'} | Data: ${(paciente.data() as Map<String, dynamic>)['dataAdmissao'] ?? 'N/A'}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PacientCad(
                                  paciente: paciente.data() as Map<String, dynamic>?,
                                  pacienteId: paciente.id,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
