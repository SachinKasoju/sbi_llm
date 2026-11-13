import 'dart:convert';
import 'package:flutter/material.dart';
import '../network/login_handler.dart';
import '../utils/global_colors.dart';


class InitFile extends StatefulWidget {

  @override
  _InitFileState createState() => _InitFileState();
}

class _InitFileState extends State<InitFile> {
  bool internet = false;

  Future<void> initialization()async{
    internet =  await internetConnectivityCheck();
    if (mounted) {
      setState(() {});
    }
  }


  Widget retryButton(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: AppColors.primaryColor,
        padding: const EdgeInsets.all(12.0),
        textStyle: const TextStyle(fontSize: 20),
      ),
      onPressed: () async {
        internet =  await internetConnectivityCheck();
        if(internet){
          try{
            if (context.mounted) {
             /// preloader
             // preloaderWindow(context);
            }
            var appData = await AppSettings.callRemotePostAPI(
                urlRef:"APP_DATA" ,
                url:AppSettings.api['APP_DATA'],
                payload: {
                  "orgKey":""
                }
            );

            if(appData!=RestResponse.failed && appData!=RestResponse.authFail){
              await AppSettings.saveData("ORG_APP_DATA", jsonEncode(jsonDecode(appData)["data"]), SharedPreferenceIOType.STRING);
              await AppSettings.saveData("ORG_LAST_APP_DATA_DATE_STAMP", jsonDecode(appData)["responseDate"], SharedPreferenceIOType.INTEGER);
              await AppSettings.saveData("ORG_APP_DATA_API_INTERVAL", jsonDecode(appData)["data"]["updateFrequencyInMinutes"], SharedPreferenceIOType.INTEGER);

              if (context.mounted) {
                Navigator.pop(context);
              }
              bool loginCheck = await AppSettings.getData("USER_ISLOGIN", SharedPreferenceIOType.BOOL);
              if (loginCheck) {
                try{
                  if (context.mounted) {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => CirrilHome()),);
                  }
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()),);
                }
                catch(e){
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()),);
                }
              }
              else{
                //Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()),);
              }
            }
            else{
              if(context.mounted){
                Navigator.pop(context);
              }
              AppSettings.displayLongErrorToast("Something went wrong try again");
            }
          }
          catch(e){
            if (context.mounted) {
              Navigator.pop(context);
            }
            AppSettings.displayLongErrorToast("Something went wrong try again");
          }
        }
        else{
          AppSettings.displayLongErrorToast("No Internet Connection");
        }
      },
      child: const Text(
        "Retry",
        style: TextStyle(
          fontSize: 13,
          color:  Colors.red,
        ),
      ),
    );
  }

  @override
  void initState() {
    initialization();
    super.initState();
  }

  Widget buildUI(){
    if(internet == false){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('images/internet.png'),
            width: 200,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            "No Internet Connection",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontFamily: 'Swis2',
            ),
          ),
          const SizedBox(height: 15,),
          const Text("Please check Your network Connection and Retry",style: TextStyle(fontSize: 18),),
          const SizedBox(height: 30,),
          retryButton(),
        ],
      );
    }
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Close the app and try again to load it.",style: TextStyle(fontSize: 22),),
        const SizedBox(height: 30,),
        retryButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body:Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: buildUI(),
        ),
      ),
    );
  }
}
