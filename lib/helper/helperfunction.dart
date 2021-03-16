import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{
  static String sharedPreferencesUserLoggedInKey = 'ISLOGGEDIN';
  static String sharedPreferencesUserNameKey = 'USERNAMEKEY';
  static String sharedPreferencesUserEmailKey = 'USEREMAILKEY';


  /// saving data to SharedPreferences

  static Future<bool> saveUserLoggedInSharePreferences(bool isUserLoggedIn)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferencesUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharePreferences(String userName)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharePreferences(String userEmail)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUserEmailKey, userEmail);
  }


  /// getting data from SharedPreferences

  static Future<bool> getUserLoggedInSharePreferences()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPreferencesUserLoggedInKey);
  }

  static Future<String> getUserNameSharePreferences()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferencesUserNameKey);
  }

  static Future<String> getUserEmailSharePreferences()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferencesUserEmailKey);
  }





}