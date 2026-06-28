// ─────────────────────────────────────────────────────────────────────────────
// Pantalla E — Emparejamiento BLE "Alarma Dos"
//
// UX spec:
//  • Fondo blanco con animación radar en tonos rosa (#E178A5 / #F0B4D2)
//  • Lista dinámica de dispositivos BLE encontrados
//  • "AlarmaDos" destacado con ícono del charm + badge dorado
//  • Botón "Vincular" → spinner elegante → "Dispositivo Vinculado ✓"
//  • Al finalizar navega al Dashboard (HomeScreen)
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../services/ble_service.dart';
import 'home_screen.dart';

class BlePairingScreen extends StatefulWidget {
  const BlePairingScreen({super.key});

  @override
  State<BlePairingScreen> createState() => _BlePairingScreenState();
}

class _BlePairingScreenState extends State<BlePairingScreen>
    with TickerProviderStateMixin {
  // ── Animación radar ───────────────────────────────────────────────────────
  late AnimationController _radarCtrl;
  late Animation<double> _radarAnim;

  // Múltiples ondas
  late AnimationController _wave1Ctrl;
  late AnimationController _wave2Ctrl;
  late AnimationController _wave3Ctrl;

  // ── Estado UI ─────────────────────────────────────────────────────────────
  BleDeviceResult? _selectedDevice;
  bool _connecting = false;
  bool _connected = false;

  @override
  void initState() {
    super.initState();

    // Radar sweep
    _radarCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
    _radarAnim = Tween<double>(begin: 0, end: 2 * pi).animate(_radarCtrl);

    // Ondas concéntricas con offset
    _wave1Ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))
      ..repeat();
    _wave2Ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))
      ..repeat();
    _wave3Ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))
      ..repeat();
    Future.delayed(const Duration(milliseconds: 733), () {
      if (mounted) _wave2Ctrl.forward(from: 0.33);
    });
    Future.delayed(const Duration(milliseconds: 1466), () {
      if (mounted) _wave3Ctrl.forward(from: 0.66);
    });

    // Iniciar escaneo BLE automáticamente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().bleService.startScan();
    });
  }

  @override
  void dispose() {
    _radarCtrl.dispose();
    _wave1Ctrl.dispose();
    _wave2Ctrl.dispose();
    _wave3Ctrl.dispose();
    super.dispose();
  }

  // ── Vinculación ───────────────────────────────────────────────────────────
  Future<void> _connectDevice() async {
    if (_selectedDevice == null || _connecting) return;
    setState(() => _connecting = true);

    final ok = await context.read<AppProvider>().bleService.connectToDevice(_selectedDevice!);

    if (!mounted) return;
    setState(() {
      _connecting = false;
      _connected = ok;
    });

    if (ok) {
      await Future.delayed(const Duration(milliseconds: 1400));
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, anim, __) => FadeTransition(
            opacity: anim,
            child: const HomeScreen(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bleService = context.watch<AppProvider>().bleService;
    final devices = bleService.foundDevices;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            _buildHeader(bleService),

            // ── Radar animado ──────────────────────────────────────────────
            Expanded(
              flex: 4,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ondas concéntricas
                  _RadarWave(controller: _wave1Ctrl, maxRadius: 130, color: AppColors.pinkField),
                  _RadarWave(controller: _wave2Ctrl, maxRadius: 130, color: AppColors.pinkHot),
                  _RadarWave(controller: _wave3Ctrl, maxRadius: 130, color: AppColors.pinkVibrant),
                  // Sweep giratorio
                  AnimatedBuilder(
                    animation: _radarAnim,
                    builder: (_, __) => CustomPaint(
                      size: const Size(260, 260),
                      painter: _RadarSweepPainter(_radarAnim.value),
                    ),
                  ),
                  // Centro: ícono charm
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryPurple,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withValues(alpha: 0.35),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset('assets/icons/app_icon.png', fit: BoxFit.cover),
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                      .scaleXY(begin: 0.95, end: 1.05, duration: 1200.ms),

                  // Puntos de dispositivos flotando en el radar
                  ...List.generate(
                    devices.length,
                    (i) => _buildDeviceDot(devices[i], i, devices.length),
                  ),
                ],
              ),
            ),

            // ── Estado escaneo ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: bleService.isScanning
                    ? Row(
                        key: const ValueKey('scanning'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(AppColors.pinkVibrant),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Buscando dispositivos...',
                            style: GoogleFonts.lato(color: AppColors.textGrey, fontSize: 13),
                          ),
                        ],
                      )
                    : Text(
                        key: const ValueKey('found'),
                        '${devices.length} dispositivo${devices.length == 1 ? '' : 's'} encontrado${devices.length == 1 ? '' : 's'}',
                        style: GoogleFonts.lato(
                          color: AppColors.primaryPurple,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            // ── Lista de dispositivos ───────────────────────────────────────
            Expanded(
              flex: 5,
              child: devices.isEmpty
                  ? Center(
                      child: Text(
                        'Asegúrate de que el charm\nestá encendido y cerca',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(color: AppColors.textGrey, fontSize: 14, height: 1.6),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: devices.length,
                      itemBuilder: (ctx, i) {
                        final dev = devices[i];
                        final isSelected = _selectedDevice?.id == dev.id;
                        return _DeviceTile(
                          device: dev,
                          isSelected: isSelected,
                          onTap: () => setState(() => _selectedDevice = dev),
                        ).animate(delay: (i * 120).ms).fadeIn().slideX(begin: 0.3, end: 0);
                      },
                    ),
            ),

            // ── Botón Vincular / Success ───────────────────────────────────
            _buildActionButton(),

            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Configurar más tarde',
                style: GoogleFonts.lato(color: AppColors.textGrey, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(BleService bleService) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.primaryPurple,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VINCULAR DISPOSITIVO',
                  style: GoogleFonts.playfairDisplay(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  'Alarma Dos — ESP32-C3',
                  style: GoogleFonts.lato(color: AppColors.pinkField, fontSize: 12),
                ),
              ],
            ),
          ),
          // Botón re-escanear
          GestureDetector(
            onTap: () {
              setState(() { _selectedDevice = null; _connected = false; });
              bleService.startScan();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.refresh, color: AppColors.white, size: 18),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  // ── Punto en el radar para cada dispositivo ───────────────────────────────
  Widget _buildDeviceDot(BleDeviceResult dev, int index, int total) {
    final angle = (index / total) * 2 * pi - pi / 2;
    final radius = 70.0 + (dev.rssi.abs() - 40) * 0.6;
    final clampedR = radius.clamp(55.0, 115.0);
    final x = cos(angle) * clampedR;
    final y = sin(angle) * clampedR;

    return Transform.translate(
      offset: Offset(x, y),
      child: GestureDetector(
        onTap: () => setState(() => _selectedDevice = dev),
        child: Container(
          width: dev.isAlarmaDos ? 22 : 14,
          height: dev.isAlarmaDos ? 22 : 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dev.isAlarmaDos
                ? AppColors.primaryPurple
                : AppColors.pinkHot.withValues(alpha: 0.6),
            border: Border.all(
              color: _selectedDevice?.id == dev.id ? AppColors.gold : Colors.transparent,
              width: 2.5,
            ),
            boxShadow: dev.isAlarmaDos
                ? [BoxShadow(color: AppColors.primaryPurple.withValues(alpha: 0.5), blurRadius: 8)]
                : [],
          ),
          child: dev.isAlarmaDos
              ? ClipOval(child: Image.asset('assets/icons/app_icon.png', fit: BoxFit.cover))
              : null,
        ),
      ),
    ).animate(delay: (index * 200).ms).scale(duration: 600.ms, curve: Curves.elasticOut);
  }

  // ── Botón de acción ───────────────────────────────────────────────────────
  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
        child: _connected
            // ✓ Éxito
            ? Container(
                key: const ValueKey('success'),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'Dispositivo Vinculado',
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ).animate().scale(duration: 500.ms, curve: Curves.elasticOut)
            : _connecting
                // Spinner elegante
                ? Container(
                    key: const ValueKey('loading'),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(AppColors.pinkField),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Vinculando...',
                          style: GoogleFonts.lato(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )
                // Botón normal
                : GestureDetector(
                    key: const ValueKey('idle'),
                    onTap: _selectedDevice != null ? _connectDevice : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: _selectedDevice != null
                            ? AppColors.primaryPurple
                            : AppColors.bgLight,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: _selectedDevice != null
                            ? [BoxShadow(
                                color: AppColors.primaryPurple.withValues(alpha: 0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              )]
                            : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bluetooth_connected,
                            color: _selectedDevice != null ? AppColors.white : AppColors.textGrey,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _selectedDevice != null
                                ? 'Vincular "${_selectedDevice!.name}"'
                                : 'Selecciona un dispositivo',
                            style: GoogleFonts.lato(
                              color: _selectedDevice != null ? AppColors.white : AppColors.textGrey,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tile individual de dispositivo en la lista
// ─────────────────────────────────────────────────────────────────────────────
class _DeviceTile extends StatelessWidget {
  final BleDeviceResult device;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeviceTile({
    required this.device,
    required this.isSelected,
    required this.onTap,
  });

  String get _signalLabel {
    final r = device.rssi;
    if (r > -55) return 'Excelente';
    if (r > -70) return 'Buena';
    return 'Débil';
  }

  Color get _signalColor {
    final r = device.rssi;
    if (r > -55) return AppColors.success;
    if (r > -70) return AppColors.gold;
    return AppColors.textGrey;
  }

  int get _signalBars {
    final r = device.rssi;
    if (r > -55) return 3;
    if (r > -70) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryPurple.withValues(alpha: 0.06)
              : AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : AppColors.bgLight,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(
                  color: AppColors.primaryPurple.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )]
              : [BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )],
        ),
        child: Row(
          children: [
            // Ícono
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: device.isAlarmaDos
                    ? AppColors.primaryPurple
                    : AppColors.bgLight,
              ),
              child: device.isAlarmaDos
                  ? ClipOval(child: Image.asset('assets/icons/app_icon.png', fit: BoxFit.cover))
                  : Icon(
                      Icons.bluetooth,
                      color: AppColors.textGrey,
                      size: 24,
                    ),
            ),
            const SizedBox(width: 14),
            // Nombre + badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        device.name.isEmpty ? 'Dispositivo desconocido' : device.name,
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: device.isAlarmaDos
                              ? AppColors.primaryPurple
                              : AppColors.textDark,
                        ),
                      ),
                      if (device.isAlarmaDos) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            'Alarma Dos',
                            style: GoogleFonts.lato(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        device.id.toUpperCase(),
                        style: GoogleFonts.lato(fontSize: 11, color: AppColors.textGrey),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${device.rssi} dBm',
                        style: GoogleFonts.lato(fontSize: 10, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Indicador de señal
            Column(
              children: [
                _SignalBars(bars: _signalBars, color: _signalColor),
                const SizedBox(height: 4),
                Text(
                  _signalLabel,
                  style: GoogleFonts.lato(fontSize: 10, color: _signalColor, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(width: 10),
              const Icon(Icons.check_circle, color: AppColors.primaryPurple, size: 22),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Barras de señal ───────────────────────────────────────────────────────────
class _SignalBars extends StatelessWidget {
  final int bars;
  final Color color;
  const _SignalBars({required this.bars, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(3, (i) {
        final active = i < bars;
        return Container(
          width: 5,
          height: 8.0 + i * 4,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            color: active ? color : AppColors.bgLight,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CustomPainter: sweep giratorio del radar
// ─────────────────────────────────────────────────────────────────────────────
class _RadarSweepPainter extends CustomPainter {
  final double angle;
  _RadarSweepPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Círculo base
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.pinkField.withValues(alpha: 0.12)
        ..style = PaintingStyle.fill,
    );

    // Borde
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.pinkVibrant.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Círculos guía
    for (final r in [radius * 0.33, radius * 0.66]) {
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..color = AppColors.pinkVibrant.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );
    }

    // Líneas de cuadrícula (cruz)
    final gridPaint = Paint()
      ..color = AppColors.pinkVibrant.withValues(alpha: 0.15)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(center.dx - radius, center.dy), Offset(center.dx + radius, center.dy), gridPaint);
    canvas.drawLine(Offset(center.dx, center.dy - radius), Offset(center.dx, center.dy + radius), gridPaint);

    // Sweep (sector con gradiente)
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          AppColors.pinkVibrant.withValues(alpha: 0.0),
          AppColors.pinkVibrant.withValues(alpha: 0.35),
        ],
        startAngle: angle - 1.2,
        endAngle: angle,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: center, radius: radius)));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      angle - 1.2,
      1.2,
      true,
      sweepPaint,
    );
    canvas.restore();

    // Línea del sweep
    canvas.drawLine(
      center,
      Offset(center.dx + cos(angle) * radius, center.dy + sin(angle) * radius),
      Paint()
        ..color = AppColors.pinkVibrant.withValues(alpha: 0.6)
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_RadarSweepPainter old) => old.angle != angle;
}

// ─────────────────────────────────────────────────────────────────────────────
// Onda concéntrica animada
// ─────────────────────────────────────────────────────────────────────────────
class _RadarWave extends StatelessWidget {
  final AnimationController controller;
  final double maxRadius;
  final Color color;

  const _RadarWave({
    required this.controller,
    required this.maxRadius,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;
        return Container(
          width: maxRadius * 2 * t,
          height: maxRadius * 2 * t,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: (1 - t) * 0.4),
              width: 1.5,
            ),
          ),
        );
      },
    );
  }
}
