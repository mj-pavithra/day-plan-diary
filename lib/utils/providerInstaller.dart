import 'package:flutter/services.dart';

class SecurityProviderUtil {
  static const platform = MethodChannel('com.example.security_provider');

  // Method to call native code to update security provider
  static Future<void> updateSecurityProvider() async {
    try {
       platform.invokeMethod('updateSecurityProvider');
    } on PlatformException catch (e) {
      print("Failed to update provider: ${e.message}");
    }
  }
}
