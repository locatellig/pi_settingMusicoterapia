import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screen_menu.dart'; // Importe a tela para navegação

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _showErrorDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Erro'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Exibe uma mensagem de sucesso com SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login realizado com sucesso!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Navega para a tela `ScreenMenu` após o login bem-sucedido
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ScreenMenu()),
        );
      } on FirebaseAuthException catch (e) {
        // Tratamento de erros específicos para melhorar a experiência do usuário
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'Usuário não encontrado. Por favor, verifique seu e-mail.';
            break;
          case 'wrong-password':
            message = 'Senha incorreta. Verifique sua senha e tente novamente.';
            break;
          case 'invalid-email':
            message = 'E-mail inválido. Por favor, insira um e-mail válido.';
            break;
          default:
            message = 'Erro no login. Tente novamente mais tarde.';
        }

        // Exibe a mensagem de erro usando o diálogo customizado
        await _showErrorDialog(context, message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Setting de Musicoterapia',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Image.asset(
                    'images/NotaMusical.png',
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu e-mail';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua senha';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _login(context),
                    child: Text('Entrar'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                      backgroundColor: Colors.green,
                    ),
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
