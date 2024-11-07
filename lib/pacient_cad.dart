import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class PacientCad extends StatefulWidget {
  final Map<String, dynamic>? paciente;
  final String? pacienteId;

  PacientCad({this.paciente, this.pacienteId});

  @override
  _PacientCadState createState() => _PacientCadState();
}

class _PacientCadState extends State<PacientCad> {
  // Controladores para os campos de texto
  final TextEditingController codigoController = TextEditingController();
  final MaskedTextController dataAdmissaoController =
      MaskedTextController(mask: '00/00/0000');
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController apelidoController = TextEditingController();
  final MaskedTextController dataNascimentoController =
      MaskedTextController(mask: '00/00/0000');
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController semanasPrematuroController =
      TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController paisController = TextEditingController();
  final TextEditingController profissaoController = TextEditingController();
  final TextEditingController religiaoController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController complementoController = TextEditingController();
  final TextEditingController cepController = TextEditingController();

  // Variáveis adicionais
  String sexo = 'Masculino';
  bool prematuro = false;
  String? pacienteId;

  @override
  void initState() {
    super.initState();
    if (widget.paciente != null) {
      _loadPatientData(widget.paciente!);
      pacienteId = widget.pacienteId;
    }
  }

  // Função para buscar o próximo código sequencial
  Future<void> _getNextCodigo() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('pacientes')
        .orderBy('codigo', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      int ultimoCodigo = int.tryParse(querySnapshot.docs.first['codigo']) ?? 0;
      codigoController.text = (ultimoCodigo + 1).toString();
    } else {
      codigoController.text = '1';
    }
  }

  // Função para salvar ou atualizar dados no Firestore
  Future<void> _savePatientData() async {
    final codigo = codigoController.text;

    if (codigo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Código inválido!')),
      );
      return;
    }

    try {
      if (pacienteId != null) {
        // Atualizar paciente existente
        await FirebaseFirestore.instance
            .collection('pacientes')
            .doc(pacienteId)
            .update({
          'dataAdmissao': dataAdmissaoController.text,
          'nome': nomeController.text,
          'apelido': apelidoController.text,
          'dataNascimento': dataNascimentoController.text,
          'idade': idadeController.text,
          'sexo': sexo,
          'prematuro': prematuro,
          'semanasPrematuro': semanasPrematuroController.text,
          'cidade': cidadeController.text,
          'pais': paisController.text,
          'profissao': profissaoController.text,
          'religiao': religiaoController.text,
          'telefone': telefoneController.text,
          'email': emailController.text,
          'rua': ruaController.text,
          'numero': numeroController.text,
          'complemento': complementoController.text,
          'cep': cepController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados atualizados com sucesso!')),
        );
      } else {
        // Adicionar novo paciente
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('pacientes')
            .add({
          'codigo': codigo,
          'dataAdmissao': dataAdmissaoController.text,
          'nome': nomeController.text,
          'apelido': apelidoController.text,
          'dataNascimento': dataNascimentoController.text,
          'idade': idadeController.text,
          'sexo': sexo,
          'prematuro': prematuro,
          'semanasPrematuro': semanasPrematuroController.text,
          'cidade': cidadeController.text,
          'pais': paisController.text,
          'profissao': profissaoController.text,
          'religiao': religiaoController.text,
          'telefone': telefoneController.text,
          'email': emailController.text,
          'rua': ruaController.text,
          'numero': numeroController.text,
          'complemento': complementoController.text,
          'cep': cepController.text,
        });
        pacienteId = docRef.id;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados salvos com sucesso!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar os dados: $e')),
      );
    }
  }

  // Função para carregar os dados do paciente selecionado
  void _loadPatientData(Map<String, dynamic> patientData) {
    codigoController.text = patientData['codigo'];
    dataAdmissaoController.text = patientData['dataAdmissao'];
    nomeController.text = patientData['nome'];
    apelidoController.text = patientData['apelido'];
    dataNascimentoController.text = patientData['dataNascimento'];
    idadeController.text = patientData['idade'];
    sexo = patientData['sexo'];
    prematuro = patientData['prematuro'];
    semanasPrematuroController.text = patientData['semanasPrematuro'];
    cidadeController.text = patientData['cidade'];
    paisController.text = patientData['pais'];
    profissaoController.text = patientData['profissao'];
    religiaoController.text = patientData['religiao'];
    telefoneController.text = patientData['telefone'];
    emailController.text = patientData['email'];
    ruaController.text = patientData['rua'];
    numeroController.text = patientData['numero'];
    complementoController.text = patientData['complemento'];
    cepController.text = patientData['cep'];
    setState(() {});
  }

  // Função para excluir dados do Firestore
  Future<void> _deletePatientData() async {
    if (pacienteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paciente não encontrado!')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('pacientes')
          .doc(pacienteId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dados excluídos com sucesso!')),
      );
      _clearFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir os dados: $e')),
      );
    }
  }

  // Função para limpar os campos de texto
  void _clearFields() {
    codigoController.clear();
    dataAdmissaoController.clear();
    nomeController.clear();
    apelidoController.clear();
    dataNascimentoController.clear();
    idadeController.clear();
    semanasPrematuroController.clear();
    cidadeController.clear();
    paisController.clear();
    profissaoController.clear();
    religiaoController.clear();
    telefoneController.clear();
    emailController.clear();
    ruaController.clear();
    numeroController.clear();
    complementoController.clear();
    cepController.clear();
    sexo = 'Masculino';
    prematuro = false;
    pacienteId = null;
    setState(() {});
  }

  // Função para abrir a tela de pesquisa de pacientes
  Future<void> _searchPatient() async {
    final selectedPatient = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PatientSearchScreen()),
    );
    if (selectedPatient != null) {
      _loadPatientData(selectedPatient.data() as Map<String, dynamic>);
      pacienteId = selectedPatient.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cadastro de Pacientes'),
          bottom: TabBar(
            indicatorColor: Colors.green,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: 'Dados Gerais'),
              Tab(text: 'Contato e Endereço'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Aba: Dados Gerais
            SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dados Pessoais',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: codigoController,
                          decoration: InputDecoration(
                              labelText: 'Código',
                              border: OutlineInputBorder()),
                          readOnly: true,
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _searchPatient,
                        child: Text('Pesquisar'),
                      ),
                    ],
                  ),
                                    SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: dataAdmissaoController,
                          decoration: InputDecoration(
                              labelText: 'Data Admissão',
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nomeController,
                          decoration: InputDecoration(
                              labelText: 'Nome Completo',
                              border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: apelidoController,
                          decoration: InputDecoration(
                              labelText: 'Apelido',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: dataNascimentoController,
                          decoration: InputDecoration(
                              labelText: 'Data Nascimento',
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: idadeController,
                          decoration: InputDecoration(
                              labelText: 'Idade', border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: sexo,
                          decoration: InputDecoration(
                              labelText: 'Sexo', border: OutlineInputBorder()),
                          items: ['Masculino', 'Feminino']
                              .map((sexo) => DropdownMenuItem(
                                  value: sexo, child: Text(sexo)))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => sexo = value ?? 'Masculino'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                          value: prematuro,
                          onChanged: (bool? value) =>
                              setState(() => prematuro = value ?? false)),
                      Text('Prematuro'),
                    ],
                  ),
                  TextField(
                    controller: semanasPrematuroController,
                    decoration: InputDecoration(
                        labelText: 'Semanas Prematuro',
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: cidadeController,
                          decoration: InputDecoration(
                              labelText: 'Cidade',
                              border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: paisController,
                          decoration: InputDecoration(
                              labelText: 'País', border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: profissaoController,
                          decoration: InputDecoration(
                              labelText: 'Profissão',
                              border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: religiaoController,
                          decoration: InputDecoration(
                              labelText: 'Religião',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _savePatientData,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: Text('Salvar'),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () async {
                            _clearFields();
                            await _getNextCodigo();
                          },
                          child: Text('Novo'),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _deletePatientData,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: Text('Excluir'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Aba: Contato e Endereço
            SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contato e Endereço',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 20),
                  TextField(
                      controller: telefoneController,
                      decoration: InputDecoration(
                          labelText: 'Telefone', border: OutlineInputBorder())),
                  SizedBox(height: 20),
                  TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: 'Email', border: OutlineInputBorder())),
                  SizedBox(height: 20),
                  TextField(
                      controller: ruaController,
                      decoration: InputDecoration(
                          labelText: 'Rua', border: OutlineInputBorder())),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                            controller: numeroController,
                            decoration: InputDecoration(
                                labelText: 'Número',
                                border: OutlineInputBorder())),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                            controller: complementoController,
                            decoration: InputDecoration(
                                labelText: 'Complemento',
                                border: OutlineInputBorder())),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                      controller: cepController,
                      decoration: InputDecoration(
                          labelText: 'CEP', border: OutlineInputBorder())),
                  SizedBox(height: 30),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _savePatientData,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: Text('Salvar'),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _clearFields,
                          child: Text('Novo'),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _deletePatientData,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: Text('Excluir'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tela de pesquisa de pacientes
class PatientSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pesquisar Paciente')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pacientes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Nenhum paciente encontrado'));
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['nome'] ?? ''),
                subtitle: Text('Código: ${data['codigo'] ?? ''}'),
                onTap: () {
                  Navigator.pop(context, doc);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
