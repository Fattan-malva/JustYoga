import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final ok = await auth.login(_email.text, _password.text);
    setState(() => _loading = false);
    if (ok) Navigator.pushReplacementNamed(context, '/main');
    // If using real API, check response and tokens here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Masuk')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: _email,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: Validators.validateEmail),
              SizedBox(height: 12),
              TextFormField(
                  controller: _password,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: Validators.validatePassword),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Login')),
              SizedBox(height: 12),
              TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, RegisterScreen.routeName),
                  child: Text('Belum punya akun? Daftar'))
            ],
          ),
        ),
      ),
    );
  }
}
