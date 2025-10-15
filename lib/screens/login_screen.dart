import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import '../constants/colors.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showLogin = true;
  bool obscurePassword = true;
  bool obscureConfirm = true;
  bool _loading = false;

  final _loginForm = GlobalKey<FormState>();
  final _signupForm = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController nameSignupController = TextEditingController();
  final TextEditingController emailSignupController = TextEditingController();
  final TextEditingController passwordSignupController =
      TextEditingController();
  final TextEditingController confirmSignupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ======== HEADER MELENGKUNG SEPERTI GAMBAR ========
          ClipPath(
            clipper: _HeaderClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary, // #94191C - warna utama
                    Color(0xFFD64548), // merah terang
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 80,
                    child: Text(
                      showLogin ? "Login" : "Sign Up",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ======== FORM AREA ========
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 260, bottom: 40),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                child: showLogin ? _buildLoginForm() : _buildSignupForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- LOGIN FORM ----------------
  Widget _buildLoginForm() {
    return Padding(
      key: const ValueKey('loginForm'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _loginForm,
        child: Column(
          children: [
            _buildInput(
              hint: "Email or Phone number",
              controller: usernameController,
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 16),
            _buildInput(
              hint: "Password",
              controller: passwordController,
              validator: Validators.validatePassword,
              obscure: obscurePassword,
              suffix: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () =>
                    setState(() => obscurePassword = !obscurePassword),
              ),
            ),
            const SizedBox(height: 24),
            _loading
                ? const CircularProgressIndicator()
                : _buildGradientButton("Login", _submitLogin),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: Text(
                "Forgot Password?",
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),
            RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: GoogleFonts.poppins(color: Colors.black87),
                children: [
                  TextSpan(
                    text: "Sign up",
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => setState(() => showLogin = false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- SIGNUP FORM ----------------
  Widget _buildSignupForm() {
    return Padding(
      key: const ValueKey('signupForm'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _signupForm,
        child: Column(
          children: [
            _buildInput(
              hint: "Full Name",
              controller: nameSignupController,
              validator: (v) =>
                  v == null || v.isEmpty ? "Full name required" : null,
            ),
            const SizedBox(height: 16),
            _buildInput(
              hint: "Email",
              controller: emailSignupController,
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 16),
            _buildInput(
              hint: "Password",
              controller: passwordSignupController,
              validator: Validators.validatePassword,
              obscure: obscurePassword,
              suffix: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () =>
                    setState(() => obscurePassword = !obscurePassword),
              ),
            ),
            const SizedBox(height: 16),
            _buildInput(
              hint: "Confirm Password",
              controller: confirmSignupController,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please confirm password';
                if (v != passwordSignupController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              obscure: obscureConfirm,
              suffix: IconButton(
                icon: Icon(
                  obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () =>
                    setState(() => obscureConfirm = !obscureConfirm),
              ),
            ),
            const SizedBox(height: 24),
            _loading
                ? const CircularProgressIndicator()
                : _buildGradientButton("Sign Up", _submitSignup),
            const SizedBox(height: 24),
            RichText(
              text: TextSpan(
                text: "Already have an account? ",
                style: GoogleFonts.poppins(color: Colors.black87),
                children: [
                  TextSpan(
                    text: "Login",
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => setState(() => showLogin = true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- INPUT FIELD ----------------
  Widget _buildInput({
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          border: InputBorder.none,
          suffixIcon: suffix,
        ),
      ),
    );
  }

  // ---------------- GRADIENT BUTTON ----------------
  Widget _buildGradientButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, const Color(0xFF801012)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- LOGIN LOGIC ----------------
  Future<void> _submitLogin() async {
    if (!_loginForm.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final ok =
          await auth.login(usernameController.text, passwordController.text);
      if (ok) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed")),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _submitSignup() async {
    if (!_signupForm.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final ok = await auth.register(
        nameSignupController.text,
        emailSignupController.text,
        passwordSignupController.text,
      );
      if (ok) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration failed")),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }
}

// ======= CLIPPER BARU UNTUK HEADER SEPERTI GAMBAR =======
class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    
    // Mulai dari kiri atas
    path.lineTo(0, size.height - 100);
    
    // Kurva pertama (lebih landai)
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height - 20,
      size.width * 0.5,
      size.height - 40,
    );
    
    // Kurva kedua (lebih curam)
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height - 60,
      size.width,
      size.height - 100,
    );
    
    // Ke kanan atas dan tutup path
    path.lineTo(size.width, 0);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}