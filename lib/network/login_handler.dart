
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthResponse { FAILED,SUCCESS,EXCEPTION,OTHER_REASON }
enum RestResponse { failed,noDataFound,authFail,NODATARETRIEVEDFROMAPI,SERVERNOTRESPONDING }
enum SharedPreferenceIOType { STRING, INTEGER, BOOL, DOUBLE, LIST }
SharedPreferences? _sharedPreferences;


Future<bool> internetConnectivityCheck() async {
  List<ConnectivityResult> result = [];

  try {
    result = await Connectivity().checkConnectivity();
  } on PlatformException catch (e) {
    print(e.toString());
  }

  // Check if any interface is available (like wifi/mobile/ethernet)
  if (result.any((r) => r != ConnectivityResult.none)) {
    return true;
  }

  return false;
}

class AppSettings{

  static String display_name= "User";

  static ApplicationCoreInfo? appInfo;
  static String headerAndroidVersion = '';
  static String headerIosVersion = '';
  static bool versionCheck = true;
  static String headerCurrentDateTime = '';
  static Map<String,dynamic> api = {};

  static void initializeAppInfoInstance(){
    appInfo = ApplicationCoreInfo();
    print(appInfo);
  }
  static ApiConstants apiConstants = ApiConstants();
  static UserLoginDetails userLoginDetails = UserLoginDetails();
  static Color GREY = Colors.grey;
  static Color WHITE = Colors.white;
  static var sliderupdateCount;
  static bool isDashboard = false;
  static String getBaseURL(){
    return "";
  }
  static Map theme = {};
  static Color toastFailed = Colors.red;

  static getData(String _key, SharedPreferenceIOType type) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if (type == SharedPreferenceIOType.STRING) {
      try {
        if (_sharedPreferences!.getString(_key) != null && _sharedPreferences!.getString(_key)!.isNotEmpty) {
          return _sharedPreferences!.getString(_key) ?? '';
          // return await MyEncryptionDecryption.decryptAES(_sharedPreferences!.getString(_key));
        } else {
          return _sharedPreferences!.getString(_key) ?? '';
        }
      } on Exception catch (e) {
        return _sharedPreferences!.getString(_key) ?? '';
      }
    } else if (type == SharedPreferenceIOType.INTEGER) {
      return _sharedPreferences!.getInt(_key)?? -1;
    } else if (type == SharedPreferenceIOType.BOOL) {
      return _sharedPreferences!.getBool(_key) ?? false;
    } else if (type == SharedPreferenceIOType.DOUBLE) {
      return _sharedPreferences!.getDouble(_key) ?? 0.0;
    }
  }

  static saveData(String _key, _value, type) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if (type == SharedPreferenceIOType.STRING) {
      try {
        await _sharedPreferences!.setString(_key, _value);
        // await _sharedPreferences!.setString(_key, MyEncryptionDecryption.encryptAES(_value));
      } catch (e) {
        print('INVALID DATA TYPE :: ${_key}');
        await _sharedPreferences!.setString(_key, _value);
      }
    }
    else if (type == SharedPreferenceIOType.INTEGER) {
      try{
        await _sharedPreferences!.setInt(_key, _value);
      }
      catch(e){
        print('INVALID DATA TYPE :: $_key');
      }
    }
    else if (type == SharedPreferenceIOType.BOOL) {
      try{
        await _sharedPreferences!.setBool(_key, _value);
      }
      catch(e){
        print('INVALID DATA TYPE :: $_key');
      }

    }
    else if (type == SharedPreferenceIOType.DOUBLE) {
      try{
        await _sharedPreferences!.setDouble(_key, _value);
      }
      catch(e){
        print('INVALID DATA TYPE :: $_key');
      }
    }
    try{
      await appInfo!.updateLocalVariablesWithSharedPreference();
    }
    catch(e){}
  }

  static clearEntireStorage() async {
    await _sharedPreferences!.clear();
    //DefaultCacheManager().emptyCache();
  }

  static clearSpecificStorage() async {
    try{
      for (var EachKey in _sharedPreferences!.getKeys()) {
        if (!EachKey.startsWith('ORG_')) {
          _sharedPreferences!.remove(EachKey);
        }
      }
    }
    catch(e){}
  }

  ///headers
  static Future<Map<String, String>> headers() async{
    Map<String, String> ___headers = <String, String>{};
    ___headers[HttpHeaders.contentTypeHeader] = 'application/json';

    return ___headers;
  }

  static Future<Map<String, String>> headersAayush() async{
    Map<String, String> ___headers = <String, String>{};
    ___headers[HttpHeaders.contentTypeHeader] = 'application/json';
  //  ___headers['x-auth-token'] = "";
  //  ___headers['x-user-name'] = "";
   // ___headers['x-force-reload'] = 'N';
   // ___headers['x-imei'] = '';
   // ___headers['fcmid'] = "";
   // ___headers['deviceid'] ="";
    //___headers['namespace'] = "";
    //___headers['app-name'] = "";
   // ___headers['app-name'] = "";
   // ___headers['org-name'] = "";
    //___headers['app-version'] ="";

    return ___headers;
  }

  ///post call
  static Future<dynamic> callRemotePostAPI(
      {Map<String, dynamic>? payload,
        String? url, Map<String, String>? requestHeaders,
        String? urlRef='',
        BuildContext? buildContext}) async {
    bool internet = await internetConnectivityCheck();
    if(internet){
      try {
        Map<String,String> customHeaders = requestHeaders ?? await headers();
        var response = await http.post(Uri.parse(url!), body: json.encode(payload), headers: customHeaders);
        if (response.statusCode == 200) {
          await saveData(urlRef!+'_TIME', DateTime.now().millisecondsSinceEpoch, SharedPreferenceIOType.INTEGER);
          await saveData(urlRef+'_STATE', 1, SharedPreferenceIOType.INTEGER);
          await saveData(urlRef+'_DATA', response.body.toString(), SharedPreferenceIOType.STRING);
          return response.body;
        }
        else if (response.statusCode == 400) {
          await saveData(urlRef!+'_STATE', 2, SharedPreferenceIOType.INTEGER);
          await saveData(urlRef+'_DATA', response.body.toString(), SharedPreferenceIOType.STRING);
         // return RestResponse.authFail;
          response.body;
        }
        else {
          await saveData(urlRef!+'_STATE', 2, SharedPreferenceIOType.INTEGER);
          await saveData(urlRef+'_DATA', 'FAILED', SharedPreferenceIOType.STRING);
          return RestResponse.failed;
        }
      }
      catch (e) {
        await saveData(urlRef! +'_STATE', 2, SharedPreferenceIOType.INTEGER);
        await saveData(urlRef+'_DATA', 'FAILED', SharedPreferenceIOType.STRING);
        return RestResponse.failed;
      }
    }
    else{
      displayLongErrorToast( "No Internet Connection");
      return RestResponse.failed;
    }
  }

  static Future<dynamic> callRemoteGetAPI({
    String? url,Map<String, String>? requestHeaders,
    String? urlRef = '',BuildContext? buildContext,
  }) async {
    bool internet = await internetConnectivityCheck();
    if (internet) {
      try {
        Map<String, String> customHeaders = requestHeaders ?? await headers();
        var response = await http.get(Uri.parse(url!), headers: customHeaders);

        if (response.statusCode == 200) {
          await saveData('${urlRef}_TIME', DateTime.now().millisecondsSinceEpoch, SharedPreferenceIOType.INTEGER);
          await saveData('${urlRef}_STATE', 1, SharedPreferenceIOType.INTEGER);
          await saveData('${urlRef}_DATA', response.body.toString(), SharedPreferenceIOType.STRING);
          return response.body;
        } else if (response.statusCode == 401) {
          await saveData('${urlRef}_STATE', 2, SharedPreferenceIOType.INTEGER);
          await saveData('${urlRef}_DATA', 'AUTHENTICATION_FAILED', SharedPreferenceIOType.STRING);
          return RestResponse.authFail;
        } else {
          await saveData('${urlRef}_STATE', 2, SharedPreferenceIOType.INTEGER);
          await saveData('${urlRef}_DATA', 'FAILED', SharedPreferenceIOType.STRING);
          return RestResponse.failed;
        }
      } catch (e) {
        await saveData('${urlRef}_STATE', 2, SharedPreferenceIOType.INTEGER);
        await saveData('${urlRef}_DATA', 'FAILED', SharedPreferenceIOType.STRING);
        return RestResponse.failed;
      }
    } else {
      displayLongErrorToast("No Internet Connection");
      return RestResponse.failed;
    }
  }

  static displayLongErrorToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        textColor:Colors.white,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
        gravity: ToastGravity.CENTER,
        backgroundColor: toastFailed,
        fontSize: 12);
  }

  static displayLongSuccessToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        textColor:Colors.white,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        fontSize: 12);
  }

  static displayCustomColorToast(String message,Color bcColor) {
    Fluttertoast.showToast(
        msg: message,
        textColor:Colors.white,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: bcColor,
        fontSize: 12);
  }

}

class ApiConstants {
  static String HOSTURL = 'https://hrview.edukares.in/';
  static String HOSTURLPATH = 'hrviewmobileapi/api/v1/mobile/';
  static String BASE_URL = HOSTURL + HOSTURLPATH;
  String AUTH = 'http://175.101.84.101:10001/MOBILE_USERS/KIOSK/USERLOGIN';///login Api
  String getLoginOtp ='${BASE_URL}loginOTP';///otp Api
  String logOut ='${BASE_URL}createHrSessionOut';///for logout
}

class UserLoginDetails {
  String login_user_name = "";
  String emp_id = "";
  String emp_cd= "";
  String last_session_id= "";
  String user_id= "";
  String UserProfilePicImageData = "";
  String UserProfilePic = "";
  String designationName = "";
}

class ApplicationCoreInfo{
  int userMobileNumber2 = 0;
  bool isLogin = false;

  ApplicationCoreInfo();

  Future<void> updateLocalVariablesWithSharedPreference() async {
     userMobileNumber2 = await AppSettings.getData("USER_MOBILE_NUMBER2", SharedPreferenceIOType.INTEGER);
     isLogin = await AppSettings.getData("USER_ISLOGIN", SharedPreferenceIOType.BOOL);
     /// aap data clear or reload for this method

  }
}