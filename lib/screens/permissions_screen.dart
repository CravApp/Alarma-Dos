import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import 'home_screen.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  int _step = 0; // 0 = ubicación, 1 = bluetooth

  void _grantLocation() {
    context.read<AppProvider>().grantLocation();
    setState(() => _step = 1);
  }

  void _skipLocation() => setState(() => _step = 1);

  void _grantBluetooth() {
    context.read<AppProvider>().toggleBluetooth();
    _goHome();
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _step == 0 ? _buildLocationStep() : _buildBluetoothStep(),
      ),
    );
  }

  // ── PANTALLA UBICACIÓN — exacto del diseño PERMISOS.png ──────────
  Widget _buildLocationStep() {
    return Container(
      key: const ValueKey('location'),
      width: double.infinity,
      height: double.infinity,
      // Fondo: #E1E1E1 gris claro + mapa en cuadrícula, exacto del diseño
      color: AppColors.bgLight,
      child: SafeArea(
        child: Column(
          children: [
            // ── Área del mapa con pin rosa ──
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Cuadrícula del mapa
                  CustomPaint(
                    size: Size.infinite,
                    painter: _IsometricMapPainter(),
                  ),
                  // Pin de ubicación — #F0B4D2 claro + #D25A96 oscuro, exacto diseño
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          // Pin grande rosa
                          Icon(
                            Icons.location_on,
                            size: 140,
                            color: AppColors.pinkField, // #F0B4D2 relleno
                          ),
                          // Círculo interno más oscuro
                          Positioned(
                            top: 18,
                            right: 32,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.pinkVibrant, // #D25A96
                              ),
                              child: const Icon(Icons.circle_outlined,
                                  color: AppColors.white, size: 22),
                            ),
                          ),
                          // Badge "+" en la parte superior derecha
                          Positioned(
                            top: 0,
                            right: 18,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.pinkVibrant,
                              ),
                              child: const Icon(Icons.add,
                                  color: AppColors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                ],
              ),
            ),

            // ── Panel inferior blanco/gris ──
            Container(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 16),
              color: AppColors.bgLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Permitir tu Ubicación',
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ).animate(delay: 200.ms).fadeIn(),
                  const SizedBox(height: 10),
                  Text(
                    'Tu seguridad es nuestra prioridad. Para poder ayudarte en situaciones de emergencia, esta aplicación puede acceder a tu ubicación en tiempo real.\n\nSi activas una alerta, tu ubicación se compartirá con tus contactos de confianza.',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: AppColors.textGrey,
                      height: 1.6,
                    ),
                  ).animate(delay: 300.ms).fadeIn(),
                  const SizedBox(height: 24),
                  // Botón "Permitir tu locacion" — #782D69, exacto diseño
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _grantLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: Text(
                        'Permitir tu locacion',
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 12),
                  // Botón "Mas tarde" — también #782D69 más oscuro, exacto diseño
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _skipLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkPurple,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: Text(
                        'Mas tarde',
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── PANTALLA BLUETOOTH — exacto del diseño PERMISOS (2).png ──────
  Widget _buildBluetoothStep() {
    return Container(
      key: const ValueKey('bluetooth'),
      width: double.infinity,
      height: double.infinity,
      // Fondo: #E1E1E1 gris claro, exacto diseño bluetooth
      color: AppColors.bgLight,
      child: SafeArea(
        child: Column(
          children: [
            // ── Área superior: mancha lavanda + icono bluetooth pixel ──
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Cuadrícula del mapa de fondo (igual que ubicación)
                  CustomPaint(
                    size: Size.infinite,
                    painter: _IsometricMapPainter(),
                  ),
                  // Mancha de acuarela lavanda — #E1C3D2, exacto diseño
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.pinkPale.withValues(alpha: 0.7), // #E1C3D2
                    ),
                  ),
                  // Icono Bluetooth pixel-art estilo, en rosa #D25A96
                  Icon(
                    Icons.bluetooth,
                    size: 90,
                    color: AppColors.pinkVibrant, // #D25A96
                  ).animate(onPlay: (c) => c.repeat())
                      .scaleXY(begin: 0.95, end: 1.05, duration: 1500.ms)
                      .then()
                      .scaleXY(begin: 1.05, end: 0.95, duration: 1500.ms),
                ],
              ),
            ),

            // ── Panel inferior ──
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              color: AppColors.bgLight,
              child: Column(
                children: [
                  // Título en recuadro gris, exacto diseño
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.bgNearWhite,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Solicitud de permiso de Bluetooh',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                      ),
                    ),
                  ).animate(delay: 200.ms).fadeIn(),
                  const SizedBox(height: 12),
                  // Cuerpo del mensaje en recuadro gris más oscuro
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.bgLight,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'La aplicación esta solicitando permiso para encender el Bluetooh ¿Permitir?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: AppColors.textDark,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Botones SI / NO — #782D69, exacto diseño
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _grantBluetooth,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryPurple,
                                  foregroundColor: AppColors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'SI',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _goHome,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryPurple,
                                  foregroundColor: AppColors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'NO',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1),
                                ),
                              ),
                            ),
                          ],
                        ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3, end: 0),
                      ],
                    ),
                  ).animate(delay: 300.ms).fadeIn(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pintor de cuadrícula isométrica estilo mapa — gris claro, exacto diseño
class _IsometricMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCCCCCC)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // Líneas horizontales
    for (double y = 0; y < size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Líneas verticales
    for (double x = 0; x < size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    // Líneas diagonales (efecto isométrico)
    final paintDiag = Paint()
      ..color = const Color(0xFFDDDDDD)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    for (double d = -size.height; d < size.width + size.height; d += 48) {
      canvas.drawLine(
          Offset(d, 0), Offset(d + size.height, size.height), paintDiag);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
