import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cart_provider.dart';
import '../../providers/payment_methods_provider.dart';
import '../../widgets/common_loader.dart';
import '../../utils/global_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/navigation_helper.dart';
import 'payment_webview_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentMethodsProvider.notifier).getPaymentMethods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentMethodsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CommonAppBar(
        title: 'Payment Methods',
        showActions: false,
      ),
      body: Builder(
        builder: (context) {
          if (paymentState.isLoading && paymentState.data == null) {
            return const Center(
              child: CibilLoader(message: 'Fetching payment methods...'),
            );
          }

          if (paymentState.error != null && paymentState.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${paymentState.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.read(paymentMethodsProvider.notifier).getPaymentMethods(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final paymentData = paymentState.data;
          if (paymentData == null) {
            return const Center(
              child: Text('No payment methods available'),
            );
          }

          // In the current model, we only have Razorpay. 
          // If the model evolves to a list, we would use ListView.builder.
          // For now, we show the available gateways.
          final razorpay = paymentData.razorpay;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (razorpay.status)
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CachedNetworkImage(
                      imageUrl: razorpay.logo,
                      width: 40,
                      height: 40,
                      errorWidget: (context, url, error) => const Icon(Icons.payment),
                    ),
                    title: Text(
                      razorpay.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final cartData = ref.read(cartProvider).data;
                      final hasFreeCourse = cartData?.cartCourses.any((course) =>
                              course.price == '0' ||
                              course.price == 0 ||
                              course.price == '0.00') ??
                          false;

                      final response = await ref.read(paymentMethodsProvider.notifier).razorPayment();
                      if (response != null && response.status == 'success' && response.url != null) {
                        if (context.mounted) {
                          NavigationHelper.pushTo(
                            context,
                            PaymentWebViewScreen(
                              url: response.url!,
                              shouldCallFreeOrder: hasFreeCourse,
                            ),
                          );
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: response?.message ?? "Failed to initiate payment",
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
