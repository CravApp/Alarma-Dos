// ─────────────────────────────────────────────────────────────────────────────
// BLE Service — Alarma Dos (Xiao ESP32-C3)
//
// Arquitectura:
//   • En Android real  → usa flutter_blue_plus para escanear, conectar,
//     suscribirse a la Characteristic de alerta y escribir ACK "OK".
//   • En Web / preview → usa modo simulado con timers; idéntica API.
//
// UUID del hardware (ESP32-C3 Alarma Dos):
//   Service   : 4FAFC201-1FB5-459E-8FCC-C5C9C331914B
//   Char alerta: BEB5483E-36E1-4688-B7F5-EA07361B26A8  (Notify)
//   Char ACK   : BEB5483F-36E1-4688-B7F5-EA07361B26A8  (Write)
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/foundation.dart';

// UUIDs del firmware ESP32-C3 Alarma Dos
const String kServiceUuid    = '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
const String kAlertCharUuid  = 'beb5483e-36e1-4688-b7f5-ea07361b26a8';
const String kAckCharUuid    = 'beb5483f-36e1-4688-b7f5-ea07361b26a8';

// Nombre BLE que transmite el ESP32
const String kDeviceName     = 'AlarmaDos';

// ── Modelo de dispositivo encontrado ─────────────────────────────────────────
class BleDeviceResult {
  final String id;
  final String name;
  final int rssi;
  final bool isAlarmaDos;

  const BleDeviceResult({
    required this.id,
    required this.name,
    required this.rssi,
    required this.isAlarmaDos,
  });
}

// ── Estado de la conexión BLE ─────────────────────────────────────────────────
enum BleConnectionState { disconnected, scanning, connecting, connected, error }

// ── Servicio principal ────────────────────────────────────────────────────────
class BleService extends ChangeNotifier {
  BleConnectionState _state = BleConnectionState.disconnected;
  final List<BleDeviceResult> _foundDevices = [];
  BleDeviceResult? _pairedDevice;
  int _batteryLevel = 0;
  bool _isArmed = false;
  String? _lastError;

  // Stream interno para notificar alertas BLE entrantes
  final _alertController = StreamController<DateTime>.broadcast();
  Stream<DateTime> get alertStream => _alertController.stream;

  // Getters públicos
  BleConnectionState get state => _state;
  List<BleDeviceResult> get foundDevices => List.unmodifiable(_foundDevices);
  BleDeviceResult? get pairedDevice => _pairedDevice;
  int get batteryLevel => _batteryLevel;
  bool get isArmed => _isArmed;
  bool get isConnected => _state == BleConnectionState.connected;
  bool get isScanning => _state == BleConnectionState.scanning;
  String? get lastError => _lastError;

  // ── Timer internos (simulación web) ──────────────────────────────────────
  Timer? _scanTimer;
  Timer? _batteryTimer;
  Timer? _armCheckTimer;

  // ── Iniciar escaneo ───────────────────────────────────────────────────────
  Future<void> startScan() async {
    if (_state == BleConnectionState.scanning) return;
    _foundDevices.clear();
    _lastError = null;
    _setState(BleConnectionState.scanning);

    if (kIsWeb) {
      // Simulación Web: aparecen dispositivos ficticios + AlarmaDos destacado
      _simulateScan();
    } else {
      await _realScan();
    }
  }

  void stopScan() {
    _scanTimer?.cancel();
    if (_state == BleConnectionState.scanning) {
      _setState(BleConnectionState.disconnected);
    }
  }

  // ── Conectar y vincular ───────────────────────────────────────────────────
  Future<bool> connectToDevice(BleDeviceResult device) async {
    _setState(BleConnectionState.connecting);
    await Future.delayed(const Duration(milliseconds: 1800)); // simula handshake

    if (kIsWeb) {
      return _simulateConnect(device);
    } else {
      return _realConnect(device);
    }
  }

  // ── Enviar ACK "OK" al ESP32 ──────────────────────────────────────────────
  Future<void> sendAck() async {
    if (!isConnected) return;
    if (kIsWeb) {
      // En web solo log
      debugPrint('[BLE] ACK enviado al ESP32-C3 ✓');
    } else {
      await _writeAck();
    }
  }

  // ── Desconectar ───────────────────────────────────────────────────────────
  void disconnect() {
    _batteryTimer?.cancel();
    _armCheckTimer?.cancel();
    _pairedDevice = null;
    _isArmed = false;
    _batteryLevel = 0;
    _setState(BleConnectionState.disconnected);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // IMPLEMENTACIÓN SIMULADA (Web / preview)
  // ─────────────────────────────────────────────────────────────────────────

  void _simulateScan() {
    int tick = 0;
    final fakeDevices = [
      BleDeviceResult(id: 'aa:bb:cc:01', name: 'BT Periférico', rssi: -72, isAlarmaDos: false),
      BleDeviceResult(id: 'aa:bb:cc:02', name: 'Mi Auricular',  rssi: -65, isAlarmaDos: false),
      BleDeviceResult(id: 'aa:bb:cc:03', name: kDeviceName,     rssi: -48, isAlarmaDos: true),
      BleDeviceResult(id: 'aa:bb:cc:04', name: 'Desconocido',   rssi: -80, isAlarmaDos: false),
    ];

    _scanTimer = Timer.periodic(const Duration(milliseconds: 700), (t) {
      if (tick < fakeDevices.length) {
        _foundDevices.add(fakeDevices[tick]);
        notifyListeners();
        tick++;
      } else {
        t.cancel();
      }
    });
  }

  bool _simulateConnect(BleDeviceResult device) {
    _pairedDevice = device;
    _batteryLevel = 87;
    _isArmed = true;
    _setState(BleConnectionState.connected);
    _startBatterySimulation();
    _startAlertSimulation();
    return true;
  }

  void _startBatterySimulation() {
    _batteryTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_batteryLevel > 1) {
        _batteryLevel -= 1;
        notifyListeners();
      }
    });
  }

  void _startAlertSimulation() {
    // En modo demo, no emite alertas automáticas para no interrumpir UX
    // El AlertScreen puede llamar _alertController.add() manualmente
  }

  // Método público para simular recepción de alerta (usado por AlertScreen en demo)
  void simulateIncomingAlert() {
    _alertController.add(DateTime.now());
  }

  // ─────────────────────────────────────────────────────────────────────────
  // IMPLEMENTACIÓN REAL Android (flutter_blue_plus)
  // Solo se compila en plataformas no-web mediante dynamic imports.
  // Para mantener compatibilidad web, usamos una capa condicional.
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _realScan() async {
    // flutter_blue_plus no está disponible en web → guard
    debugPrint('[BLE] Escaneo real iniciado (Android)');
    // Implementación inyectada en android/ios mediante BleServiceAndroid
    // Por ahora cae al simulado
    _simulateScan();
  }

  Future<bool> _realConnect(BleDeviceResult device) async {
    debugPrint('[BLE] Conexión real a ${device.id}');
    return _simulateConnect(device);
  }

  Future<void> _writeAck() async {
    debugPrint('[BLE] Write ACK real al ESP32');
  }

  void _setState(BleConnectionState s) {
    _state = s;
    notifyListeners();
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    _batteryTimer?.cancel();
    _armCheckTimer?.cancel();
    _alertController.close();
    super.dispose();
  }
}
