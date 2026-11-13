import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/wishlist_courses_provider.dart';
import '../../utils/global_colors.dart';
import '../../widgets/text_style.dart';
import '../../widgets/course_card.dart';
import '../../models/popular_courses_model.dart';
import '../../models/wishlist_courses_model.dart';
import '../category/course_details_screen.dart';
import '../../widgets/custom_app_bar.dart';

class WishlistPage extends ConsumerStatefulWidget {
  const WishlistPage({super.key});

  @override
  ConsumerState<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends ConsumerState<WishlistPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(wishlistCoursesProvider.notifier).getWishlistCourses(isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final wishlistState = ref.watch(wishlistCoursesProvider);
    final courses = wishlistState.data ?? [];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CommonAppBar(title: 'My Wishlist'),
      ),
      body: wishlistState.isLoading && courses.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          : courses.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () => ref.read(wishlistCoursesProvider.notifier).getWishlistCourses(isRefresh: true),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailsScreen(slug: course.slug),
                              ),
                            ).then((_) {
                              ref.read(wishlistCoursesProvider.notifier).getWishlistCourses(isRefresh: true);
                            });
                          },
                          child: CourseCard(
                            WishlistCourseAdapter(course),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80.sp, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: appTextStyle(
              font: 'lexend',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explore courses and add them to your wishlist!',
            style: appTextStyle(
              font: 'lexend',
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class WishlistCourseAdapter extends CourseModel {
  WishlistCourseAdapter(WishlistCourse course)
      : super(
          title: course.title,
          slug: course.slug,
          thumbnail: course.thumbnail,
          price: course.price.toString(),
          discount: course.discount.toInt(),
          instructor: Instructor(
            id: course.instructor?.id ?? 0,
            name: course.instructor?.name ?? '',
            image: course.instructor?.image ?? '',
          ),
          students: course.students,
          averageRating: course.averageRating.toDouble(),
        );
}
