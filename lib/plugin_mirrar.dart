
import 'dart:async';

import 'package:flutter/services.dart';

class PluginMirrar {
  static const MethodChannel _channel = MethodChannel('plugin_mirrar');

  static void launchTyrOn(Map<String, dynamic> options) {
    _channel.invokeMethod('launchTyrOn', options);
  }
}