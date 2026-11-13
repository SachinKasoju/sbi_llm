import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/category_main_model.dart';
import '../../providers/search_filter_provider.dart';
import '../../providers/sub_category_provider.dart';
import '../../utils/global_colors.dart';
import '../../widgets/text_style.dart';
import 'category_course_page.dart';
import '../../widgets/custom_app_bar.dart';

class SubCategoryScreen extends ConsumerStatefulWidget {
  final CategoryModel category;
  const SubCategoryScreen({super.key, required this.category});

  @override
  ConsumerState<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends ConsumerState<SubCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final subCategoryState = ref.watch(subCategoryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: widget.category.name,
        showActions: false,
      ),
      body: subCategoryState.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          : subCategoryState.error != null
              ? Center(child: Text(subCategoryState.error!))
              : subCategoryState.data == null || subCategoryState.data!.isEmpty
                  ? const Center(child: Text('No sub-categories found'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: subCategoryState.data!.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final sub = subCategoryState.data![index];
                        final icon = _getIconForSubcategory(sub.name);
                        
                        return InkWell(
                          onTap: () {
                            ref.read(searchFilterProvider.notifier).clear();
                            ref.read(searchFilterProvider.notifier).setCategory(widget.category);
                            ref.read(searchFilterProvider.notifier).setSubCategory(sub);
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryCoursePage(
                                  title: sub.name,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 44,
                                  width: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    icon,
                                    color: AppColors.primaryColor,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    sub.name,
                                    style: appTextStyle(
                                      font: 'lexend',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.grey.shade400,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }

  IconData _getIconForSubcategory(String name) {
    final n = name.toLowerCase();
    if (n.contains('flutter') || n.contains('dart')) return Icons.code_rounded;
    if (n.contains('design') || n.contains('ui') || n.contains('ux') || n.contains('graphic')) return Icons.brush_rounded;
    if (n.contains('web') || n.contains('html') || n.contains('css') || n.contains('javascript') || n.contains('frontend')) return Icons.language_rounded;
    if (n.contains('mobile') || n.contains('android') || n.contains('ios') || n.contains('app')) return Icons.phone_android_rounded;
    if (n.contains('data') || n.contains('python') || n.contains('sql') || n.contains('ai') || n.contains('machine')) return Icons.analytics_rounded;
    if (n.contains('business') || n.contains('marketing') || n.contains('sale') || n.contains('management')) return Icons.business_center_rounded;
    if (n.contains('music') || n.contains('audio') || n.contains('singing')) return Icons.music_note_rounded;
    if (n.contains('photo') || n.contains('video') || n.contains('edit') || n.contains('cinemato')) return Icons.camera_alt_rounded;
    if (n.contains('cloud') || n.contains('aws') || n.contains('azure') || n.contains('devops')) return Icons.cloud_queue_rounded;
    if (n.contains('security') || n.contains('cyber') || n.contains('hacking')) return Icons.security_rounded;
    if (n.contains('game') || n.contains('unity') || n.contains('unreal')) return Icons.videogame_asset_rounded;
    if (n.contains('personal') || n.contains('growth') || n.contains('soft skill')) return Icons.trending_up_rounded;
    if (n.contains('finance') || n.contains('account') || n.contains('trading') || n.contains('stock')) return Icons.account_balance_wallet_rounded;
    if (n.contains('health') || n.contains('fitness') || n.contains('yoga')) return Icons.fitness_center_rounded;
    if (n.contains('language') || n.contains('english') || n.contains('spanish')) return Icons.translate_rounded;
    return Icons.category_outlined;
  }
}
