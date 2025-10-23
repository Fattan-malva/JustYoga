import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import '../constants/colors.dart';
import '../models/activation.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showLogin = true;
  bool isActivationMode = false; // <--- Tambahkan flag baru
  bool obscurePassword = true;
  bool obscureConfirm = true;
  bool _loading = false;

  final _loginForm = GlobalKey<FormState>();
  final _signupForm = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController emailSignupController = TextEditingController();
  final TextEditingController phoneSignupController = TextEditingController();
  final TextEditingController nikSignupController = TextEditingController();
  final TextEditingController birthDateSignupController =
      TextEditingController();

  final TextEditingController passwordActivationController =
      TextEditingController();
  final TextEditingController confirmPasswordActivationController =
      TextEditingController();

  ActivationModel? _activationData;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final headerGradient = const LinearGradient(
      colors: [
        AppColors.primary,
        Color(0xFFD64548),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    // Tentukan judul & subtitle berdasarkan mode
    String titleText = "Welcome Back to Your Inner Space";
    String subtitleText = "Continue your journey of balance and mindfulness";

    if (isActivationMode) {
      titleText = "Link Your Membership to the App";
      subtitleText = "Activate your membership and unlock full access";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 64),
                Center(
                  child: Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/JYicon.png',
                        width: 84,
                        height: 84,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Title & subtitle (berubah dinamis)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    children: [
                      Text(
                        titleText,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitleText,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: showLogin ? _buildLoginForm() : _buildSignupForm(),
                ),

                const SizedBox(height: 40),
              ],
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Email",
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _buildStyledInput(
              hint: "jane@example.com",
              controller: usernameController,
              validator: Validators.validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 18),
            Text(
              "Password",
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _buildStyledInput(
              hint: "••••••••••",
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
            const SizedBox(height: 20),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : _buildPrimaryActionButton("LOG IN", _submitLogin),
            const SizedBox(height: 18),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Forgot Password?",
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Already a student?  ",
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                  children: [
                    TextSpan(
                      text: "Activate Account",
                      style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => setState(() {
                              showLogin = false;
                              isActivationMode =
                                  true; // <-- ubah title ke mode aktivasi
                            }),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "New here?  Create your Just Yoga journey today  |  ",
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            showLogin = false;
                            isActivationMode =
                                false; // <-- ubah ke mode signup biasa
                          });
                        },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- SIGNUP FORM ----------------
  Widget _buildSignupForm() {
    if (_activationData != null) {
      return _buildActivationResult();
    } else if (_errorMessage != null) {
      return _buildErrorMessage();
    } else {
      return Padding(
        key: const ValueKey('signupForm'),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _signupForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 6),
              Text(
                "Phone",
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildStyledInput(
                hint: "Phone",
                controller: phoneSignupController,
                validator: (v) =>
                    v == null || v.isEmpty ? "Phone number required" : null,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 18),
              Text(
                "Email",
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildStyledInput(
                hint: "Email",
                controller: emailSignupController,
                validator: Validators.validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),
              Text(
                "NIK/ID",
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildStyledInput(
                hint: "NIK/ID",
                controller: nikSignupController,
                validator: (v) => v == null || v.isEmpty ? "NIK required" : null,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 18),
              Text(
                "Birth Date",
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildStyledInput(
                hint: "Birth Date (YYYY-MM-DD)",
                controller: birthDateSignupController,
                validator: (v) =>
                    v == null || v.isEmpty ? "Birth date required" : null,
                keyboardType: TextInputType.datetime,
                suffix: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(1990),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      birthDateSignupController.text =
                          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(Icons.calendar_today_rounded, size: 22),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildPrimaryActionButton("ACTIVATE", _submitSignup),
              const SizedBox(height: 16),
              Center(
                child: RichText(
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
                          ..onTap = () => setState(() {
                                showLogin = true;
                                isActivationMode = false; // reset mode
                              }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    }
  }

  // --- sisanya (activation result, buildInput, _submitLogin, dll) tetap sama ---
  // kamu tidak perlu ubah bagian bawah kode
  
  Widget _buildActivationResult() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Activation Data",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDataRow("Customer ID", _activationData!.customerID),
                  _buildDataRow("Name", _activationData!.name),
                  _buildDataRow("Birth Date", _activationData!.birthDate),
                  _buildDataRow("Phone", _activationData!.phone),
                  _buildDataRow("NIK", _activationData!.noIdentity),
                  _buildDataRow("Email", _activationData!.email),
                  _buildDataRow(
                      "Last Contract ID", _activationData!.lastContractID),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Form(
            key: _signupForm,
            child: Column(
              children: [
                _buildInput(
                  hint: "Password",
                  controller: passwordActivationController,
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
                  controller: confirmPasswordActivationController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm password required";
                    }
                    if (value != passwordActivationController.text) {
                      return "Passwords do not match";
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
                    : _buildGradientButton(
                        "Activate Account", _submitActivation),
                const SizedBox(height: 16),
                _buildGradientButton("Back", () {
                  setState(() {
                    _activationData = null;
                    _errorMessage = null;
                    passwordActivationController.clear();
                    confirmPasswordActivationController.clear();
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _errorMessage!,
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildGradientButton("Back", () {
            setState(() {
              _activationData = null;
              _errorMessage = null;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Styled input (mirip gambar) ----------------
  Widget _buildStyledInput({
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscure = false,
    Widget? suffix,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.black87, width: 1.6),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary, width: 1.8),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffix,
      ),
    );
  }

  // ---------------- kept original _buildInput (used in activation result) ----------------
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

  // ---------------- Primary big red button like image ----------------
  Widget _buildPrimaryActionButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF9C0E0E),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text.toUpperCase(),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- original gradient button retained for other places ----------------
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
      final response = await auth.checkActivation(
        emailSignupController.text,
        phoneSignupController.text,
        nikSignupController.text,
        birthDateSignupController.text,
      );

      if (response != null && response.containsKey('customerID')) {
        setState(() {
          _activationData = ActivationModel.fromJson(response);
          _errorMessage = null;
        });
      } else {
        setState(() {
          _errorMessage = response != null && response.containsKey('message')
              ? response['message']
              : 'No activation data found or invalid response';
          _activationData = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _activationData = null;
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _submitActivation() async {
    if (!_signupForm.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final response = await auth.createActivation(
        _activationData!.customerID,
        _activationData!.name,
        '', // toStudioID - need to determine how to get this
        _activationData!.lastContractID,
        _activationData!.noIdentity,
        _activationData!.birthDate,
        _activationData!.phone,
        _activationData!.email,
        passwordActivationController.text,
      );

      if (response != null && response.containsKey('message')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        // Reset form and switch back to login
        setState(() {
          showLogin = true;
          _activationData = null;
          _errorMessage = null;
          emailSignupController.clear();
          phoneSignupController.clear();
          nikSignupController.clear();
          birthDateSignupController.clear();
          passwordActivationController.clear();
          confirmPasswordActivationController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Activation failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Activation error: $e")),
      );
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
