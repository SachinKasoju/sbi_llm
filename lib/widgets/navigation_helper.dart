

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class NavigationHelper {
  /// Normal push with fade + scale transition
  static pushTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      _buildAnimatedRoute(screen),
    );
  }

  static Route pushToIos(Widget screen) {
    return CupertinoPageRoute(builder: (_) => screen);
  }


  /// Replace all routes with fade + scale transition
  static replaceAllWith(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      _buildAnimatedRoute(screen),
          (route) => false,
    );
  }

  /// Replace current screen with fade + scale transition
  static replaceWith(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      _buildAnimatedRoute(screen),
    );
  }

  /// Core route with Fade + Scale animation
  static PageRouteBuilder _buildAnimatedRoute(Widget screen) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );
        final scale = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: scale,
            child: child,
          ),
        );
      },
    );
  }

/// only ios use
  static Route pushTopLeftToBottomRight(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, -1.0); // top-left
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

}


/*class NavigationHelper {
  ///Normal push with fade transition
  static pushTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return FadeTransition(
            opacity: fade,
            child: child,
          );
        },
      ),
    );
  }

  ///Replace all routes with fade transition
  static replaceAllWith(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return FadeTransition(
            opacity: fade,
            child: child,
          );
        },
      ),
          (route) => false, // Remove all previous routes
    );
  }


  static replaceWith(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return FadeTransition(
            opacity: fade,
            child: child,
          );
        },
      ),
    );
  }

}*/


///KeyboardHelper
class KeyboardHelper {
  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
    print("textpad controller down ");
  }
}

