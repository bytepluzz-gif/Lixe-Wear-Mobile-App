import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "LuxeWear",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: const Color(0xFF4A7043),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Create Account",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF042404),
              ),
            ),
            Text(
              "Join our community and start your journey.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 40),

            _buildField("Full Name", _nameController, false),
            const SizedBox(height: 20),
            _buildField("Email Address", _emailController, false),
            const SizedBox(height: 20),
            _buildField("Password", _passwordController, true),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _loading
                    ? null
                    : () async {
                        if (_nameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Enter full name')),
                          );
                          return;
                        }
                        if (!_emailController.text.contains('@')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Enter a valid email')),
                          );
                          return;
                        }
                        if (_passwordController.text.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Password must be at least 6 characters',
                              ),
                            ),
                          );
                          return;
                        }
                        try {
                          setState(() => _loading = true);
                          await context.read<AppAuthProvider>().register(
                                _nameController.text.trim(),
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );
                          if (!context.mounted) return;
                          Navigator.pushReplacementNamed(context, '/home');
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Registration failed: $e')),
                          );
                        } finally {
                          if (mounted) setState(() => _loading = false);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF042404),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 30),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "OR CONTINUE WITH",
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF757575),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: _loading
                    ? null
                    : () async {
                        final nav = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);
                        try {
                          setState(() => _loading = true);
                          await context.read<AppAuthProvider>().signInWithGoogle();
                          if (!context.mounted) return;
                          nav.pushReplacementNamed('/home');
                        } catch (e) {
                          if (!context.mounted) return;
                          messenger.showSnackBar(
                            SnackBar(content: Text('Google sign-in failed: $e')),
                          );
                        } finally {
                          if (mounted) setState(() => _loading = false);
                        }
                      },
                icon: const Icon(Icons.g_mobiledata, size: 28),
                label: Text(
                  "Google",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text.rich(
                TextSpan(
                  text: "Already have an account? ",
                  style: GoogleFonts.poppins(color: const Color(0xFF424242)),
                  children: [
                    TextSpan(
                      text: "Sign In",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A7043),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
            Text(
              "By creating an account, you agree to our Terms of Service\nand Privacy Policy.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: const Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    bool isPassword,
  ) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
