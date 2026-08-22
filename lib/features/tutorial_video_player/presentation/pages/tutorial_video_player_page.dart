import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/models/tutorial_videos_model.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/core/utils/video_url_helper.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/core/widgets/app_text.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class TutorialVideoPlayerPage extends StatelessWidget {
  const TutorialVideoPlayerPage({super.key, required this.video});

  final TutorialVideosModel video;

  @override
  Widget build(BuildContext context) {
    final playbackType = VideoUrlHelper.playbackType(video.videoUrl);

    return AppScaffold(
      title: video.title ?? 'tutorial_videos',
      padding: EdgeInsets.zero,
      body: switch (playbackType) {
        TutorialVideoPlaybackType.youtube => _YoutubeTutorialPlayer(
          videoId: VideoUrlHelper.youtubeVideoId(video.videoUrl)!,
        ),
        TutorialVideoPlaybackType.directVideo => _DirectTutorialVideoPlayer(
          videoUrl: VideoUrlHelper.normalize(video.videoUrl)!,
        ),
        TutorialVideoPlaybackType.webPage => _TutorialVideoWebView(
          videoUrl: VideoUrlHelper.normalize(video.videoUrl)!,
        ),
        TutorialVideoPlaybackType.invalid => const _UnsupportedVideo(),
      },
    );
  }
}

class _YoutubeTutorialPlayer extends StatefulWidget {
  const _YoutubeTutorialPlayer({required this.videoId});

  final String videoId;

  @override
  State<_YoutubeTutorialPlayer> createState() => _YoutubeTutorialPlayerState();
}

class _YoutubeTutorialPlayerState extends State<_YoutubeTutorialPlayer> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
    );
  }
}

class _DirectTutorialVideoPlayer extends StatefulWidget {
  const _DirectTutorialVideoPlayer({required this.videoUrl});

  final Uri videoUrl;

  @override
  State<_DirectTutorialVideoPlayer> createState() =>
      _DirectTutorialVideoPlayerState();
}

class _DirectTutorialVideoPlayerState
    extends State<_DirectTutorialVideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final videoController = VideoPlayerController.networkUrl(widget.videoUrl);
      _videoController = videoController;
      await videoController.initialize();

      if (!mounted) return;

      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: videoController,
          autoPlay: true,
          allowFullScreen: true,
          allowMuting: true,
          showControls: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: context.theme.colorScheme.primary,
            handleColor: context.theme.colorScheme.primary,
            bufferedColor: context.theme.colorScheme.primary.withValues(
              alpha: 0.28,
            ),
          ),
        );
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chewieController = _chewieController;

    if (_error != null) {
      return const _UnsupportedVideo();
    }

    if (chewieController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(child: Chewie(controller: chewieController));
  }
}

class _TutorialVideoWebView extends StatefulWidget {
  const _TutorialVideoWebView({required this.videoUrl});

  final Uri videoUrl;

  @override
  State<_TutorialVideoWebView> createState() => _TutorialVideoWebViewState();
}

class _TutorialVideoWebViewState extends State<_TutorialVideoWebView> {
  late final WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) {
              setState(() => _progress = progress);
            }
          },
        ),
      )
      ..loadRequest(widget.videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_progress < 100)
          LinearProgressIndicator(
            value: _progress == 0 ? null : _progress / 100,
          ),
      ],
    );
  }
}

class _UnsupportedVideo extends StatelessWidget {
  const _UnsupportedVideo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: AppText(
          'video_link_not_available',
          color: context.appColors.subtitle,
          fontSize: 16.sp,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
