import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  static final Connectivity _connectivity = Connectivity();
  static final StreamController<bool> _networkController = StreamController<bool>.broadcast();

  static Stream<bool> get onNetworkChange => _networkController.stream;

  static void initialize() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _networkController.add(result != ConnectivityResult.none);
    });
  }
    /// Function to dynamically check network availability
  static Future<bool> isNetworkAvailable() async {
    final ConnectivityResult result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

}
