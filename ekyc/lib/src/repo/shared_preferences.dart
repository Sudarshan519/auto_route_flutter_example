 
import 'package:flutter_pkg/src/const/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EkycPreferences {
  //// DEFINING KEYS
  static const String cardTypeKey = 'cardType';
  static const String cardNumberKey = 'cardNumber';

  /// all negative integer indicates empty value
  ///
  late SharedPreferences _preferences;

  /// page
  int get savePage => _preferences.getInt('page') ?? -1;

  /// card number
  /// getters
  int get cardType => _preferences.getInt(cardTypeKey) ?? -1;
  String get cardNumber => _preferences.getString(cardNumberKey) ?? "";

  ///setters
  set cardType(int data) => _preferences.setInt(cardTypeKey, data);
  set cardNumber(String data) => _preferences.setString(cardNumberKey, data);
  //// images
  String get frontImageByte => _preferences.getString(AppStrings.FRONT) ?? "";
  String get tiltedByte => _preferences.getString(AppStrings.TILTED) ?? "";
  String get backImageByte => _preferences.getString(AppStrings.BACK) ?? "";
  String get selfieByte => _preferences.getString(AppStrings.SELFIE) ?? "";
  String get blinkImageByte => _preferences.getString(AppStrings.BLINK) ?? "";

  /// setter images
  set savePage(int data) => _preferences.setInt('page', data);
  set frontImageByte(String data) =>
      _preferences.setString(AppStrings.FRONT, data);
  set backImageByte(String data) =>
      _preferences.setString(AppStrings.BACK, data);
  set tiltedByte(String data) =>
      _preferences.setString(AppStrings.TILTED, data);
  set selfieByte(String data) =>
      _preferences.setString(AppStrings.SELFIE, data);
  set blinkImageByte(String data) =>
      _preferences.setString(AppStrings.BLINK, data);
  init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  List getEkycState() {
    var stateList = [];
    savePage = -1;
    if (frontImageByte != '') {
      stateList.add(frontImageByte);
      savePage = 0;
    }
    if (tiltedByte != '') {
      stateList.add(tiltedByte);
      savePage = 1;
    }
    if (backImageByte != '') {
      stateList.add(backImageByte);
      savePage = 2;
    }

    if (selfieByte != '') {
      stateList.add(selfieByte);
      savePage = 3;
    }

    if (blinkImageByte != '') {
      stateList.add(blinkImageByte);

      savePage = 4;
    }

    return [savePage, stateList];
  }

  clearAllState() {
    frontImageByte = '';
    backImageByte = '';
    tiltedByte = '';
    selfieByte = '';
    blinkImageByte = '';
  }
}
