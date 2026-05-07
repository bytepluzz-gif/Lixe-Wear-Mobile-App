import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../core/firestore_service.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _addressFocus = FocusNode();

  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _addressFocus.dispose();
    super.dispose();
  }

  void _syncControllerIfIdle(
    FocusNode focus,
    TextEditingController controller,
    String nextValue,
  ) {
    if (focus.hasFocus) return;
    if (controller.text == nextValue) return;
    controller.text = nextValue;
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Scaffold(body: Center(child: Text('Please sign in')));
    }
    final service = context.read<FirestoreService>();

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
        title: const Text(
          "Personal Information",
          style: TextStyle(
            color: Color(0xFF042404),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: service.userProfileStream(uid),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() ?? {};
          _syncControllerIfIdle(
            _nameFocus,
            _name,
            (data['fullName'] as String?) ?? '',
          );
          _syncControllerIfIdle(
            _phoneFocus,
            _phone,
            (data['phone'] as String?) ?? '',
          );
          _syncControllerIfIdle(
            _addressFocus,
            _address,
            (data['address'] as String?) ?? '',
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                TextField(
                  controller: _name,
                  focusNode: _nameFocus,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phone,
                  focusNode: _phoneFocus,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _address,
                  focusNode: _addressFocus,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            try {
                              setState(() => _loading = true);
                              await service.saveUserProfile(uid, {
                                'fullName': _name.text.trim(),
                                'phone': _phone.text.trim(),
                                'address': _address.text.trim(),
                                'email': FirebaseAuth.instance.currentUser?.email,
                              });
                              await service.setPrimaryAddress(
                                uid,
                                _address.text.trim(),
                              );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Profile updated')),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Update failed: $e')),
                              );
                            } finally {
                              if (mounted) setState(() => _loading = false);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF042404),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Update Information",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
