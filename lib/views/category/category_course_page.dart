import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sbi_riverpod_project/network/api_urls.dart';
import 'package:sbi_riverpod_project/providers/search_filter_provider.dart';
import 'package:sbi_riverpod_project/providers/search_provider.dart';
import 'package:sbi_riverpod_project/providers/course_details_provider.dart';
import 'package:sbi_riverpod_project/utils/global_colors.dart';
import 'package:sbi_riverpod_project/widgets/text_style.dart';
import 'course_details_screen.dart';

import 'package:sbi_riverpod_project/widgets/custom_app_bar.dart';

class CategoryCoursePage extends ConsumerStatefulWidget {
  final String title;
  const CategoryCoursePage({super.key, required this.title});

  @override
  ConsumerState<CategoryCoursePage> createState() => _CategoryCoursePageState();
}

class _CategoryCoursePageState extends ConsumerState<CategoryCoursePage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCourses();
    });
  }

  void _fetchCourses() {
    final filter = ref.read(searchFilterProvider);
    ref.read(searchProvider.notifier).searchCourses(filter);
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final courses = searchState.data ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: widget.title,
        showActions: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchCourses(),
        child: searchState.isLoading && courses.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              )
            : searchState.error != null && courses.isEmpty
            ? _buildErrorWidget(searchState.error!)
            : courses.isEmpty
            ? const Center(child: Text('No courses found in this category'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: courses.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return GestureDetector(
                    onTap: () {
                      final slug = course.slug;
                      if (slug == null || slug.isEmpty) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailsScreen(slug: slug),
                        ),
                      );
                    },
                    child: Container(
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
                      child: Row(
                        children: [
                          if (course.thumbnail != null)
                            CachedNetworkImage(
                              imageUrl: '${ApiEndpoints.baseImageUrl}${course.thumbnail}',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Container(
                                height: 100,
                                width: 100,
                                color: Colors.grey[200],
                                child: Icon(Icons.image_not_supported, size: 50.sp),
                              ),
                            ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.title ?? '',
                                    style: appTextStyle(
                                      font: 'lexend',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    course.instructor?.name ?? '',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        course.price == 0
                                            ? 'Free'
                                            : '₹${course.price}',
                                        style: const TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                          Text(
                                            course.averageRating?.toString() ??
                                                '0',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              error,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchCourses,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
