import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async'; // Import Timer

class VideoListPage extends StatefulWidget {
  const VideoListPage({super.key});

  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<String> videoUrls = [
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', // Example public URL
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4', // Example public URL
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4', // Example public URL
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          return VideoPlayerWidget(
            videoUrl: videoUrls[index],
            isActive: index == currentPage,
          );
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool isActive;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.isActive = false,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;
  bool _showControls = false;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _initializeVideoPlayerFuture = _controller
        .initialize()
        .then((_) {
          // Auto-play if active
          if (widget.isActive) {
            _controller.play();
            _controller.setLooping(true);
            setState(() {
              _isPlaying = true;
            });
          }
          if (mounted) {
            setState(() {}); // Update UI after initialization
          }
        })
        .catchError((error) {
          if (mounted) {
            setState(() {}); // Update UI even on error to show error state
          }
        });

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive && _controller.value.isInitialized) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {
          _isPlaying = true;
        });
      } else {
        _controller.pause();
        setState(() {
          _isPlaying = false;
        });
      }
    }
    // If the video URL changes, re-initialize the controller
    if (widget.videoUrl != oldWidget.videoUrl) {
      _controller.dispose(); // Dispose old controller
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      _initializeVideoPlayerFuture = _controller
          .initialize()
          .then((_) {
            if (widget.isActive) {
              _controller.play();
              _controller.setLooping(true);
              setState(() {
                _isPlaying = true;
              });
            }
            if (mounted) {
              setState(() {});
            }
          })
          .catchError((error) {
            if (mounted) {
              setState(() {});
            }
          });
      _controller.addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _controller.value.isPlaying;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _seekForward() {
    if (_controller.value.isInitialized) {
      final currentPosition = _controller.value.position;
      final newPosition = currentPosition + const Duration(seconds: 10);
      if (newPosition < _controller.value.duration) {
        _controller.seekTo(newPosition);
      } else {
        _controller.seekTo(_controller.value.duration);
      }
    }
  }

  void _seekBackward() {
    if (_controller.value.isInitialized) {
      final currentPosition = _controller.value.position;
      final newPosition = currentPosition - const Duration(seconds: 10);
      if (newPosition > Duration.zero) {
        _controller.seekTo(newPosition);
      } else {
        _controller.seekTo(Duration.zero);
      }
    }
  }

  void _toggleControls() {
    if (!_controller.value.isInitialized || _controller.value.hasError) {
      return;
    }
    setState(() {
      _showControls = !_showControls; // Toggle directly
    });
    _hideControlsTimer?.cancel();
    if (_showControls) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && _showControls) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleControls,
      child: Container(
        color: Colors.black, // Ensure container has a background color
        child: Center(
          // Center the content
          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  !_controller.value.hasError) {
                return AspectRatio(
                  aspectRatio:
                      _controller.value.aspectRatio > 0
                          ? _controller.value.aspectRatio
                          : 16 / 9, // Default aspect ratio if needed
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(_controller), // Correct usage
                      AnimatedOpacity(
                        opacity: _showControls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: AbsorbPointer(
                          absorbing: !_showControls,
                          child: _buildControlsOverlay(),
                        ),
                      ),
                      // Progress Indicator at the bottom
                      Positioned(
                        bottom: 8.0,
                        left: 8.0,
                        right: 8.0,
                        child: AnimatedOpacity(
                          opacity: _showControls ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: AbsorbPointer(
                            absorbing: !_showControls,
                            child: VideoProgressIndicator(
                              _controller, // Correct usage
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                // Correct usage
                                playedColor: Colors.red,
                                bufferedColor: Colors.grey,
                                backgroundColor: Colors.black54,
                              ),
                              padding:
                                  EdgeInsets.zero, // Adjust padding if needed
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError ||
                  (_controller.value.isInitialized &&
                      _controller.value.hasError)) {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Could not load video',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Error: ${snapshot.error ?? _controller.value.errorDescription}",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return Container(
      // Make controls background slightly darker for visibility
      color: Colors.black.withOpacity(_showControls ? 0.4 : 0.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.replay_10, color: Colors.white, size: 40),
              onPressed: _seekBackward,
            ),
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 60,
              ),
              onPressed: () {
                if (_controller.value.isInitialized) {
                  setState(() {
                    if (_isPlaying) {
                      _controller.pause();
                      _hideControlsTimer
                          ?.cancel(); // Keep controls visible when paused
                    } else {
                      _controller.play();
                      _toggleControls(); // Start hide timer on play
                    }
                    _isPlaying = !_isPlaying;
                  });
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.forward_10, color: Colors.white, size: 40),
              onPressed: _seekForward,
            ),
          ],
        ),
      ),
    );
  }
}
