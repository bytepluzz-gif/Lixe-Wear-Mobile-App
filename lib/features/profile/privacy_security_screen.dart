import 'package:flutter/material.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy & Security")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security Status
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF4A7043),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Icon(Icons.shield, size: 60, color: Colors.white),
                  SizedBox(height: 12),
                  Text("Your account is well protected.", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Last security check: 2 days ago", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text("Active Sessions", style: TextStyle(fontWeight: FontWeight.bold)),
            _sessionTile("iPhone 14 Pro", "New York, USA", "Current session"),
            _sessionTile("MacBook Pro", "Colombo, Sri Lanka", "2 days ago"),

            const SizedBox(height: 30),

            // Security Settings
            const Text("SECURITY SETTINGS", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
            _securityTile("Change Password", Icons.lock),
            _securityTile("Two-Factor Authentication", Icons.verified_user, isOn: true),
            _securityTile("Connected Devices", Icons.devices),
            _securityTile("Biometric Login", Icons.fingerprint, isOn: true),

            const SizedBox(height: 30),

            // Privacy Controls
            const Text("PRIVACY CONTROLS", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
            SwitchListTile(title: const Text("Private Profile"), value: false, onChanged: (v) {}),
            SwitchListTile(title: const Text("Data Sharing"), value: true, onChanged: (v) {}),
            ListTile(title: const Text("Download Personal Data"), trailing: const Icon(Icons.download)),
            ListTile(title: const Text("Deactivate Account"), trailing: const Icon(Icons.arrow_forward), textColor: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _sessionTile(String device, String location, String time) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.devices),
        title: Text(device),
        subtitle: Text(location),
        trailing: Text(time, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _securityTile(String title, IconData icon, {bool isOn = false}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: isOn ? const Icon(Icons.check_circle, color: Color(0xFF4A7043)) : const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}