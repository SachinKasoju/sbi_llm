import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sbi_riverpod_project/providers/reviews_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../models/course_details_model.dart';
import '../../providers/course_details_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_courses_provider.dart';
import '../../utils/global_colors.dart';
import '../../widgets/text_style.dart';
import '../../network/api_urls.dart';
import '../cart/cart_screen.dart';
import '../../widgets/custom_app_bar.dart';

class CourseDetailsScreen extends ConsumerStatefulWidget {
  final String slug;
  const CourseDetailsScreen({super.key, required this.slug});

  @override
  ConsumerState<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends ConsumerState<CourseDetailsScreen> with SingleTickerProviderStateMixin {
  bool _isPlayingDemo = false;
  bool _isWishlistLoading = false;
  YoutubePlayerController? _youtubeController;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(courseDetailsProvider.notifier).getCourseDetails(widget.slug);
      ref.read(reviewsProvider.notifier).getReviews(widget.slug);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (_tabController.index == 2) {
        _loadMoreReviews();
      }
    }
  }

  void _loadMoreReviews() {
    final reviewsState = ref.read(reviewsProvider);
    if (reviewsState.isLoading || reviewsState.data?.pagination == null) return;

    final pagination = reviewsState.data!.pagination!;
    if ((pagination.currentPage ?? 0) < (pagination.lastPage ?? 0)) {
      ref.read(reviewsProvider.notifier).getReviews(
            widget.slug,
            page: (pagination.currentPage ?? 0) + 1,
            isLoadMore: true,
          );
    }
  }

  void _initYoutubePlayer(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(courseDetailsProvider);
    final cartState = ref.watch(cartProvider);
    final course = state.data;

    if (state.isLoading && course == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      );
    }

    if (state.error != null && course == null) {
      return Scaffold(
        body: Center(child: Text('Error: ${state.error}')),
      );
    }

    if (course == null) {
      return const Scaffold(
        body: Center(child: Text('No data found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CommonAppBar(
          title: 'Course Details',
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (!_isPlayingDemo)
                  CachedNetworkImage(
                    imageUrl: '${ApiEndpoints.baseImageUrl}${course.thumbnail}',
                    height: 220.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      height: 220.h,
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported, size: 50.sp),
                    ),
                  )
                else
                  Container(
                    height: 220.h,
                    width: double.infinity,
                    color: Colors.black,
                    child: _youtubeController != null
                        ? YoutubePlayer(
                            controller: _youtubeController!,
                            showVideoProgressIndicator: true,
                            onReady: () {
                              debugPrint('Player is ready.');
                            },
                          )
                        : Stack(
                            children: [
                              const Center(
                                child: Text(
                                  "Video not available",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _isPlayingDemo = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                if (course.demoVideo != null && !_isPlayingDemo)
                  InkWell(
                    onTap: () {
                      if (course.demoVideo != null) {
                        _initYoutubePlayer(course.demoVideo!);
                        setState(() {
                          _isPlayingDemo = true;
                        });
                      } else {
                        Fluttertoast.showToast(msg: "Demo video not available");
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.sp),
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.play_arrow, size: 40.sp, color: AppColors.primaryColor),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          course.title ?? '',
                          style: appTextStyle(
                            font: 'lexend',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      _isWishlistLoading
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            )
                          : IconButton(
                              icon: Icon(
                                course.isWishlist == true ? Icons.favorite : Icons.favorite_outline,
                                color: course.isWishlist == true ? Colors.red : Colors.black,
                              ),
                              onPressed: () async {
                                setState(() {
                                  _isWishlistLoading = true;
                                });
                                final success = await ref.read(wishlistCoursesProvider.notifier).addRemoveWishlist(course.slug!);
                                if (success) {
                                  await ref.read(courseDetailsProvider.notifier).getCourseDetails(widget.slug);
                                }
                                if (mounted) {
                                  setState(() {
                                    _isWishlistLoading = false;
                                  });
                                }
                              },
                            ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18.sp),
                      SizedBox(width: 4.w),
                      Text(
                        '${course.averageRating ?? 0} (${course.reviewsCount ?? 0} reviews)',
                        style: appTextStyle(fontSize: 14, color: Colors.grey.shade700),
                      ),
                      SizedBox(width: 16.w),
                      Icon(Icons.people_outline, size: 18.sp, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Text(
                        '${course.students ?? 0} students',
                        style: appTextStyle(fontSize: 14, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundImage: (course.instructor?.image != null)
                            ? CachedNetworkImageProvider(
                                 '${ApiEndpoints.baseImageUrl}${course.instructor!.image}',
                              )
                            : null,
                        child: course.instructor?.image == null ? const Icon(Icons.person) : null,
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Created by',
                            style: appTextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            course.instructor?.name ?? 'Unknown',
                            style: appTextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        'Last updated: ${course.lastUpdated ?? ''}',
                        style: appTextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Divider(height: 32.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _infoItem(Icons.schedule, course.duration ?? '0m'),
                      _infoItem(Icons.language, course.languages ?? 'English'),
                      _infoItem(Icons.quiz, '${course.quizzesCount ?? 0}'),
                      _infoItem(Icons.play_lesson_outlined, '${course.lessonsCount ?? 0} Lessons'),
                    ],
                  ),
                  Divider(height: 32.h),
                  Row(
                    children: [
                      Text(
                        course.price == 0 || course.price == '0' ? 'Free' : '${course.price}',
                        style: appTextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: cartState.isLoading
                            ? null
                            : () async {
                                if (course.slug != null) {
                                  await ref.read(cartProvider.notifier).addToCart(course.slug!);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                        ),
                        child: cartState.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('Add to Cart', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppColors.primaryColor,
                    labelStyle: appTextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    tabs: const [
                      Tab(text: 'Description'),
                      Tab(text: 'Curriculum'),
                      Tab(text: 'Reviews'),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  IndexedStack(
                    index: _tabController.index,
                    children: [
                      _buildDescription(course),
                      _buildCurriculum(course),
                      _buildReviews(),
                    ],
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(CourseDetailsModel course) {
    if (course.description == null || course.description!.isEmpty) {
      return const Center(child: Text('No description available'));
    }
    return Text(
      course.description?.replaceAll(RegExp(r'<[^>]*>'), '') ?? '',
      style: appTextStyle(fontSize: 14, height: 1.5, color: Colors.grey.shade800),
    );
  }

  Widget _buildCurriculum(CourseDetailsModel course) {
    if (course.curriculums == null || course.curriculums!.isEmpty) {
      return const Center(child: Text('No curriculum available'));
    }
    return Column(
      children: course.curriculums!.map((section) => ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(
              section.title ?? 'Section',
              style: appTextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            children: section.chapters?.map((chapter) {
                  IconData icon = Icons.insert_drive_file_outlined;
                  if (chapter.type == 'live') icon = Icons.live_tv;
                  if (chapter.type == 'lesson') icon = Icons.play_circle_outline;
                  if (chapter.type == 'quiz') icon = Icons.quiz_outlined;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(icon, color: AppColors.primaryColor, size: 20.sp),
                    title: Text(chapter.item?.title ?? 'No Title', style: appTextStyle(fontSize: 14)),
                    subtitle: chapter.item?.duration != null ? Text(chapter.item!.duration!, style: appTextStyle(fontSize: 12, color: Colors.grey)) : null,
                    trailing: chapter.item?.isFree == true ? const Text('Free', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)) : Icon(Icons.lock_outline, size: 18.sp, color: Colors.grey),
                  );
                }).toList() ??
                [],
          )).toList(),
    );
  }

  Widget _buildReviews() {
    final reviewsState = ref.watch(reviewsProvider);
    final reviews = reviewsState.data?.data ?? [];

    if (reviewsState.isLoading && reviews.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
    }

    if (reviews.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('No reviews yet'),
        ),
      );
    }

    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          separatorBuilder: (context, index) => Divider(height: 24.h, color: Colors.grey.shade100),
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundImage: review.avatar != null
                      ? CachedNetworkImageProvider(
                          review.avatar!.startsWith('http') ? review.avatar! : '${ApiEndpoints.baseImageUrl}${review.avatar}',
                        )
                      : null,
                  child: review.avatar == null ? const Icon(Icons.person, size: 20) : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.name ?? 'Anonymous',
                        style: appTextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Row(
                        children: List.generate(
                            5,
                            (i) => Icon(
                                  Icons.star,
                                  size: 14.sp,
                                  color: i < (review.rating ?? 0) ? Colors.amber : Colors.grey.shade300,
                                )),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        review.review ?? '',
                        style: appTextStyle(fontSize: 13, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        if (reviewsState.isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
      ],
    );
  }

  Widget _infoItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 24.sp),
        SizedBox(height: 4.h),
        Text(label, style: appTextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }
}

