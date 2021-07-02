import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [SettingService] SharedPreferences Service Util
///
/// Utils for using SharedPreferences
///
/// It should be initialized before starting the app
class SettingService extends GetxService {
  SharedPreferences? _instance;

  SharedPreferences? get instance => _instance;

  static SettingService get it => Get.find<SettingService>();

  /// get SharedPreferences instance
  Future<SharedPreferences> getInstance() async {
    if (_instance == null) {
      _instance = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  /// init instance
  Future<SettingService> init() async {
    await getInstance();
    return this;
  }

  /// get String
  String getString(String key, [String defaultValue = ""]) {
    return _instance?.getString(key) ?? defaultValue;
  }

  /// get Boolean
  bool getBool(String key, [bool defaultValue = false]) {
    return _instance?.getBool(key) ?? defaultValue;
  }

  /// get Int
  int getInt(String key, [int defaultValue = 0]) {
    return _instance?.getInt(key) ?? defaultValue;
  }

  /// get Double
  double getDouble(String key, [double defaultValue = 0.00]) {
    return _instance?.getDouble(key) ?? defaultValue;
  }

  /// get string list
  List<String> getStringList(String key,
      [List<String> defaultValue = const []]) {
    return _instance?.getStringList(key) ?? defaultValue;
  }

  /// get all persisted keys
  Set<String> getKeys(String key, [Set<String> defaultValue = const {}]) {
    return _instance?.getKeys() ?? defaultValue;
  }
}
