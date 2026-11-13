import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../providers/payment_methods_provider.dart';
import '../../widgets/navigation_helper.dart';
import '../../main_shell.dart';
import '../../utils/global_colors.dart';

class PaymentWebViewScreen extends ConsumerStatefulWidget {
  final String url;
  final bool shouldCallFreeOrder;
  const PaymentWebViewScreen({
    super.key,
    required this.url,
    this.shouldCallFreeOrder = false,
  });

  @override
  ConsumerState<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends ConsumerState<PaymentWebViewScreen> {
  InAppWebViewController? _webViewController;
  double _progress = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initSettings();
  }

  Future<void> _initSettings() async {
    try {
      // 1. Fetch the auth token to inject into cookies
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        CookieManager cookieManager = CookieManager.instance();
        final uri = WebUri(widget.url);
        
        // Inject token for the domain to maintain session/CSRF
        await cookieManager.setCookie(
          url: uri,
          name: "token", // Ensure this matches your backend's expected cookie name
          value: token,
          domain: uri.host,
          path: "/",
          isSecure: true,
          sameSite: HTTPCookieSameSitePolicy.LAX,
        );
      }

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Error initializing WebView settings: $e");
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  void _handlePaymentSuccess() async {
    if (widget.shouldCallFreeOrder) {
      await ref.read(paymentMethodsProvider.notifier).freeOrderPayment();
    }
    Fluttertoast.showToast(
      msg: "Payment Successful!",
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    if (mounted) {
      NavigationHelper.replaceAllWith(
        context,
        const MainShell(),
      );
    }
  }

  void _handlePaymentFailure(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Payment'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Show confirmation dialog before exiting payment
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('You will be Redirect To Dashboard'),
                content: const Text('Are you sure you want to redirect to dashboard?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      NavigationHelper.replaceAllWith(
                        context,
                        const MainShell(),
                      );
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: !_isInitialized
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          : Stack(
              children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri(widget.url),
                  ),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    thirdPartyCookiesEnabled: true,
                    allowsInlineMediaPlayback: true,
                    cacheEnabled: true,
                    domStorageEnabled: true,
                    databaseEnabled: true,
                    useWideViewPort: true,
                    loadWithOverviewMode: true,
                    userAgent: "Mozilla/5.0 (Linux; Android 13; SM-S901B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",
                    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                    useShouldOverrideUrlLoading: true,
                    allowFileAccessFromFileURLs: true,
                    allowUniversalAccessFromFileURLs: true,
                    javaScriptCanOpenWindowsAutomatically: true,
                    supportMultipleWindows: true, // Enabled for 3D Secure redirects
                  ),
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                  onCreateWindow: (controller, createWindowAction) async {
                    // Handle window.open() if the gateway uses it
                    showDialog(
                      context: context,
                      builder: (context) {
                        return WindowPopup(createWindowAction: createWindowAction);
                      },
                    );
                    return true;
                  },
                  shouldOverrideUrlLoading: (controller, navigationAction) async {
                    final url = navigationAction.request.url?.toString() ?? "";
                    debugPrint("Overriding URL: $url");
                    
                    if (url.contains('payment-success') || url.contains('status=success')) {
                      _handlePaymentSuccess();
                      return NavigationActionPolicy.CANCEL;
                    }
                    
                    if (url.contains('payment-failed') || url.contains('status=failed')) {
                      _handlePaymentFailure("Payment failed. Please try again.");
                      return NavigationActionPolicy.CANCEL;
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onProgressChanged: (controller, progress) {
                    setState(() {
                      _progress = progress / 100;
                    });
                  },
                  onLoadStop: (controller, url) async {
                    if (url != null) {
                      final urlString = url.toString();
                      debugPrint("WebView Load Stopped: $urlString");
                      
                      // Check for success/failure patterns in the final URL
                      if (urlString.contains('payment-success') || 
                          urlString.contains('status=success') ||
                          urlString.contains('/thank-you')) {
                        _handlePaymentSuccess();
                      } else if (urlString.contains('payment-failed') || 
                                 urlString.contains('status=failed')) {
                        _handlePaymentFailure("Payment was not successful.");
                      }
                    }
                  },
                  onLoadError: (controller, url, code, message) {
                    debugPrint("WebView Error: $message (Code: $code)");
                  },
                ),
                if (_progress < 1.0)
                  LinearProgressIndicator(
                    value: _progress,
                    color: AppColors.primaryColor,
                    backgroundColor: Colors.white,
                  ),
              ],
            ),
    );
  }
}

class WindowPopup extends StatelessWidget {
  final CreateWindowAction createWindowAction;

  const WindowPopup({super.key, required this.createWindowAction});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.8,
        child: InAppWebView(
          windowId: createWindowAction.windowId,
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            thirdPartyCookiesEnabled: true,
            domStorageEnabled: true,
          ),
          onCloseWindow: (controller) {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
