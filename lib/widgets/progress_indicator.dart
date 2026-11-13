// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
//
// void showCustomLoader(BuildContext context) {
//   showGeneralDialog(
//     context: context,
//     barrierDismissible: false,
//     barrierColor: Colors.black.withOpacity(0.5), // Dark background
//     transitionDuration: const Duration(milliseconds: 200),
//     pageBuilder: (context, animation, secondaryAnimation) {
//       return WillPopScope(
//         onWillPop: () async => false, // Back press block
//         child: Scaffold(
//           backgroundColor: Colors.transparent, // Transparent scaffold
//           body: Center(
//             child: Lottie.asset(
//               "assets/jsons/loadData.json",
//               height: 120,
//               width: 120,
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
//
// class LoaderScreen extends StatelessWidget {
//   const LoaderScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false, // Disable back button
//       child: Center(
//         child: SizedBox(
//           height: 200,
//           child: Lottie.asset(
//             "assets/jsons/loadData.json",
//             height: 120,
//             width: 120,
//           ),
//         ),
//       ),
//     );
//   }
// }
