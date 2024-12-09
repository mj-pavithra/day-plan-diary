import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static final SessionService _instance = SessionService._();
  static SharedPreferences? _prefs;
  static const String counterKey = 'globalCounter';

  // Private constructor
  SessionService._();

  // Factory constructor to return the singleton instance
  factory SessionService() => _instance;

  // Returns the singleton instance after ensuring SharedPreferences is initialized
  static Future<SessionService> getInstance() async {
    if (_prefs == null) {
      await _instance._initializeSharedPreferences();
    }
    return _instance;
  }

  // Initialize SharedPreferences
  Future<void> _initializeSharedPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Check if SharedPreferences is initialized
  bool isPrefsInitialized() => _prefs != null;

  // Increment the counter value and save it in SharedPreferences
  Future<int> incrementCounter() async {
    await _initializeIfRequired();
    int currentValue = _prefs!.getInt(counterKey) ?? 0;
    currentValue++;
    await _prefs!.setInt(counterKey, currentValue);
    return currentValue;
  }

  // Get the counter value
  int getCounter() {
    if (!isPrefsInitialized()) {
      throw Exception("SharedPreferences not initialized.");
    }
    return _prefs!.getInt(counterKey) ?? 0;
  }

  // Reset the counter value to 0
  Future<void> resetCounter() async {
    await _initializeIfRequired();
    await _prefs!.setInt(counterKey, 0);
  }

  // Set the counter value to a specific number
  Future<void> setCounter(int value) async {
    await _initializeIfRequired();
    await _prefs!.setInt(counterKey, value);
  }

  // Ensure SharedPreferences is initialized before performing any operation
  Future<void> _initializeIfRequired() async {
    if (_prefs == null) {
      await _initializeSharedPreferences();
    }
  }
}
