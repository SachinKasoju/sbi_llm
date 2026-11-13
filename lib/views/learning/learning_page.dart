import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/enrolled_course_model.dart';
import '../../network/api_urls.dart';
import '../../providers/enrolled_course_provider.dart';
import 'learning_details_screen.dart';
import '../../utils/global_colors.dart';
import '../../widgets/text_style.dart';


class LearningPage extends ConsumerStatefulWidget {
  const LearningPage({super.key});

  @override
  ConsumerState<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends ConsumerState<LearningPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(enrolledCourseProvider.notifier).getEnrolledCourses(isRefresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(enrolledCourseProvider.notifier).getEnrolledCourses();
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
    final t = Theme.of(context);
    final state = ref.watch(enrolledCourseProvider);
    final courses = state.data ?? [];

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(enrolledCourseProvider.notifier)
            .getEnrolledCourses(isRefresh: true),
        child: state.isLoading && courses.isEmpty
            ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
            : state.error != null && courses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref
                              .read(enrolledCourseProvider.notifier)
                              .getEnrolledCourses(isRefresh: true),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : courses.isEmpty
                    ? const Center(child: Text('No enrolled courses found'))
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        itemCount: courses.length + (state.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == courses.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(color: AppColors.primaryColor),
                              ),
                            );
                          }

                          final course = courses[index];
                          return _EnrolledCourseCard(course: course);
                        },
                      ),
      ),
    );
  }
}

class _EnrolledCourseCard extends StatelessWidget {
  final EnrolledCourseModel course;
  const _EnrolledCourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LearningDetailsScreen(slug: course.slug),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: ApiEndpoints.baseImageUrl + course.thumbnail,
                    width: 90,
                    height: 70,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[200]),
                    errorWidget: (context, url, error) => Container(
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: t.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: course.progress / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${course.progress}%',
                  style: appTextStyle(
                    font: 'lexend',
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LearningDetailsScreen(slug: course.slug),
                    ),
                  );
                },
                child: Text(
                  'Continue Learning',
                  style: appTextStyle(font: 'lexend', fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
