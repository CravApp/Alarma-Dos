import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  bool _alertSent = false;

  void _activateAlert() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    context.read<AppProvider>().toggleAlert();
    setState(() => _alertSent = true);
  }

  void _cancelAlert() {
    context.read<AppProvider>().toggleAlert();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _alertSent ? _buildAlertActiveView() : _buildPreAlertView(),
    );
  }

  // ── PRE-ALERTA: fondo #782D69 ──────────────────────────────────
  Widget _buildPreAlertView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.primaryPurple,   // #782D69 — mismo que login
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
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
                ),
              ),
              const Spacer(),
              Text(
                '¿Necesitas ayuda?',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 12),
              Text(
                'Al activar la alerta, tus contactos de confianza recibirán tu ubicación en tiempo real.',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    fontSize: 14,
                    color: AppColors.pinkField,   // #F0B4D2
                    height: 1.6),
              ).animate(delay: 200.ms).fadeIn(),
              const SizedBox(height: 52),
              // ── Botón SOS — anillos rosa hot #E178A5 ──
              GestureDetector(
                onTap: _activateAlert,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.pinkHot.withValues(alpha: 0.15),
                      ),
                    ).animate(onPlay: (c) => c.repeat())
                        .scaleXY(begin: 0.9, end: 1.12, duration: 1800.ms, curve: Curves.easeInOut)
                        .then().scaleXY(begin: 1.12, end: 0.9, duration: 1800.ms),
                    Container(
                      width: 175,
                      height: 175,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.pinkHot.withValues(alpha: 0.25),
                      ),
                    ),
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.pinkVibrant,  // #D25A96
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.pinkVibrant.withValues(alpha: 0.55),
                            blurRadius: 36,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: AppColors.white, size: 44),
                          const SizedBox(height: 4),
                          Text(
                            'SOS',
                            style: GoogleFonts.playfairDisplay(
                              color: AppColors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 300.ms).scale(duration: 700.ms, curve: Curves.elasticOut),
              const SizedBox(height: 20),
              Text(
                'TOCA PARA ENVIAR ALERTA',
                style: GoogleFonts.lato(
                  color: AppColors.pinkField.withValues(alpha: 0.7),
                  fontSize: 11,
                  letterSpacing: 2,
                ),
              ).animate(onPlay: (c) => c.repeat())
                  .fadeIn(duration: 700.ms)
                  .then()
                  .fadeOut(duration: 700.ms),
              const Spacer(),
              // Info contactos
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.people_outline,
                        color: AppColors.pinkField, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      '1 contacto recibirá la alerta',
                      style: GoogleFonts.lato(
                          color: AppColors.pinkField, fontSize: 13),
                    ),
                    const Spacer(),
                    const Icon(Icons.location_on,
                        color: AppColors.pinkField, size: 14),
                    const SizedBox(width: 4),
                    Text('GPS',
                        style: GoogleFonts.lato(
                            color: AppColors.pinkField, fontSize: 12)),
                  ],
                ),
              ).animate(delay: 500.ms).fadeIn(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ── ALERTA ACTIVA — fondo #E178A5 rosa hot (lockscreen exacto del ZIP) ──
  Widget _buildAlertActiveView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.pinkHot,   // #E178A5 — exacto del diseño PERMISOS (3).png / lockscreen
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // ── Barra de notificación — #782D69 exacto lockscreen 8.png ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple,  // #782D69
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                      ),
                    ).animate(onPlay: (c) => c.repeat())
                        .fadeIn(duration: 500.ms)
                        .then()
                        .fadeOut(duration: 500.ms),
                    const SizedBox(width: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset('assets/icons/app_icon.png',
                          width: 28, height: 28, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alarmados',
                            style: GoogleFonts.lato(
                              color: AppColors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Content hidden',
                            style: GoogleFonts.lato(
                                color: AppColors.pinkField, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Ahora',
                      style: GoogleFonts.lato(
                          color: AppColors.pinkField, fontSize: 11),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
              const Spacer(),
              // Ícono alerta
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withValues(alpha: 0.25),
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: const Icon(Icons.notifications_active,
                    color: AppColors.white, size: 52),
              ).animate(onPlay: (c) => c.repeat())
                  .scaleXY(begin: 1.0, end: 1.08, duration: 800.ms)
                  .then()
                  .scaleXY(begin: 1.08, end: 1.0, duration: 800.ms),
              const SizedBox(height: 28),
              Text(
                '¡Alerta Enviada!',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              Text(
                'Tus contactos de confianza han sido notificados con tu ubicación en tiempo real.',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 15,
                  color: AppColors.white.withValues(alpha: 0.9),
                  height: 1.6,
                ),
              ).animate(delay: 300.ms).fadeIn(),
              const SizedBox(height: 32),
              // Contacto notificado
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple,   // #782D69
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                      ),
                      child: Center(
                        child: Text(
                          'M',
                          style: GoogleFonts.lato(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mamá',
                              style: GoogleFonts.lato(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15)),
                          Text('Notificado ✓',
                              style: GoogleFonts.lato(
                                  color: AppColors.pinkField,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle,
                        color: AppColors.white, size: 24),
                  ],
                ),
              ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2, end: 0),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _cancelAlert,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.white, width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cancel_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text('Cancelar Alerta',
                          style: GoogleFonts.lato(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ).animate(delay: 600.ms).fadeIn(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
