import 'package:avicii_/notifier/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Music extends ConsumerStatefulWidget {
  const Music({super.key});

  @override
  _MusicState createState() => _MusicState();
}

class _MusicState extends ConsumerState<Music> {
  @override
  Widget build(BuildContext context) {
    final music = ref.watch(musicProvider);
    final notifier = ref.read(musicProvider.notifier);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scaleFactor = screenWidth / 380.0;
    final iconSize = 28.0 * scaleFactor;
    final playPauseIconSize = 32.0 * scaleFactor;
    final padding = EdgeInsets.symmetric(horizontal: screenWidth * 0.03);
    final imageHeight = screenHeight * 0.55; // Adjusted to 40% of screen height

    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));
      return "$minutes:$seconds";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: imageHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    music.musicImage[music.currentSongIndex],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10), // Adjusted spacing
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                children: [
                  Text(
                    music.songtitle[music.currentSongIndex],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24 * scaleFactor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    music.singer[music.currentSongIndex],
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18 * scaleFactor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // Adjusted spacing
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        formatDuration(music.position),
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 2,
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayShape: RoundSliderOverlayShape(
                              overlayRadius: 25,
                            ),
                            activeTrackColor: Colors.red,
                            inactiveTrackColor: Colors.grey,
                            thumbColor: Colors.white,
                            overlayColor: Colors.red.withOpacity(0.2),
                          ),
                          child: Slider(
                            value: music.position.inSeconds.toDouble(),
                            min: 0.0,
                            max: music.duration.inSeconds.toDouble(),
                            onChanged: (double value) {
                              notifier.seek(Duration(seconds: value.toInt()));
                            },
                          ),
                        ),
                      ),
                      Text(
                        formatDuration(music.duration),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // Adjusted spacing
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      notifier.toggleRepeat();
                    },
                    icon: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.repeat,
                          color: music.isRepeating ? Colors.red : Colors.white70,
                          size: iconSize,
                        ),
                        if (music.isRepeating)
                          Positioned(
                            top: 8.5,
                            right: 11,
                            child: Text(
                              '1',
                              style: TextStyle(
                                fontSize: 8 * scaleFactor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      notifier.previous();
                    },
                    icon: Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    onPressed: () {
                      if (music.isPlaying) {
                        notifier.pause();
                      } else {
                        notifier.play();
                      }
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: music.isPlaying
                          ? Icon(Icons.pause, size: playPauseIconSize)
                          : Icon(Icons.play_arrow, size: playPauseIconSize),
                    ),
                    shape: CircleBorder(),
                  ),
                  IconButton(
                    onPressed: () {
                      notifier.next();
                    },
                    icon: Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      notifier.toggleShuffle();
                    },
                    icon: Icon(
                      Icons.shuffle_sharp,
                      color: music.isShuffling ? Colors.red : Colors.white,
                      size: iconSize,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Ensure there's enough space at the bottom
          ],
        ),
      ),
    );
  }
}
