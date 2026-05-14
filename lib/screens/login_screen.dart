import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import 'permissions_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  void _doLogin() async {
    if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos'),
          backgroundColor: AppColors.danger,
        ),
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
      // ── Fondo: #782D69 sólido — exacto del diseño 3.png ──
      backgroundColor: AppColors.primaryPurple,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: AppColors.white, size: 18),
                ),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 56),

              // "ALARMA DOS" — blanco, serif bold, exacto del diseño
              Text(
                'ALARMA DOS',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                  letterSpacing: 2,
                ),
              ).animate(delay: 100.ms).fadeIn().slideX(begin: -0.2, end: 0),

              const SizedBox(height: 64),

              // ── Recuadro de campos — borde punteado blanco, como el diseño ──
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.7),
                    width: 1.5,
                    // strokeAlign: punteado simulado con deco
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // USUARIO
                    Row(
                      children: [
                        Text(
                          'USUARIO:',
                          style: GoogleFonts.lato(
                            color: AppColors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.lato(
                                color: AppColors.textDark, fontSize: 14),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.pinkField, // #F0B4D2
                              hintText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                    color: AppColors.white, width: 1.5),
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 2),
                    // Línea divisora dentro del recuadro
                    Divider(
                        color: AppColors.pinkMedium.withValues(alpha: 0.5),
                        height: 12),

                    // CONTRASEÑA
                    Row(
                      children: [
                        Text(
                          'CONTRASEÑA:',
                          style: GoogleFonts.lato(
                            color: AppColors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _passCtrl,
                            obscureText: _obscure,
                            style: GoogleFonts.lato(
                                color: AppColors.textDark, fontSize: 14),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.pinkField, // #F0B4D2
                              hintText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                    color: AppColors.white, width: 1.5),
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              suffixIcon: GestureDetector(
                                onTap: () =>
                                    setState(() => _obscure = !_obscure),
                                child: Icon(
                                  _obscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.primaryPurple,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).animate(delay: 280.ms).fadeIn().slideY(begin: 0.2, end: 0),
                  ],
                ),
              ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.3, end: 0),

              const SizedBox(height: 36),

              // Botón "REGISTRARSE" — blanco redondeado, texto oscuro, exacto diseño
              Center(
                child: SizedBox(
                  width: 220,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _doLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.textDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                  AppColors.primaryPurple),
                            ),
                          )
                        : Text(
                            'INGRESAR',
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textDark,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),
              ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3, end: 0),

              const SizedBox(height: 20),

              // "Olvidaste tu contraseña" — subrayado blanco, exacto diseño
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Olvidaste tu contraseña',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: AppColors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.white,
                    ),
                  ),
                ),
              ).animate(delay: 500.ms).fadeIn(),

              const SizedBox(height: 40),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: '¿No tienes cuenta? ',
                      style: GoogleFonts.lato(
                          color: AppColors.pinkField, fontSize: 14),
                      children: [
                        TextSpan(
                          text: 'Regístrate',
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
            ],
          ),
        ),
      ),
    );
  }
}
