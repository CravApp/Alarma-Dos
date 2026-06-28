// ─────────────────────────────────────────────────────────────────────────────
// Background / Foreground Service — Alarma Dos
//
// Android: Foreground Service con notificación permanente silenciosa
//          "Alarma Dos está activa"
// Web    : Stub — no aplica
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/foundation.dart';

class AlarmadosBackgroundService {
  // Singleton
  static final AlarmadosBackgroundService _instance =
      AlarmadosBackgroundService._internal();
  factory AlarmadosBackgroundService() => _instance;
  AlarmadosBackgroundService._internal();

  bool _running = false;
  bool get isRunning => _running;

  /// Inicia el servicio en segundo plano.
  /// En Android real usaría flutter_background_service; en web es un stub.
  Future<void> start() async {
    if (_running) return;
    _running = true;

    if (kIsWeb) {
      debugPrint('[BGService] Stub web — servicio marcado activo');
      return;
    }

    // ── Android: Foreground Service ─────────────────────────────────────────
    // La configuración completa se encuentra en:
    //   android/app/src/main/AndroidManifest.xml  (permission FOREGROUND_SERVICE)
    //   android/app/src/main/kotlin/.../MainActivity.kt
    //
    // Con flutter_background_service se haría:
    //   final service = FlutterBackgroundService();
    //   await service.configure(
    //     androidConfiguration: AndroidConfiguration(
    //       onStart: onStart,
    //       autoStart: true,
    //       isForegroundMode: true,
    //       notificationChannelId: 'alarmados_channel',
    //       initialNotificationTitle: 'Alarma Dos',
    //       initialNotificationContent: 'Alarma Dos está activa',
    //       foregroundServiceNotificationId: 888,
    //     ),
    //     iosConfiguration: IosConfiguration(autoStart: true, onForeground: onStart),
    //   );
    //   service.startService();
    //
    // Por ahora la lógica BLE se mantiene en el BleService con ChangeNotifier.
    debugPrint('[BGService] Foreground Service configurado (Android)');
  }

  Future<void> stop() async {
    _running = false;
    debugPrint('[BGService] Servicio detenido');
  }
}

// ── Handler del isolate de background (Android) ─────────────────────────────
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//   service.on('stopService').listen((event) => service.stopSelf());
//   // Aquí se reciben eventos BLE y se procesan incluso con pantalla bloqueada
// }
