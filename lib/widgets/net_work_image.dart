import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sbi_riverpod_project/widgets/progress_indicator.dart';

class GlobalCachedImage extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  const GlobalCachedImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
  });


  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '$imagePath',
      width: width,
      height: height,
      fit: fit,
      // placeholder: (context, url) => placeholder ?? const LoaderScreen(),
      // errorWidget: (context, url, error) => placeholder ?? LoaderScreen(),
    );
  }
}
