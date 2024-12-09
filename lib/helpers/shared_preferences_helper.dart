// import 'package:shared_preferences/shared_preferences.dart';
// import '../utils/constants.dart';

// class SharedPreferencesHelper {
//   // Singleton instance and token
//   static SharedPreferencesHelper? _instance;

//   static String? _token;
//   static String? _refreshToken;

//   // SharedPreferences instance
//   static late SharedPreferences _prefs;

//   // Private constructor
//   SharedPreferencesHelper._internal();

//   // Factory constructor
//   factory SharedPreferencesHelper() {
//     return _instance ??= SharedPreferencesHelper._internal();
//   }

//   // Static method to get the singleton instance
//   static Future<SharedPreferencesHelper?> getInstance() async {
//     if (_instance == null) {
//       _instance = SharedPreferencesHelper._internal();
//       await _instance!._initializeSharedPreferences();
//     }
//     if (_token == null) {
//       _token = await _fetchToken();
//     }
//     if (_refreshToken == null) {
//       _refreshToken = await _fetchRefreshToken();
//     }
//     return _instance;
//   }

//   // Method to initialize SharedPreferences
//   Future<void> _initializeSharedPreferences() async {
//     _prefs = await SharedPreferences.getInstance();
//   }

//   // Method to fetch token from SharedPreferences
//   static Future<String?> _fetchToken() async {
//     return _prefs.getString(JWT_TOKEN);
//   }

//   // Method to fetch refresh token from SharedPreferences
//   static Future<String?> _fetchRefreshToken() async {
//     return _prefs.getString(REFRESH_TOKEN);
//   }

//   // Method to get data by key
//   Future<String?> getData(String key) async {
//     return _prefs.getString(key);
//   }

//   // Method to set data by key
//   Future<void> setValue(String key, String value) async {
//     await _prefs.setString(key, value);
//   }

//   // Method to remove data by key
//   Future<void> removeValue(String key) async {
//     await _prefs.remove(key);
//   }

//   // Method to get the token, cached in the static variable
//   Future<String?> getToken() async {
//     if (_token == null) {
//       _fetchToken().then((value) {
//         _token = value;
//       });
//     }
//     return _token;
//   }

//   // Method to set the token, cached in the static variable
//   Future<void> setToken(String token) async {
//     _token = token;
//     setValue(JWT_TOKEN, token);
//   }

//   // Method to get the refresh token, cached in the static variable
//   Future<String?> getRefreshToken() async {
//     if (_refreshToken == null) {
//       _fetchRefreshToken().then((value) {
//         _refreshToken = value;
//       });
//     }
//     return _refreshToken;
//   }

//   // Method to set the token, cached in the static variable
//   Future<void> setRefreshToken(String token) async {
//     _refreshToken = token;
//     setValue(REFRESH_TOKEN, token);
//   }

//   // Method to clear the cached token
//   Future<void> clearToken() async {
//     _token = null;
//     await removeValue(JWT_TOKEN);
//   }

//   // Method to clear the cached token
//   Future<void> clearRefreshToken() async {
//     _refreshToken = null;
//     await removeValue(REFRESH_TOKEN);
//   }

//   // Static method to reset the singleton instance and token
//   static void reset() {
//     _instance = null;
//     _token = null;
//     _refreshToken = null;
//   }
// }
