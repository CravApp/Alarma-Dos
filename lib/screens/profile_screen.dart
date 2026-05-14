import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return Container(
      color: AppColors.bgLight,  // #E1E1E1
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header #782D69 — mismo estilo que Login ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
                color: AppColors.primaryPurple,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PERFIL',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        if (provider.isPremium)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: AppColors.gold, size: 14),
                                const SizedBox(width: 5),
                                Text('PREMIUM',
                                    style: GoogleFonts.lato(
                                        color: AppColors.gold,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1)),
                              ],
                            ),
                          ),
                      ],
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 24),
                    // Avatar — rosa hot #E178A5
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.pinkHot,  // #E178A5
                        border: Border.all(color: AppColors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          provider.userName.isNotEmpty
                              ? provider.userName[0].toUpperCase()
                              : 'U',
                          style: GoogleFonts.playfairDisplay(
                            color: AppColors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ).animate(delay: 100.ms).scale(duration: 600.ms, curve: Curves.elasticOut),
                    const SizedBox(height: 12),
                    Text(
                      provider.userName.isNotEmpty ? provider.userName : 'Usuario',
                      style: GoogleFonts.playfairDisplay(
                          color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w700),
                    ).animate(delay: 200.ms).fadeIn(),
                    const SizedBox(height: 4),
                    Text(
                      provider.userEmail.isNotEmpty
                          ? provider.userEmail
                          : 'usuario@correo.com',
                      style: GoogleFonts.lato(
                          color: AppColors.pinkField, fontSize: 13),  // #F0B4D2
                    ).animate(delay: 250.ms).fadeIn(),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Stats row — tarjetas blancas con acento #782D69
                    Row(
                      children: [
                        _statCard('1', 'Contactos', AppColors.primaryPurple),
                        const SizedBox(width: 10),
                        _statCard(
                          provider.bluetoothConnected ? '1' : '0',
                          'Dispositivos',
                          AppColors.pinkVibrant,   // #D25A96
                        ),
                        const SizedBox(width: 10),
                        _statCard('0', 'Alertas', AppColors.gold),
                      ],
                    ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 20),
                    _sectionTitle('Mi Cuenta'),
                    const SizedBox(height: 10),
                    _optionCard(icon: Icons.person_outline, title: 'Editar Perfil', subtitle: 'Nombre, correo y foto', onTap: () {})
                        .animate(delay: 400.ms).fadeIn().slideX(begin: 0.2, end: 0),
                    _optionCard(icon: Icons.lock_outline, title: 'Cambiar Contraseña', subtitle: 'Seguridad de tu cuenta', onTap: () {})
                        .animate(delay: 440.ms).fadeIn().slideX(begin: 0.2, end: 0),
                    _optionCard(icon: Icons.notifications_outlined, title: 'Notificaciones', subtitle: 'Gestionar alertas y avisos', onTap: () {})
                        .animate(delay: 480.ms).fadeIn().slideX(begin: 0.2, end: 0),

                    const SizedBox(height: 16),
                    _sectionTitle('Dispositivo'),
                    const SizedBox(height: 10),
                    _optionCard(
                      icon: Icons.bluetooth_outlined,
                      title: 'Alarma Dos',
                      subtitle: provider.bluetoothConnected ? 'Conectado' : 'Sin conexión',
                      trailing: Switch(
                        value: provider.bluetoothConnected,
                        onChanged: (_) => context.read<AppProvider>().toggleBluetooth(),
                        activeThumbColor: AppColors.white,
                        activeTrackColor: AppColors.primaryPurple,
                      ),
                      onTap: null,
                    ).animate(delay: 520.ms).fadeIn().slideX(begin: 0.2, end: 0),
                    _optionCard(
                      icon: Icons.location_on_outlined,
                      title: 'Ubicación',
                      subtitle: provider.locationGranted ? 'Permitida' : 'No permitida',
                      trailing: Switch(
                        value: provider.locationGranted,
                        onChanged: (_) => context.read<AppProvider>().grantLocation(),
                        activeThumbColor: AppColors.white,
                        activeTrackColor: AppColors.primaryPurple,
                      ),
                      onTap: null,
                    ).animate(delay: 560.ms).fadeIn().slideX(begin: 0.2, end: 0),

                    const SizedBox(height: 16),
                    _sectionTitle('Soporte'),
                    const SizedBox(height: 10),
                    _optionCard(icon: Icons.help_outline, title: 'Centro de Ayuda', subtitle: 'Preguntas frecuentes', onTap: () {})
                        .animate(delay: 600.ms).fadeIn().slideX(begin: 0.2, end: 0),
                    _optionCard(icon: Icons.privacy_tip_outlined, title: 'Privacidad', subtitle: 'Términos y condiciones', onTap: () {})
                        .animate(delay: 640.ms).fadeIn().slideX(begin: 0.2, end: 0),

                    const SizedBox(height: 24),

                    // Botón cerrar sesión — borde #782D69
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<AppProvider>().logout();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                            (route) => false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryPurple,
                          side: const BorderSide(color: AppColors.primaryPurple, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout, size: 18),
                            const SizedBox(width: 8),
                            Text('Cerrar Sesión',
                                style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ).animate(delay: 680.ms).fadeIn(),

                    const SizedBox(height: 12),
                    Text(
                      'Alarmados v1.0.0  •  com.alarmados.alarm',
                      style: GoogleFonts.lato(
                          fontSize: 11,
                          color: AppColors.textGrey.withValues(alpha: 0.5)),
                    ).animate(delay: 720.ms).fadeIn(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.playfairDisplay(
                    fontSize: 24, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 3),
            Text(label,
                style: GoogleFonts.lato(fontSize: 11, color: AppColors.textGrey)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.lato(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textGrey,
            letterSpacing: 1.5),
      ),
    );
  }

  Widget _optionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.pinkSoft,   // #F0D2E1
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryPurple, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.lato(
                          fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  Text(subtitle,
                      style: GoogleFonts.lato(fontSize: 11, color: AppColors.textGrey)),
                ],
              ),
            ),
            trailing ??
                Icon(Icons.arrow_forward_ios, size: 13, color: AppColors.textGrey.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}
