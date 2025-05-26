import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';
import 'home_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  Future<void> _validateAndLogin() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _isLoading = true;
    });

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      bool hasError = false;

      if (email.isEmpty) {
        setState(() {
          _emailError = 'Email tidak boleh kosong';
          hasError = true;
        });
      } else if (!email.contains('@')) {
        setState(() {
          _emailError = 'Email tidak valid';
          hasError = true;
        });
      }

      if (password.isEmpty) {
        setState(() {
          _passwordError = 'Kata sandi tidak boleh kosong';
          hasError = true;
        });
      } else if (password.length < 6) {
        setState(() {
          _passwordError = 'Kata sandi minimal 6 karakter';
          hasError = true;
        });
      }

      if (!hasError) {
        // Login dengan Firebase
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          // Ambil data user dari Firestore
          final userDoc = await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

          if (userDoc.exists) {
            final userData = userDoc.data()!;
            // Buat UserModel dari data Firestore menggunakan factory method
            final user =
                UserModel.fromFirestore(userData, userCredential.user!.uid);

            // Set user ke provider
            if (!mounted) return;
            Provider.of<UserProvider>(context, listen: false).setUser(user);

            // Navigasi ke home screen
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            // Jika data user tidak ditemukan di Firestore, buat data default
            final defaultUser = UserModel(
              id: userCredential.user!.uid,
              name: userCredential.user!.displayName ?? '',
              email: userCredential.user!.email ?? '',
              school: '',
              level: 'Pemula',
              points: 0,
              awards: 0,
            );

            // Simpan data default ke Firestore
            await _firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .set(defaultUser.toFirestore());

            // Set user ke provider
            if (!mounted) return;
            Provider.of<UserProvider>(context, listen: false)
                .setUser(defaultUser);

            // Navigasi ke home screen
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        }
      }
    } catch (e) {
      String errorMessage = 'Terjadi kesalahan';

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Email tidak terdaftar';
            break;
          case 'wrong-password':
            errorMessage = 'Kata sandi salah';
            break;
          case 'invalid-email':
            errorMessage = 'Format email tidak valid';
            break;
          case 'user-disabled':
            errorMessage = 'Akun telah dinonaktifkan';
            break;
          case 'network-request-failed':
            errorMessage = 'Koneksi internet bermasalah';
            break;
          default:
            errorMessage = 'Error: ${e.code} - ${e.message}';
        }
      } else {
        errorMessage = 'Error: ${e.toString()}';
      }

      print('Login error: $errorMessage'); // Tambahkan log untuk debugging

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset('assets/images/nusa_learn.png', height: 120),
            ),
            const SizedBox(height: 20),
            const Text(
              'Selamat Datang!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Masuk untuk melanjutkan petualanganmu',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Form
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Masukkan email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.orange),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                errorText: _emailError,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kata Sandi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: const Text(
                    'Lupa kata sandi?',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            TextField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Masukkan kata sandi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                errorText: _passwordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                  activeColor: Colors.orange,
                ),
                const Text('Ingat saya'),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _validateAndLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6D3D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Belum punya akun? '),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: const Text(
                    'Daftar',
                    style: TextStyle(
                      color: Color(0xFFFF6D3D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
