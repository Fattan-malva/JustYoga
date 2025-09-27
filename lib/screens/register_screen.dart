import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final ok = await auth.register(_name.text, _email.text, _password.text);
    setState(() => _loading = false);
    if (ok) Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                  controller: _name,
                  decoration: InputDecoration(labelText: 'Nama lengkap'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Nama diperlukan' : null),
              SizedBox(height: 12),
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
                      : Text('Daftar')),
            ],
          ),
        ),
      ),
    );
  }
}
