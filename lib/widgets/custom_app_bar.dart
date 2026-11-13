import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../network/api_urls.dart';
import '../providers/cart_provider.dart';
import '../providers/cms_provider.dart';
import '../providers/wishlist_courses_provider.dart';
import '../utils/global_colors.dart';
import '../widgets/text_style.dart';
import '../views/cart/cart_screen.dart';
import '../views/wishlist/wishlist_page.dart';

class CommonAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showLogo;
  final bool showActions;

  const CommonAppBar({
    super.key,
    this.title,
    this.actions,
    this.showLogo = false,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartCount = cartState.data?.totalQty ?? 0;
    final settingsState = ref.watch(settingsProvider);

    return AppBar(
      scrolledUnderElevation: 0,
      title: title != null
          ? Text(
              title!,
              style: appTextStyle(
                font: 'lexend',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          : settingsState.when(
              data: (settings) => Row(
                children: [
                  if (settings?.logo != null)
                    CachedNetworkImage(
                      imageUrl: '${ApiEndpoints.baseImageUrl}${settings?.logo}',
                      height: 32.h,
                      placeholder: (context, url) => const SizedBox.shrink(),
                      errorWidget: (context, url, error) => const Icon(Icons.school),
                    ),
                  SizedBox(width: 8.w),
                  Text(
                    settings?.appName ?? '',
                    style: appTextStyle(
                      font: 'lexend',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
      actions: [
        ...?actions,
        if (showActions) ...[
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistPage()),
              );
            },
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {

                  },
                ),
                if (cartCount > 0)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16.w,
                        minHeight: 16.w,
                      ),
                      child: Text(
                        '$cartCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            )
          ),
        ],
        SizedBox(width: 8.w),
      ],
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
