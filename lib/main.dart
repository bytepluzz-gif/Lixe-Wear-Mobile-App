import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'core/auth_provider.dart';
import 'core/firestore_service.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/product/view/home_screen.dart';
import 'features/product/viewmodel/favorites_provider.dart';
import 'features/cart/viewmodel/cart_provider.dart';
import 'features/product/view/product_listing.dart';
import 'features/product/view/product_details.dart';
import 'features/cart/view/cart_screen.dart';
import 'features/cart/view/checkout_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/product/view/favorites_screen.dart';
import 'features/product/view/notifications_screen.dart';
import 'features/profile/settings_screen.dart';
import 'features/profile/privacy_security_screen.dart';
import 'features/profile/customer_support_screen.dart';
import 'features/profile/add_payment_screen.dart';
import 'features/profile/personal_info_screen.dart';
import 'features/profile/my_card_screen.dart';
import 'features/profile/order_history_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Bootstrapper());
}

class Bootstrapper extends StatelessWidget {
  const Bootstrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        return const MyApp();
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        Provider(create: (_) => FirestoreService()),
      ],
      child: MaterialApp(
        title: 'LuxeWear',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4A7043),
            primary: const Color(0xFF4A7043),
            surface: const Color(0xFFF9F9F4),
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            bodyLarge: TextStyle(fontSize: 16),
            bodyMedium: TextStyle(fontSize: 14),
          ),
          scaffoldBackgroundColor: const Color(0xFFF9F9F4),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF9F9F4),
            foregroundColor: Colors.black,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Color(0xFF4A7043),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthGate(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const MainAppScreen(),
          '/product-listing': (context) => const ProductListingScreen(),
          '/product-details': (context) => const ProductDetailsScreen(),
          '/cart': (context) => const CartScreen(),
          '/checkout': (context) => const CheckoutScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/favorites': (context) => const FavoritesScreen(),
          '/notifications': (context) => const NotificationsScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/privacy': (context) => const PrivacySecurityScreen(),
          '/support': (context) => const CustomerSupportScreen(),
          '/add-payment': (context) => const AddPaymentScreen(),
          '/personal-info': (context) => const PersonalInfoScreen(),
          '/my-card': (context) => const MyCardScreen(),
          '/orders': (context) => const OrderHistoryScreen(),
        },
      ),
    );
  }
}

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;
  bool _attachedProviders = false;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProductListingScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !_attachedProviders) {
      context.read<CartProvider>().attachUser(user.uid);
      context.read<FavoritesProvider>().attachUser(user.uid);
      _attachedProviders = true;
    }
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF4A7043),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFF9F9F4),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(color: Color(0xFF042404)),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "LuxeWear",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "EST. 2024",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.white60,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                children: [
                  _buildDrawerItem(context, Icons.home_outlined, "Home", 0),
                  _buildDrawerItem(
                    context,
                    Icons.shopping_bag_outlined,
                    "Shop",
                    1,
                    route: '/product-listing',
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.favorite_border,
                    "Favorites",
                    -1,
                    route: '/favorites',
                  ),
                  _buildDrawerItem(context, Icons.person_outline, "Profile", 3),
                  _buildDrawerItem(
                    context,
                    Icons.notifications_none,
                    "Notifications",
                    -1,
                    route: '/notifications',
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.settings_outlined,
                    "Settings",
                    -1,
                    route: '/settings',
                  ),
                  const Divider(height: 48),
                  _buildDrawerItem(
                    context,
                    Icons.logout,
                    "Logout",
                    -1,
                    route: '/login',
                    isLogout: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    int index, {
    String? route,
    bool isLogout = false,
  }) {
    bool isSelected = index != -1 && _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF4A7043).withAlpha(26)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout
              ? Colors.red
              : (isSelected
                    ? const Color(0xFF4A7043)
                    : const Color(0xFF042404)),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isLogout ? Colors.red : const Color(0xFF042404),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (route != null) {
            if (isLogout) {
              context.read<AppAuthProvider>().signOut();
              Navigator.pushReplacementNamed(context, route);
            } else {
              Navigator.pushNamed(context, route);
            }
          } else if (index != -1) {
            setState(() => _selectedIndex = index);
          }
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return snapshot.data == null ? const LoginPage() : const MainAppScreen();
      },
    );
  }
}
