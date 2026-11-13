// import 'package:flutter/material.dart';
//
// class RegisterFormProvider with ChangeNotifier {
//   final firstName = TextEditingController();
//   final lastName = TextEditingController();
//   final email = TextEditingController();
//   final phone = TextEditingController();
//   final password = TextEditingController();
//   final confirmPassword = TextEditingController();
//
//   bool agreeToTerms = false;
//   bool showPassword = false;
//   bool showConfirmPassword = false;
//
//   void toggleAgree() {
//     agreeToTerms = !agreeToTerms;
//     notifyListeners();
//   }
//
//   void toggleShowPassword() {
//     showPassword = !showPassword;
//     notifyListeners();
//   }
//
//   void toggleShowConfirmPassword() {
//     showConfirmPassword = !showConfirmPassword;
//     notifyListeners();
//   }
//
//   void clearForm() {
//     firstName.clear();
//     lastName.clear();
//     email.clear();
//     phone.clear();
//     password.clear();
//     confirmPassword.clear();
//     agreeToTerms = false;
//     showPassword = false;
//     showConfirmPassword = false;
//     notifyListeners();
//   }
// }
