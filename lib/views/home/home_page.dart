import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sbi_riverpod_project/providers/enrolled_course_provider.dart';
import 'package:sbi_riverpod_project/providers/popular_courses_provider.dart';
import 'package:sbi_riverpod_project/providers/fresh_courses_provider.dart';
import 'package:sbi_riverpod_project/providers/sub_category_provider.dart';
import 'package:sbi_riverpod_project/views/category/sub_category_screen.dart';
import 'package:sbi_riverpod_project/views/category/all_categories_screen.dart';
import 'package:sbi_riverpod_project/views/category/all_courses_screen.dart';
import '../../models/popular_courses_model.dart';
import '../../utils/async_notifier.dart';
import '../../utils/global_colors.dart';
import '../../widgets/course_card.dart';
import '../../network/api_urls.dart';
import '../../providers/category_provider.dart';
import '../../providers/cart_provider.dart';
import '../cart/cart_screen.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  void _getData() {
    ref.read(categoryProvider.notifier).mainCategory();
    ref.read(popularCoursesProvider.notifier).getPopularCourse();
    ref.read(freshCoursesProvider.notifier).getFreshCourses();
    ref.read(enrolledCourseProvider.notifier).getEnrolledCourses(isRefresh: true);
    ref.read(cartProvider.notifier).getCart();
    // ref.read(courseLevelsProvider.notifier).courseLevels();
    // ref.read(courseLanguageProvider.notifier).courseLanguages();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _getData();
        },
        child: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer(
                            builder: (_, ref, _) {
                              return Text(
                                'Hello, Student 👋',
                                style: t.textTheme.bodyMedium,
                              );
                            },
                          ),
                          Text(
                            'What do you want to learn?',
                            style: t.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryColor, Color(0xFF1E88E5)],
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Get 30% OFF',
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Learn new skills\nand grow faster',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.auto_stories,
                      size: 64,
                      color: Colors.white.withAlpha(220),
                    ),
                  ],
                ),
              ),
              _title(t, 'Categories', onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllCategoriesScreen(),
                  ),
                );
              }),
              Consumer(
                builder: (context, ref, child) {
                  final categoryState = ref.watch(categoryProvider);

                  if (categoryState.isLoading && categoryState.data == null) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
                  }

                  if (categoryState.error != null &&
                      categoryState.data == null) {
                    return Center(child: Text(categoryState.error!));
                  }

                  final categories = categoryState.data ?? [];

                  if (categories.isEmpty) {
                    return const Center(child: Text('No categories found'));
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: categories.length > 8 ? 8 : categories.length,
                    itemBuilder: (_, i) {
                      final category = categories[i];
                      return InkWell(
                        onTap: () async {
                          try {
                            final success = await ref
                                .read(subCategoryProvider.notifier)
                                .getSubCategories(category.slug);
                            if (!context.mounted) return;
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
                                  content: Text(
                                    error ?? 'Failed to load subcategories',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }  catch(e){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to load subcategories'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
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
                                ),
                                child: ClipOval(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          ApiEndpoints.baseImageUrl +
                                          category.icon,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(
                                            color: AppColors.primaryColor,
                                            strokeWidth: 2,
                                          ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              _title(t, 'Popular Courses', onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllCoursesScreen(
                      title: 'Popular Courses',
                      type: CourseListType.popular,
                    ),
                  ),
                );
              }),
              _row(ref.watch(popularCoursesProvider)),
              _title(t, 'Fresh Courses', onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllCoursesScreen(
                      title: 'Fresh Courses',
                      type: CourseListType.fresh,
                    ),
                  ),
                );
              }),
              _row(ref.watch(freshCoursesProvider)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(ThemeData t, String s, {VoidCallback? onViewAll}) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          s,
          style: t.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'View All',
              style: t.textTheme.bodyMedium?.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    ),
  );

  Widget _row(AsyncState<List<CourseModel>> state) {
    if (state.isLoading && state.data == null) {
      return const SizedBox(
        height: 215,
        child: Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
      );
    }

    if (state.error != null && state.data == null) {
      return SizedBox(height: 215, child: Center(child: Text(state.error!)));
    }

    final list = state.data ?? [];

    if (list.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: Text('No courses found')),
      );
    }

    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: list.length,
        itemBuilder: (_, i) => CourseCard(list[i]),
      ),
    );
  }
}
