import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cms_provider.dart';
import '../../utils/global_colors.dart';
import '../../widgets/text_style.dart';

class CmsDetailsPage extends ConsumerWidget {
  final String title;
  final String slug;

  const CmsDetailsPage({
    super.key,
    required this.title,
    required this.slug,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cmsAsync = slug == 'privacy-policy'
        ? ref.watch(privacyPolicyProvider)
        : ref.watch(termsAndConditionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: appTextStyle(
            font: 'lexend',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: cmsAsync.when(
        data: (cms) => InAppWebView(
          initialData: InAppWebViewInitialData(
            data: """
              <!DOCTYPE html>
              <html>
                <head>
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <style>
                    body { 
                      font-family: 'Lexend', sans-serif; 
                      padding: 16px; 
                      line-height: 1.6; 
                      color: #333;
                    }
                  </style>
                </head>
                <body>
                  ${cms.content}
                </body>
              </html>
            """,
          ),
          initialSettings: InAppWebViewSettings(
            transparentBackground: true,
            supportZoom: false,
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: appTextStyle(font: 'lexend')),
        ),
      ),
    );
  }
}
