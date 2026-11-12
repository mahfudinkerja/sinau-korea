import 'package:flutter/services.dart';

/// Umpan balik haptic terpusat, bisa dimatikan dari Pengaturan.
class Haptics {
  static bool enabled = true;

  static Future<void> selection() async {
    if (!enabled) return;
    await HapticFeedback.selectionClick();
  }

  static Future<void> light() async {
    if (!enabled) return;
    await HapticFeedback.lightImpact();
  }

  static Future<void> medium() async {
    if (!enabled) return;
    await HapticFeedback.mediumImpact();
  }

  static Future<void> success() async {
    if (!enabled) return;
    await HapticFeedback.mediumImpact();
  }

  static Future<void> error() async {
    if (!enabled) return;
    await HapticFeedback.heavyImpact();
  }
}
