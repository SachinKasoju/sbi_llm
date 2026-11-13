import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/order_provider.dart';
import '../../utils/global_colors.dart';

import '../../widgets/custom_app_bar.dart';

class OrderDetailsPage extends ConsumerStatefulWidget {
  final String invoiceId;
  const OrderDetailsPage({super.key, required this.invoiceId});

  @override
  ConsumerState<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends ConsumerState<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderProvider.notifier).getOrderInvoice(widget.invoiceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderProvider);
    final invoiceState = state.invoiceDetails;
    final invoice = invoiceState.data;

    return Scaffold(
      appBar: CommonAppBar(
        title: 'Invoice #${widget.invoiceId}',
        showActions: false,
        actions: [
          if (invoice != null)
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                ref.read(orderProvider.notifier).downloadInvoice(widget.invoiceId);
              },
            ),
        ],
      ),
      body: invoiceState.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          : invoiceState.error != null
              ? Center(child: Text(invoiceState.error!))
              : invoice == null
                  ? const Center(child: Text('No invoice details found'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Order Summary'),
                          const SizedBox(height: 8),
                          _buildInfoRow('Invoice ID', invoice.invoiceId),
                          _buildInfoRow('Date', invoice.createdAt),
                          _buildInfoRow('Status', invoice.status),
                          _buildInfoRow('Payment Status', invoice.paymentStatus),
                          _buildInfoRow('Payment Method', invoice.paymentMethod),
                          const Divider(height: 32),
                          _buildSectionTitle('Billed To'),
                          const SizedBox(height: 8),
                          Text(invoice.billedTo?.name ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(invoice.billedTo?.email ?? ''),
                          Text(invoice.billedTo?.phone ?? ''),
                          Text(invoice.billedTo?.address ?? ''),
                          const Divider(height: 32),
                          _buildSectionTitle('Order Items'),
                          const SizedBox(height: 8),
                          ...invoice.orderItems.map((item) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item.courseTitle,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                          Text('Instructor: ${item.instructor}',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                    Text(item.price),
                                  ],
                                ),
                              )),
                          const Divider(height: 32),
                          _buildSectionTitle('Billing Details'),
                          const SizedBox(height: 8),
                          _buildInfoRow('Subtotal', invoice.summary?.subTotal ?? '0'),
                          _buildInfoRow('Discount', invoice.summary?.discount ?? '0'),
                          _buildInfoRow(
                              'Gateway Charge', invoice.summary?.gatewayCharge ?? '0'),
                          const Divider(),
                          _buildInfoRow('Total', invoice.summary?.total ?? '0',
                              isBold: true),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ref.read(orderProvider.notifier).downloadInvoice(widget.invoiceId);
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('Download Invoice'),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
