import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/auth_provider.dart';
import '../../core/firestore_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF042404),
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            color: const Color(0xFF042404),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Color(0xFF042404)),
            onPressed: () {},
          ),
        ],
      ),
      body: uid == null
          ? const Center(child: Text('Please sign in'))
          : StreamBuilder(
              stream: context.read<FirestoreService>().userProfileStream(uid),
              builder: (context, snapshot) {
                final data = snapshot.data?.data() ?? {};
                final name =
                    data['fullName'] as String? ?? user?.displayName ?? 'User';
                final email = data['email'] as String? ?? user?.email ?? '';
                return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Header
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFF0F0E8),
                    child: Icon(
                      Icons.person,
                      size: 48,
                      color: Color(0xFF4A7043),
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF042404),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF042404),
              ),
            ),
            Text(
              email,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF9E9E9E),
              ),
            ),
            const SizedBox(height: 40),

            // Menu Items
            _buildProfileMenu(
              Icons.person_outline,
              "Personal Information",
              onTap: () => Navigator.pushNamed(context, '/personal-info'),
            ),
            _buildProfileMenu(
              Icons.shopping_bag_outlined,
              "Orders",
              onTap: () => Navigator.pushNamed(context, '/orders'),
            ),
            _buildProfileMenu(
              Icons.credit_card_outlined,
              "My Card",
              onTap: () => Navigator.pushNamed(context, '/my-card'),
            ),
            _buildProfileMenu(
              Icons.settings_outlined,
              "Settings",
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            _buildProfileMenu(Icons.help_outline, "Help Center"),

            const SizedBox(height: 48),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: OutlinedButton(
                onPressed: () =>
                    context.read<AppAuthProvider>().signOut(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  foregroundColor: Colors.red,
                ),
                child: Text(
                  "Sign Out",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      );
              },
            ),
    );
  }

  Widget _buildProfileMenu(IconData icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF5F5F5)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFF4A7043), size: 22),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF042404),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
      ),
    );
  }
}
