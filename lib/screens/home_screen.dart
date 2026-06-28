import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import 'alert_screen.dart';
import 'ble_pairing_screen.dart';
import 'plans_screen.dart';
import 'contacts_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  final List<Widget> _pages = const [
    _HomeTab(),
    ContactsScreen(),
    PlansScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: IndexedStack(index: _navIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _navIndex,
          onTap: (i) => setState(() => _navIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primaryPurple,   // #782D69
          unselectedItemColor: AppColors.textGrey,
          selectedLabelStyle: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.lato(fontSize: 11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.shield_outlined), activeIcon: Icon(Icons.shield), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Contactos'),
            BottomNavigationBarItem(icon: Icon(Icons.star_outline), activeIcon: Icon(Icons.star), label: 'Planes'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // ── Header púrpura #782D69 — exacto del diseño 4.png ──
        Container(
          height: size.height * 0.26,
          decoration: const BoxDecoration(
            color: AppColors.primaryPurple,  // #782D69 sólido
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ── Row: Avatar + saludo ──
                Row(
                  children: [
                    // Avatar circular, como en el diseño 4.png
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                        color: AppColors.pinkHot,
                      ),
                      child: ClipOval(
                        child: Image.asset('assets/icons/app_icon.png', fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bienvenida, ${provider.userName.isNotEmpty ? provider.userName : "Usuario"}',
                            style: GoogleFonts.lato(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'ALARMADOS',
                            style: GoogleFonts.playfairDisplay(
                              color: AppColors.pinkField,  // #F0B4D2
                              fontSize: 13,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Estado conexión
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.bluetooth,
                            size: 14,
                            color: provider.bluetoothConnected
                                ? AppColors.pinkField
                                : AppColors.white.withValues(alpha: 0.4),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            provider.bluetoothConnected ? 'ON' : 'OFF',
                            style: GoogleFonts.lato(
                              color: AppColors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 28),

                // ── Botón SOS central ──
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AlertScreen()),
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Anillos pulsantes — #E178A5 rosa hot, exacto lockscreen
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.pinkHot.withValues(alpha: 0.15),
                          ),
                        ).animate(onPlay: (c) => c.repeat())
                            .scaleXY(begin: 0.9, end: 1.1, duration: 1800.ms, curve: Curves.easeInOut)
                            .then().scaleXY(begin: 1.1, end: 0.9, duration: 1800.ms),
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.pinkHot.withValues(alpha: 0.22),
                          ),
                        ),
                        // Botón central — #782D69 sólido
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryPurple,   // #782D69
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryPurple.withValues(alpha: 0.45),
                                blurRadius: 28,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.warning_rounded, color: AppColors.white, size: 32),
                              const SizedBox(height: 4),
                              Text(
                                'SOS',
                                style: GoogleFonts.playfairDisplay(
                                  color: AppColors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate(delay: 200.ms).scale(duration: 700.ms, curve: Curves.elasticOut),

                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Presiona para activar alerta',
                    style: GoogleFonts.lato(color: AppColors.textGrey, fontSize: 12),
                  ),
                ).animate(delay: 400.ms).fadeIn(),

                const SizedBox(height: 24),

                // ── Status bar ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
                  ),
                  child: Row(
                    children: [
                      _statusChip(Icons.bluetooth, 'BT', provider.bluetoothConnected, AppColors.primaryPurple),
                      _divider(),
                      _statusChip(Icons.location_on, 'GPS', provider.locationGranted, AppColors.pinkVibrant),
                      _divider(),
                      _statusChip(provider.isPremium ? Icons.star : Icons.star_outline, 'Plan', provider.isPremium, AppColors.gold),
                    ],
                  ),
                ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2, end: 0),

                const SizedBox(height: 20),

                // ── Sección Misión / Visión — exacto diseño 4.png ──
                _sectionHeader('Nosotros Somos Alarmados'),
                const SizedBox(height: 6),
                Text(
                  'Para nuestro proyecto, definimos una misión y visión que representan el propósito del producto.',
                  style: GoogleFonts.lato(fontSize: 12, color: AppColors.textGrey, height: 1.5),
                ).animate(delay: 500.ms).fadeIn(),
                const SizedBox(height: 16),

                // Card Misión — #F0D2E1 rosa pálido, exacto diseño
                _misionCard(
                  titulo: 'Misión',
                  texto: 'Brindar seguridad y tranquilidad mediante el desarrollo de un dispositivo tecnológico accesible, discreto y fácil de usar para solicitar ayuda rápida.',
                  bgColor: AppColors.pinkSoft,       // #F0D2E1
                  titleColor: AppColors.pinkVibrant, // #D25A96
                ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2, end: 0),
                const SizedBox(height: 14),

                // Card Visión — #E178A5 rosa hot, exacto diseño
                _misionCard(
                  titulo: 'Visión',
                  texto: 'Fortalecer el bienestar y la protección diaria de los jóvenes mediante el uso de tecnología aplicada a la seguridad.',
                  bgColor: AppColors.pinkHot,   // #E178A5
                  titleColor: AppColors.white,
                  textColor: AppColors.white,
                ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.2, end: 0),

                const SizedBox(height: 20),

                // ── Contactos de confianza ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _sectionHeader('Contactos de Confianza'),
                    if (!provider.isPremium)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
                        ),
                        child: Text('+ Premium', style: GoogleFonts.lato(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w700)),
                      ),
                  ],
                ).animate(delay: 750.ms).fadeIn(),
                const SizedBox(height: 10),

                ...provider.contacts.map(
                  (c) => _contactCard(c.name, c.phone)
                      .animate(delay: 800.ms).fadeIn().slideX(begin: 0.2, end: 0),
                ),

                const SizedBox(height: 16),

                // ── Card dispositivo Alarma Dos — con batería + estado armado ──
                _DeviceCard(provider: provider).animate(delay: 900.ms).fadeIn().slideY(begin: 0.2, end: 0),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusChip(IconData icon, String label, bool active, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: active ? color : AppColors.textGrey.withValues(alpha: 0.4), size: 20),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.lato(color: active ? color : AppColors.textGrey, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 32, color: AppColors.bgLight);

  Widget _sectionHeader(String text) => Text(
        text,
        style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark),
      );

  Widget _misionCard({
    required String titulo,
    required String texto,
    required Color bgColor,
    required Color titleColor,
    Color textColor = const Color(0xFF1A1A1A),
  }) {
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
          Text(titulo, style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w700, color: titleColor)),
          const SizedBox(height: 12),
          Text(texto, style: GoogleFonts.lato(fontSize: 13, color: textColor, height: 1.6)),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(30)),
              child: Text('Ver más', style: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryPurple)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactCard(String name, String phone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryPurple,
            ),
            child: Center(
              child: Text(name[0], style: GoogleFonts.lato(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                Text(phone, style: GoogleFonts.lato(fontSize: 12, color: AppColors.textGrey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('Activo', style: GoogleFonts.lato(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Device Card — Diseño F actualizado
// Muestra: silueta charm | batería | estado Conectado | "Sistema Armado"
// ─────────────────────────────────────────────────────────────────────────────
class _DeviceCard extends StatelessWidget {
  final AppProvider provider;
  const _DeviceCard({required this.provider});

  Color _batteryColor(int pct) {
    if (pct > 50) return AppColors.success;
    if (pct > 20) return AppColors.gold;
    return AppColors.danger;
  }

  IconData _batteryIcon(int pct) {
    if (pct > 90) return Icons.battery_full;
    if (pct > 70) return Icons.battery_5_bar;
    if (pct > 50) return Icons.battery_4_bar;
    if (pct > 30) return Icons.battery_3_bar;
    if (pct > 15) return Icons.battery_2_bar;
    return Icons.battery_1_bar;
  }

  @override
  Widget build(BuildContext context) {
    final connected = provider.bluetoothConnected;
    final battery   = provider.deviceBattery;
    final armed     = provider.isArmed;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryPurple,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Fila principal ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                // Charm image en contenedor crema
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5EDD8), // crema
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset('assets/icons/app_icon.png', fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Alarma Dos',
                            style: GoogleFonts.lato(
                              color: AppColors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Badge ESP32
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
                            ),
                            child: Text(
                              'ESP32-C3',
                              style: GoogleFonts.lato(
                                color: AppColors.gold,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Estado conexión
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: connected ? AppColors.success : AppColors.textGrey,
                              boxShadow: connected
                                  ? [BoxShadow(color: AppColors.success.withValues(alpha: 0.6), blurRadius: 6)]
                                  : [],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            connected ? 'Conectado' : 'Sin conexión',
                            style: GoogleFonts.lato(
                              color: connected ? AppColors.pinkField : AppColors.textGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      // Batería (solo si conectado)
                      if (connected && battery > 0) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              _batteryIcon(battery),
                              color: _batteryColor(battery),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$battery%',
                              style: GoogleFonts.lato(
                                color: _batteryColor(battery),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: battery / 100,
                                  backgroundColor: AppColors.white.withValues(alpha: 0.15),
                                  valueColor: AlwaysStoppedAnimation(_batteryColor(battery)),
                                  minHeight: 5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Botón conectar / desvincular
                GestureDetector(
                  onTap: () {
                    if (connected) {
                      context.read<AppProvider>().toggleBluetooth();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BlePairingScreen()),
                      );
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: connected
                          ? AppColors.pinkHot
                          : AppColors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          connected ? Icons.bluetooth_connected : Icons.bluetooth_searching,
                          color: AppColors.white,
                          size: 18,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          connected ? 'ON' : 'Vincular',
                          style: GoogleFonts.lato(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Divider ───────────────────────────────────────────────────────
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 18),
            color: AppColors.white.withValues(alpha: 0.12),
          ),

          // ── Indicador "Sistema Armado y Vigilando" ─────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                // Ícono check animado
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: armed
                        ? AppColors.success.withValues(alpha: 0.2)
                        : AppColors.white.withValues(alpha: 0.08),
                    border: Border.all(
                      color: armed
                          ? AppColors.success.withValues(alpha: 0.6)
                          : AppColors.white.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    armed ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: armed ? AppColors.success : AppColors.white.withValues(alpha: 0.35),
                    size: 22,
                  ),
                )
                    .animate(
                      target: armed ? 1 : 0,
                      onPlay: (c) => armed ? c.repeat(reverse: true) : null,
                    )
                    .scaleXY(
                      begin: 1.0,
                      end: 1.12,
                      duration: 900.ms,
                      curve: Curves.easeInOut,
                    ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        armed ? 'Sistema Armado y Vigilando' : 'Sistema en espera',
                        style: GoogleFonts.lato(
                          color: armed ? AppColors.success : AppColors.white.withValues(alpha: 0.5),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        armed
                            ? 'Suscrito a notificaciones BLE · Handshake activo'
                            : 'Vincula el dispositivo para activar el monitoreo',
                        style: GoogleFonts.lato(
                          color: AppColors.pinkField.withValues(alpha: 0.7),
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                // Indicador de señal BLE activa
                if (armed)
                  _PulsingDot()
                      .animate(onPlay: (c) => c.repeat())
                      .fadeIn(duration: 600.ms)
                      .then()
                      .fadeOut(duration: 600.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Punto pulsante verde (BLE activo) ────────────────────────────────────────
class _PulsingDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.success,
        boxShadow: [
          BoxShadow(color: AppColors.success.withValues(alpha: 0.7), blurRadius: 8, spreadRadius: 2),
        ],
      ),
    );
  }
}
