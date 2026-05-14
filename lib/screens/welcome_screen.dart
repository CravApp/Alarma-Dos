import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // ── Foto de fondo (bolso morado con charm) ──
          // Simulamos con gradiente y la imagen del charm sobre fondo blanco
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                // Fondo superior: imagen de estilo de vida (bolso morado)
                // El color del bolso en el diseño es exactamente #782D69
                color: AppColors.primaryPurple,
              ),
              child: Opacity(
                opacity: 0.9,
                child: Image.asset(
                  'assets/images/charm_chick.png',
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -0.3),
                ),
              ),
            ),
          ),
          // ── Panel blanco inferior (como en el diseño) ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.48,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // "BIENVENIDOS" — púrpura vibrante, serif bold, exacto del diseño
                  Text(
                    'BIENVENIDOS',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryPurple, // #782D69
                      letterSpacing: 1,
                    ),
                  ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 12),
                  Text(
                    'Tu seguridad es nuestra prioridad. Activa tu dispositivo y mantente conectado con las personas que más te importan en todo momento.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: AppColors.textGrey,
                      height: 1.6,
                    ),
                  ).animate(delay: 300.ms).fadeIn(),
                  const SizedBox(height: 28),
                  // Botón "Ingresar" — #782D69 sólido, blanco, como en el diseño
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: Text(
                        'Ingresar',
                        style: GoogleFonts.lato(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 14),
                  // Botón "Regístrate" — contorno negro, como en el diseño
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textDark,
                        side: const BorderSide(color: AppColors.textDark, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Regístrate',
                        style: GoogleFonts.lato(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.3, end: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
