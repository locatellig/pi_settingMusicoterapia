import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PesquisaConsulta extends StatefulWidget {
  @override
  _PesquisaConsultaState createState() => _PesquisaConsultaState();
}

class _PesquisaConsultaState extends State<PesquisaConsulta> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamentos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome do Paciente',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _searchQuery.isEmpty
                    ? FirebaseFirestore.instance.collection('consultas').snapshots()
                    : FirebaseFirestore.instance
                        .collection('consultas')
                        .where('nome', isGreaterThanOrEqualTo: _searchQuery)
                        .where('nome', isLessThanOrEqualTo: _searchQuery + '\uf8ff')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar agendamentos'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Nenhum agendamento encontrado'));
                  }

                  final consultas = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: consultas.length,
                    itemBuilder: (context, index) {
                      final consulta = consultas[index].data();
                      final consultaId = consultas[index].id;
                      return Card(
                        child: ListTile(
                          title: Text(consulta['nome'] ?? 'Nome não disponível'),
                          subtitle: Text('Data: ${consulta['data']} - Hora: ${consulta['hora']}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              // Confirmar exclusão
                              bool confirmar = await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Confirmar Exclusão'),
                                    content: Text('Você tem certeza que deseja excluir este agendamento?'),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Excluir'),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmar) {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('consultas')
                                      .doc(consultaId)
                                      .delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Agendamento excluído com sucesso'),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Erro ao excluir agendamento: $e'),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
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
