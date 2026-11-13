import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/order_provider.dart';
import '../../utils/global_colors.dart';
import 'order_details_page.dart';

import '../../widgets/custom_app_bar.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderProvider.notifier).getOrders(isRefresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(orderProvider.notifier).getOrders();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderProvider);
    final ordersListState = state.ordersList;
    final orders = ordersListState.data ?? [];

    return Scaffold(
      appBar: const CommonAppBar(
        title: 'My Orders',
        showActions: false,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(orderProvider.notifier).getOrders(isRefresh: true),
        child: ordersListState.isLoading && orders.isEmpty
            ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
            : ordersListState.error != null && orders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(ordersListState.error!),
                        ElevatedButton(
                          onPressed: () =>
                              ref.read(orderProvider.notifier).getOrders(isRefresh: true),
                          child: const Text('Retry'),
                        )
                      ],
                    ),
                  )
                : orders.isEmpty
                    ? const Center(child: Text('No orders found'))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: orders.length + (ordersListState.isLoading ? 1 : 0),
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          if (index == orders.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(color: AppColors.primaryColor),
                              ),
                            );
                          }

                          final order = orders[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text('Order ID: ${order.invoiceId}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Amount: ${order.paidAmount}'),
                                  Text('Status: ${order.status}'),
                                ],
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderDetailsPage(
                                      invoiceId: order.invoiceId,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
