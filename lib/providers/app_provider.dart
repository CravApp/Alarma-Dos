import 'package:flutter/material.dart';
import '../models/contact_model.dart';
import '../services/ble_service.dart';

enum AppScreen { splash, welcome, login, register, permissions, blePairing, home, plans, profile, alert }

class AppProvider extends ChangeNotifier {
  AppScreen _currentScreen = AppScreen.splash;
  bool _isLoggedIn = false;
  bool _locationGranted = false;
  bool _isPremium = false;
  bool _alertActive = false;
  String _userName = '';
  String _userEmail = '';

  // ── BLE state (delegado a BleService pero expuesto aquí para comodidad) ──
  final BleService bleService = BleService();

  final List<ContactModel> _contacts = [
    ContactModel(id: '1', name: 'Mamá', phone: '+52 55 1234 5678', isActive: true),
  ];

  // ── Getters ───────────────────────────────────────────────────────────────
  AppScreen get currentScreen => _currentScreen;
  bool get isLoggedIn => _isLoggedIn;

  /// Retrocompatibilidad: homescreen usa bluetoothConnected
  bool get bluetoothConnected => bleService.isConnected;

  bool get locationGranted => _locationGranted;
  bool get isPremium => _isPremium;
  bool get alertActive => _alertActive;
  String get userName => _userName;
  String get userEmail => _userEmail;
  List<ContactModel> get contacts => List.unmodifiable(_contacts);

  // BLE delgados
  bool get isArmed        => bleService.isArmed;
  int  get deviceBattery  => bleService.batteryLevel;
  String get deviceName   => bleService.pairedDevice?.name ?? 'Alarma Dos';
  bool get isScanning     => bleService.isScanning;

  // ── Constructor ───────────────────────────────────────────────────────────
  AppProvider() {
    // Reenviar cambios de BleService a listeners de AppProvider
    bleService.addListener(_onBleChanged);
  }

  void _onBleChanged() => notifyListeners();

  // ── Auth ──────────────────────────────────────────────────────────────────
  void login(String email, String password) {
    _isLoggedIn = true;
    _userEmail = email;
    _userName = email.split('@').first;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _alertActive = false;
    bleService.disconnect();
    notifyListeners();
  }

  // ── Retrocompatibilidad: toggleBluetooth (usado en home_screen botón ON/OFF) ─
  void toggleBluetooth() {
    if (bleService.isConnected) {
      bleService.disconnect();
    } else {
      // Navegar a pantalla de emparejamiento desde home no aplica aquí;
      // simplemente simula reconexión rápida
      final prev = bleService.foundDevices.isNotEmpty
          ? bleService.foundDevices.firstWhere(
              (d) => d.isAlarmaDos,
              orElse: () => bleService.foundDevices.first,
            )
          : const BleDeviceResult(
              id: 'sim-01', name: 'AlarmaDos', rssi: -48, isAlarmaDos: true);
      bleService.connectToDevice(prev);
    }
    notifyListeners();
  }

  void grantLocation() {
    _locationGranted = true;
    notifyListeners();
  }

  void toggleAlert() {
    _alertActive = !_alertActive;
    notifyListeners();
  }

  void upgradeToPremium() {
    _isPremium = true;
    notifyListeners();
  }

  void addContact(ContactModel contact) {
    if (!_isPremium && _contacts.length >= 1) return;
    _contacts.add(contact);
    notifyListeners();
  }

  @override
  void dispose() {
    bleService.removeListener(_onBleChanged);
    bleService.dispose();
    super.dispose();
  }
}
