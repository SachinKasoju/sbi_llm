import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/popular_courses_model.dart';
import '../../network/api_urls.dart';
import '../../providers/popular_courses_provider.dart';
import '../../providers/fresh_courses_provider.dart';
import '../../utils/global_colors.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/text_style.dart';
import 'course_details_screen.dart';

enum CourseListType { popular, fresh }

class AllCoursesScreen extends ConsumerWidget {
  final String title;
  final CourseListType type;

  const AllCoursesScreen({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = type == CourseListType.popular
        ? ref.watch(popularCoursesProvider)
        : ref.watch(freshCoursesProvider);

    final courses = state.data ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: title,
        showActions: false,
      ),
      body: state.isLoading && courses.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          : state.error != null && courses.isEmpty
              ? Center(child: Text(state.error!))
              : courses.isEmpty
                  ? const Center(child: Text('No courses found'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: courses.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailsScreen(slug: course.slug),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: ApiEndpoints.baseImageUrl + course.thumbnail,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.title,
                                        style: appTextStyle(
                                          font: 'lexend',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 8,
                                            backgroundImage: CachedNetworkImageProvider(
                                              ApiEndpoints.baseImageUrl + course.instructor.image,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              course.instructor.name,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            course.price == 0 || course.price == '0'
                                                ? 'Free'
                                                : '₹${course.price}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.primaryColor,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, color: Colors.amber, size: 14),
                                              const SizedBox(width: 2),
                                              Text(
                                                course.averageRating.toStringAsFixed(1),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
