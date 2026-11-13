import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/category_main_model.dart';
import '../../network/api_urls.dart';
import '../../providers/category_provider.dart';
import '../../providers/sub_category_provider.dart';
import '../../utils/global_colors.dart';
import '../../widgets/custom_app_bar.dart';
import 'sub_category_screen.dart';

class AllCategoriesScreen extends ConsumerStatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  ConsumerState<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends ConsumerState<AllCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(categoryProvider).data == null) {
        ref.read(categoryProvider.notifier).mainCategory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);
    final t = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: 'All Categories',
        showActions: false,
      ),
      body: categoryState.isLoading && categoryState.data == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          : categoryState.error != null && categoryState.data == null
              ? Center(child: Text(categoryState.error!))
              : categoryState.data == null || categoryState.data!.isEmpty
                  ? const Center(child: Text('No categories found'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: categoryState.data!.length,
                      itemBuilder: (context, index) {
                        final category = categoryState.data![index];
                        return InkWell(
                          onTap: () => _onCategoryTap(context, category),
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: CachedNetworkImage(
                                        imageUrl: ApiEndpoints.baseImageUrl + category.icon,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) => const CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                          strokeWidth: 2,
                                        ),
                                        errorWidget: (context, url, error) => const Icon(
                                          Icons.category_outlined,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: t.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }

  Future<void> _onCategoryTap(BuildContext context, CategoryModel category) async {
    try {
      final success = await ref
          .read(subCategoryProvider.notifier)
          .getSubCategories(category.slug);
      
      if (!mounted) return;
      
      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SubCategoryScreen(
              category: category,
            ),
          ),
        );
      } else {
        final error = ref.read(subCategoryProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Failed to load subcategories'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load subcategories'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
