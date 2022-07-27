import 'package:advanced_app/presentation/resources_data/language_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefsKeyLang = "PREFS_KEY_LANG";
const String prefsKeyOnBoardingScreenViewed = "prefsKeyOnBoardingScreenViewed";
const String prefsKeyIsUserLoggedIn = "prefsKeyIsUserLoggedIn";

class AppPreference {
  SharedPreferences _sharedPreferences;

  AppPreference(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(prefsKeyLang);

    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      //return default language
      return LanguageType.ENGLISH.getValue();
    }
  }

  // OnBoarding
  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(prefsKeyOnBoardingScreenViewed, true);
  }

  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(prefsKeyOnBoardingScreenViewed) ?? false;
  }

  // Login
  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(prefsKeyIsUserLoggedIn, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(prefsKeyIsUserLoggedIn) ?? false;
  }
}
