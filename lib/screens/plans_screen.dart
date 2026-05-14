import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return Container(
      // Fondo: #F0D2E1 rosa pálido — exacto del diseño 8.png planes
      color: AppColors.pinkSoft,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header blanco con avatar — exacto diseño 8.png ──
              Container(
                color: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.bgLight, width: 2),
                        color: AppColors.pinkHot,
                      ),
                      child: ClipOval(
                        child: Image.asset('assets/icons/app_icon.png', fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Bienvenida, Usuario',
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Título "ALARMA DOS PLANES" — exacto diseño 8.png ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                color: AppColors.pinkSoft,  // #F0D2E1
                child: Column(
                  children: [
                    // "ALARMA DOS" — púrpura serif bold, exacto
                    Text(
                      'ALARMA DOS',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryPurple,   // #782D69
                        letterSpacing: 2,
                      ),
                    ).animate().fadeIn(duration: 400.ms),
                    // "PLANES" — rosa hot, exacto diseño
                    Text(
                      'PLANES',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.pinkVibrant,   // #D25A96
                        letterSpacing: 3,
                      ),
                    ).animate(delay: 100.ms).fadeIn(),
                    const SizedBox(height: 16),
                    Text(
                      'Para brindar una mejor experiencia a nuestros usuarios, hemos desarrollado planes premium que ofrecen funciones adicionales de seguridad y personalización.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: AppColors.textDark,
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                      ),
                    ).animate(delay: 200.ms).fadeIn(),
                  ],
                ),
              ),

              // ── Cards de planes — exacto diseño 8.png ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PLAN GRATUITO — #782D69, exacto diseño
                    Expanded(
                      child: _PlanCard(
                        titulo: 'PLAN\nGRATUITO',
                        features: const ['1 persona'],
                        btnLabel: 'Seguir',
                        isActive: !provider.isPremium,
                        onTap: () {},
                      ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.3, end: 0),
                    ),
                    const SizedBox(width: 12),
                    // PLAN PREMIUM — #782D69 más oscuro, exacto diseño
                    Expanded(
                      child: _PlanCard(
                        titulo: 'PLAN\nPREMIUM',
                        features: const ['Acceso a mas contactos'],
                        btnLabel: 'Seguir',
                        isActive: provider.isPremium,
                        onTap: provider.isPremium ? null : () {
                          provider.upgradeToPremium();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '¡Bienvenida al Plan Premium! 🌟',
                                style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                              ),
                              backgroundColor: AppColors.primaryPurple,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                      ).animate(delay: 380.ms).fadeIn().slideY(begin: 0.3, end: 0),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Misión y Visión — colores del diseño 4.png ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Card Misión — #F0D2E1 exacto diseño
                    _MisionVisionCard(
                      titulo: 'Misión',
                      texto: 'Brindar seguridad y tranquilidad a los jóvenes mediante el desarrollo de un dispositivo tecnológico accesible, discreto y fácil de usar para solicitar ayuda rápida.',
                      bgColor: AppColors.pinkSoft.withValues(alpha: 0.6),   // #F0D2E1 más claro
                      titleColor: AppColors.pinkVibrant,   // #D25A96
                      textColor: AppColors.textDark,
                    ).animate(delay: 450.ms).fadeIn().slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 14),
                    // Card Visión — #E178A5 exacto diseño
                    _MisionVisionCard(
                      titulo: 'Visión',
                      texto: 'Fortalecer el bienestar y la protección diaria de los jóvenes mediante el uso de tecnología aplicada a la seguridad personal.',
                      bgColor: AppColors.pinkHot,    // #E178A5
                      titleColor: AppColors.white,
                      textColor: AppColors.white,
                    ).animate(delay: 550.ms).fadeIn().slideY(begin: 0.2, end: 0),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Card de plan individual ─────────────────────────────────────────
class _PlanCard extends StatelessWidget {
  final String titulo;
  final List<String> features;
  final String btnLabel;
  final bool isActive;
  final VoidCallback? onTap;

  const _PlanCard({
    required this.titulo,
    required this.features,
    required this.btnLabel,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryPurple,   // #782D69 — exacto diseño
        borderRadius: BorderRadius.circular(20),
        border: isActive
            ? Border.all(color: AppColors.pinkHot, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.darkPurple.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del plan — rosa hot, serif bold, exacto diseño
          Text(
            titulo,
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.pinkHot,   // #E178A5
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          // Features
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style: TextStyle(color: AppColors.white, fontSize: 14)),
                  Expanded(
                    child: Text(
                      f,
                      style: GoogleFonts.lato(
                          color: AppColors.white, fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 60),
          // Botón "Seguir" — blanco redondeado, exacto diseño
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.pinkHot.withValues(alpha: 0.2)
                    : AppColors.white,
                borderRadius: BorderRadius.circular(30),
                border: isActive
                    ? Border.all(color: AppColors.pinkHot, width: 1.5)
                    : null,
              ),
              child: Center(
                child: Text(
                  isActive ? 'Activo ✓' : btnLabel,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isActive ? AppColors.pinkHot : AppColors.primaryPurple,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card Misión / Visión ────────────────────────────────────────────
class _MisionVisionCard extends StatelessWidget {
  final String titulo;
  final String texto;
  final Color bgColor;
  final Color titleColor;
  final Color textColor;

  const _MisionVisionCard({
    required this.titulo,
    required this.texto,
    required this.bgColor,
    required this.titleColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            texto,
            style: GoogleFonts.lato(
              fontSize: 13,
              color: textColor,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Ver más',
                style: GoogleFonts.lato(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryPurple,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
