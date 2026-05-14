import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import 'permissions_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  void _doRegister() async {
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos'), backgroundColor: AppColors.danger),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    context.read<AppProvider>().login(_emailCtrl.text, _passCtrl.text);
    setState(() => _loading = false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PermissionsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryPurple, AppColors.darkPurple],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 18),
                  ),
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: 36),
                Text(
                  'CREAR CUENTA',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                    letterSpacing: 2,
                  ),
                ).animate(delay: 100.ms).fadeIn().slideX(begin: -0.2, end: 0),
                const SizedBox(height: 6),
                Text(
                  'Únete a Alarmados hoy',
                  style: GoogleFonts.lato(fontSize: 15, color: AppColors.pinkField),
                ).animate(delay: 150.ms).fadeIn(),
                const SizedBox(height: 36),
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Nombre completo'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Tu nombre',
                          prefixIcon: Icon(Icons.badge_outlined, color: AppColors.primaryPurple),
                        ),
                      ).animate(delay: 250.ms).fadeIn().slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 20),
                      _label('Email'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'tu@correo.com',
                          prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryPurple),
                        ),
                      ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 20),
                      _label('Contraseña'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passCtrl,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: 'Mínimo 8 caracteres',
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primaryPurple),
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => _obscure = !_obscure),
                            child: Icon(
                              _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ),
                      ).animate(delay: 350.ms).fadeIn().slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 28),
                      // Plan gratuito badge
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.bgLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: AppColors.primaryPurple, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Plan Gratuito incluido — 1 contacto de confianza',
                                style: GoogleFonts.lato(fontSize: 12, color: AppColors.textDark),
                              ),
                            ),
                          ],
                        ),
                      ).animate(delay: 400.ms).fadeIn(),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _doRegister,
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(AppColors.white),
                                  ),
                                )
                              : const Text('Crear Cuenta'),
                        ),
                      ).animate(delay: 450.ms).fadeIn().slideY(begin: 0.3, end: 0),
                    ],
                  ),
                ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3, end: 0),
                const SizedBox(height: 28),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: '¿Ya tienes cuenta? ',
                        style: GoogleFonts.lato(color: AppColors.pinkField, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Ingresar',
                            style: GoogleFonts.lato(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate(delay: 600.ms).fadeIn(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textGrey),
      );
}
