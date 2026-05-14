import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../models/contact_model.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Container(
      color: AppColors.bgLight,  // #E1E1E1
      child: SafeArea(
        child: Column(
          children: [
            // ── Header #782D69 ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
              color: AppColors.primaryPurple,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CONTACTOS',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                      letterSpacing: 2,
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 4),
                  Text(
                    'Personas que recibirán tus alertas',
                    style: GoogleFonts.lato(
                        fontSize: 13, color: AppColors.pinkField),  // #F0B4D2
                  ).animate(delay: 100.ms).fadeIn(),
                  const SizedBox(height: 14),
                  // Badge plan
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          provider.isPremium
                              ? Icons.star
                              : Icons.star_outline,
                          color: provider.isPremium
                              ? AppColors.gold
                              : AppColors.pinkField,
                          size: 15,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          provider.isPremium
                              ? 'Premium — Contactos ilimitados'
                              : 'Gratuito — 1 de 1 contacto',
                          style: GoogleFonts.lato(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 200.ms).fadeIn(),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                children: [
                  if (provider.contacts.isEmpty)
                    _emptyState()
                        .animate()
                        .fadeIn(duration: 400.ms)
                  else
                    ...provider.contacts.asMap().entries.map(
                          (e) => _ContactCard(
                                  contact: e.value, index: e.key)
                              .animate(
                                  delay:
                                      Duration(milliseconds: 80 * e.key))
                              .fadeIn()
                              .slideX(begin: 0.2, end: 0),
                        ),

                  const SizedBox(height: 12),

                  // ── Botón agregar contacto ──
                  GestureDetector(
                    onTap: () {
                      if (!provider.isPremium &&
                          provider.contacts.isNotEmpty) {
                        _showUpgradeDialog(context);
                      } else {
                        _showAddContactDialog(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primaryPurple
                              .withValues(alpha: 0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: AppColors.pinkSoft,  // #F0D2E1
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add,
                                color: AppColors.primaryPurple,
                                size: 18),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Agregar contacto de confianza',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                          if (!provider.isPremium &&
                              provider.contacts.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.gold
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Premium',
                                style: GoogleFonts.lato(
                                  color: AppColors.gold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 16),

                  // Info card — #F0B4D2 rosa input
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.pinkField,   // #F0B4D2
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.primaryPurple, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Tus contactos recibirán una notificación con tu ubicación exacta al activar la alerta.',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: AppColors.primaryPurple,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 400.ms).fadeIn(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(Icons.people_outline,
              size: 52,
              color: AppColors.primaryPurple.withValues(alpha: 0.35)),
          const SizedBox(height: 14),
          Text(
            'Sin contactos aún',
            style: GoogleFonts.lato(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega a alguien de confianza para que reciba tus alertas de emergencia.',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
                fontSize: 13, color: AppColors.textGrey, height: 1.5),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.bgLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Nuevo Contacto',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryPurple),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                hintText: 'Nombre',
                prefixIcon:
                    Icon(Icons.person_outline, color: AppColors.primaryPurple),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Teléfono',
                prefixIcon:
                    Icon(Icons.phone_outlined, color: AppColors.primaryPurple),
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty &&
                      phoneCtrl.text.isNotEmpty) {
                    context.read<AppProvider>().addContact(
                          ContactModel(
                            id: DateTime.now().toString(),
                            name: nameCtrl.text,
                            phone: phoneCtrl.text,
                          ),
                        );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Agregar Contacto'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.primaryPurple,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: AppColors.gold, size: 48),
              const SizedBox(height: 14),
              Text(
                'Plan Premium',
                style: GoogleFonts.playfairDisplay(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Text(
                'Actualiza a Premium para agregar más contactos de confianza y funciones avanzadas.',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    color: AppColors.pinkField, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AppProvider>().upgradeToPremium();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold),
                  child: Text(
                    'Actualizar a Premium',
                    style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Más tarde',
                    style: GoogleFonts.lato(
                        color: AppColors.white.withValues(alpha: 0.6))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final ContactModel contact;
  final int index;
  const _ContactCard({required this.contact, required this.index});

  @override
  Widget build(BuildContext context) {
    // Colores alternos: púrpura principal / rosa hot
    final colors = [
      AppColors.primaryPurple,
      AppColors.pinkVibrant,
      AppColors.pinkHot,
      AppColors.lightPurple,
    ];
    final color = colors[index % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            child: Center(
              child: Text(
                contact.name[0].toUpperCase(),
                style: GoogleFonts.playfairDisplay(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.name,
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                Text(contact.phone,
                    style: GoogleFonts.lato(
                        fontSize: 12, color: AppColors.textGrey)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Activo',
              style: GoogleFonts.lato(
                  color: AppColors.success,
                  fontSize: 11,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
