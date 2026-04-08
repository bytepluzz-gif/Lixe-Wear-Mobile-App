import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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

            _buildField("Full Name", "John Doe", Icons.person_outline),
            const SizedBox(height: 20),
            _buildField(
              "Email Address",
              "john@example.com",
              Icons.email_outlined,
            ),
            const SizedBox(height: 20),
            _buildField(
              "Password",
              "••••••••",
              Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            _buildField(
              "Confirm Password",
              "••••••••",
              Icons.shield_outlined,
              isPassword: true,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF042404),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  "Create Account",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

            Row(
              children: [
                _socialButton(
                  "Google",
                  "https://img.icons8.com/color/48/google-logo.png",
                ),
                const SizedBox(width: 16),
                _socialButton(
                  "Apple",
                  "https://img.icons8.com/ios-filled/50/000000/mac-os.png",
                ),
              ],
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
    String hint,
    IconData icon, {
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: const Color(0xFF424242),
            ),
          ),
        ),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: const Color(0xFFBDBDBD)),
            prefixIcon: Icon(icon, color: const Color(0xFF757575), size: 20),
            suffixIcon: isPassword
                ? Icon(
                    Icons.visibility_off_outlined,
                    color: const Color(0xFFBDBDBD),
                    size: 20,
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: const Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: const Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Color(0xFF4A7043),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialButton(String text, String iconUrl) {
    return Expanded(
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0E8),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              iconUrl,
              height: 24,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
