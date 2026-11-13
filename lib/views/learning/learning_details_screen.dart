import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../network/api_urls.dart';
import '../../providers/learning_provider.dart';
import '../../models/learning_model.dart';
import '../../utils/global_colors.dart';
import '../../widgets/text_style.dart';

import '../../widgets/custom_app_bar.dart';

class LearningDetailsScreen extends ConsumerStatefulWidget {
  final String slug;
  const LearningDetailsScreen({super.key, required this.slug});

  @override
  ConsumerState<LearningDetailsScreen> createState() => _LearningDetailsScreenState();
}

class _LearningDetailsScreenState extends ConsumerState<LearningDetailsScreen> {
  YoutubePlayerController? _youtubeController;
  ChapterItem? _currentLesson;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(learningProvider.notifier).getLearning(widget.slug);
    });
  }

  void _playLesson(ChapterItem item) {
    if (item.videoSource == 'youtube' && item.videoUrl != null) {
      final videoId = YoutubePlayer.convertUrlToId(item.videoUrl!);
      if (videoId != null) {
        if (_youtubeController != null) {
          _youtubeController!.load(videoId);
        } else {
          _youtubeController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
            ),
          );
        }
        setState(() {
          _currentLesson = item;
          _isPlaying = true;
        });
      }
    } else {
      // Handle other video sources or show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video format not supported yet')),
      );
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(learningProvider);
    final t = Theme.of(context);

    return Scaffold(
      appBar: CommonAppBar(
        title: state.data?.title ?? 'Course Details',
        showActions: false,
      ),
      body: state.isLoading && state.data == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          : state.error != null && state.data == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(learningProvider.notifier).getLearning(widget.slug),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : state.data == null
                  ? const Center(child: Text('No data found'))
                  : Column(
                      children: [
                        if (_isPlaying && _youtubeController != null)
                          YoutubePlayer(
                            controller: _youtubeController!,
                            showVideoProgressIndicator: true,
                          )
                        else
                          CachedNetworkImage(
                            imageUrl: ApiEndpoints.baseImageUrl + state.data!.thumbnail,
                            width: double.infinity,
                            height: 200.h,
                            fit: BoxFit.cover,
                          ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _currentLesson?.title ?? state.data!.title,
                                  style: t.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (state.data!.instructor != null)
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20.r,
                                        backgroundImage: CachedNetworkImageProvider(
                                          ApiEndpoints.baseImageUrl + state.data!.instructor!.image,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        state.data!.instructor!.name,
                                        style: t.textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Curriculum',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.data!.curriculums.length,
                                  itemBuilder: (context, index) {
                                    final curriculum = state.data!.curriculums[index];
                                    return ExpansionTile(
                                      initiallyExpanded: index == 0,
                                      title: Text(
                                        curriculum.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      children: curriculum.chapters.map((chapter) {
                                        final isCurrent = _currentLesson?.id == chapter.item?.id;
                                        return ListTile(
                                          selected: isCurrent,
                                          leading: Icon(
                                            chapter.type == 'live'
                                                ? Icons.live_tv
                                            : chapter.type == 'lecture' || chapter.type == 'lesson'
                                                ? Icons.play_circle_outline
                                                : Icons.quiz,
                                            color: isCurrent ? t.primaryColor : null,
                                          ),
                                          title: Text(
                                            chapter.item?.title ?? '',
                                            style: TextStyle(
                                              fontWeight: isCurrent ? FontWeight.bold : null,
                                            ),
                                          ),
                                          subtitle: chapter.item?.duration != null ? Text(chapter.item!.duration!) : null,
                                          onTap: () {
                                            if (chapter.item != null &&
                                                (chapter.type == 'lecture' || chapter.type == 'lesson')) {
                                              _playLesson(chapter.item!);
                                            }
                                          },
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }
}
