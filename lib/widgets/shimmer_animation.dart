import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLayout {
  /// Entry point
  static Widget buildShimmerUI({required String type}) {
    switch (type) {
      case 'buildShimmerUI':
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            shimmerBox(height: 20, width: 150),
            const SizedBox(height: 8),
            shimmerBox(height: 14, width: 120),
            const SizedBox(height: 12),
            shimmerBox(height: 48, width: double.infinity),
            const SizedBox(height: 20),
            shimmerList(height: 100, width: 80, itemCount: 5, isCircle: true),
            const SizedBox(height: 20),
            shimmerList(height: 200, width: 300, itemCount: 3),
            const SizedBox(height: 20),
            shimmerList(height: 250, width: 200, itemCount: 3),
          ],
        );

      case 'shimmerList1':
        return shimmerList(height: 100, width: 80, itemCount: 5, isCircle: true);

      case 'shimmerList2':
        return shimmerList(height: 200, width: 300, itemCount: 3);

      case 'shimmerList3':
        return shimmerList(height: 250, width: 200, itemCount: 3);

      default:
        return const SizedBox(); // fallback
    }
  }

  /// Reusable shimmer list
  static Widget shimmerList({
    required double height,
    required double width,
    required int itemCount,
    bool isCircle = false,
  }) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: isCircle
              ? shimmerCircle()
              : shimmerBox(height: height, width: width),
        ),
      ),
    );
  }

  /// Box shimmer
  static Widget shimmerBox({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Circle shimmer
  static Widget shimmerCircle() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: const CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
      ),
    );
  }

  static Widget shimmerLine({required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 16,
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static Widget buildShimmerWalletUi(){
    return ListView(
      children: [
        shimmerBox(height: 140, width: double.infinity), // walletCard
        const SizedBox(height: 12),
        shimmerBox(height: 100, width: double.infinity), // referAndEarn
        const SizedBox(height: 12),
        shimmerBox(height: 80, width: double.infinity), // transferTipCard
        const SizedBox(height: 20),
        shimmerLine(width: 160), // "Transaction History" text
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              shimmerLine(width: 120), // "All Transactions"
              const SizedBox(width: 20),
              shimmerLine(width: 80), // "Pending"
            ],
          ),
        ),
        const SizedBox(height: 16),
        // 🔁 3 shimmer transaction tiles
        for (int i = 0; i < 3; i++) ...[
          shimmerBox(height: 60, width: double.infinity),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

///calling for simmer effect .don not delete
//  Total shimmer UI
//ShimmerLayout.buildShimmerUI(type: 'buildShimmerUI');

//  Only categories (circle list)
//ShimmerLayout.buildShimmerUI(type: 'shimmerList1');

//  Only services (box list 1)
//ShimmerLayout.buildShimmerUI(type: 'shimmerList2');

//  Only nearby (box list 2)
//ShimmerLayout.buildShimmerUI(type: 'shimmerList3');
