import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cms_provider.dart';
import '../../utils/global_colors.dart';
import '../../widgets/text_style.dart';

class FaqPage extends ConsumerWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqsAsync = ref.watch(faqsProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'FAQs',
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
      body: faqsAsync.when(
        data: (faqs) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: faqs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: ExpansionTile(
                title: Text(
                  faq.question,
                  style: appTextStyle(
                    font: 'lexend',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                childrenPadding: const EdgeInsets.all(16),
                expandedAlignment: Alignment.topLeft,
                children: [
                  Text(
                    faq.answer,
                    style: appTextStyle(
                      font: 'lexend',
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: appTextStyle(font: 'lexend')),
        ),
      ),
    );
  }
}
