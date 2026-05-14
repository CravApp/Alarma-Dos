import 'package:flutter/material.dart';
import '../models/contact_model.dart';

enum AppScreen { splash, welcome, login, register, permissions, home, plans, profile, alert }

class AppProvider extends ChangeNotifier {
  AppScreen _currentScreen = AppScreen.splash;
  bool _isLoggedIn = false;
  bool _bluetoothConnected = false;
  bool _locationGranted = false;
  bool _isPremium = false;
  bool _alertActive = false;
  String _userName = '';
  String _userEmail = '';

  final List<ContactModel> _contacts = [
    ContactModel(id: '1', name: 'Mamá', phone: '+52 55 1234 5678', isActive: true),
  ];

  AppScreen get currentScreen => _currentScreen;
  bool get isLoggedIn => _isLoggedIn;
  bool get bluetoothConnected => _bluetoothConnected;
  bool get locationGranted => _locationGranted;
  bool get isPremium => _isPremium;
  bool get alertActive => _alertActive;
  String get userName => _userName;
  String get userEmail => _userEmail;
  List<ContactModel> get contacts => List.unmodifiable(_contacts);

  void login(String email, String password) {
    _isLoggedIn = true;
    _userEmail = email;
    _userName = email.split('@').first;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _alertActive = false;
    notifyListeners();
  }

  void toggleBluetooth() {
    _bluetoothConnected = !_bluetoothConnected;
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
}
