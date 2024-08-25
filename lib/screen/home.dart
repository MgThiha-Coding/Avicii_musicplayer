import 'package:avicii_/notifier/notifier.dart';
import 'package:avicii_/screen/music.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayerWidget extends ConsumerWidget {
  const MusicPlayerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final music = ref.watch(musicProvider);
    final notifier = ref.watch(musicProvider.notifier);

    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    String formatDuration(Duration duration){
      String twoDigits(int n)=> n.toString().padLeft(2,'0');
      final seconds = twoDigits(duration.inSeconds.remainder(60));
      final minutes = twoDigits(duration.inSeconds.remainder(60));
      return "$seconds$minutes";
    }
    return Scaffold(
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          final musicprovider = ref.read(musicProvider.notifier);
          if (music.isPlaying) {
            musicprovider.pause();
          } else {
            musicprovider.play();
          }
        },
        child: AnimatedSwitcher(
          duration:
              const Duration(milliseconds: 10), // Adjust for desired speed
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: music.isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
        ),
        shape: CircleBorder(),
      ),
      appBar: AppBar(
      
        centerTitle: true,
        title: Image.asset(
          'assets/avicii.png',
          height: 100,
          width: 90,
        ),
        backgroundColor: Colors.black,
      ),
     
      body: ListView.builder(
        itemCount: music.playlist.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical:
                  isTablet ? 16 : 8, // Adjust padding based on screen size
              horizontal: isTablet ? 24 : 16,
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: isTablet
                    ? 40
                    : 24, // Adjust avatar size based on screen size
                backgroundImage: AssetImage(music.musicImage[index]),
              ),
              title: Text(
                music.songtitle[index],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet
                      ? 24
                      : 16, // Adjust font size based on screen size
                ),
              ),
              subtitle: Text(
                music.singer[index],
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: isTablet
                      ? 20
                      : 14, // Adjust font size based on screen size
                ),
              ),
              trailing: music.currentSongIndex == index
                  ? music.isPlaying
                      ? MusicWaveAnimation(isPlaying: music.isPlaying)
                      : Container(
                          width: 10.0,
                          height: 10.0,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        )
                  : null,
              onTap: () {
                notifier.seekTo(index);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Music()),
                );
              },
            ),
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}

class MusicWaveAnimation extends StatefulWidget {
  final bool isPlaying;

  const MusicWaveAnimation({Key? key, required this.isPlaying})
      : super(key: key);

  @override
  _MusicWaveAnimationState createState() => _MusicWaveAnimationState();
}

class _MusicWaveAnimationState extends State<MusicWaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _waveAnimation1;
  late Animation<double> _waveAnimation2;
  late Animation<double> _waveAnimation3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _waveAnimation1 = Tween<double>(begin: 0.0, end: 12.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _waveAnimation2 = Tween<double>(begin: 5.0, end: 15.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _waveAnimation3 = Tween<double>(begin: 10.0, end: 18.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant MusicWaveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isPlaying && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0.0; // Reset to the initial value
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _waveAnimation1,
          builder: (context, child) => Container(
            width: isTablet ? 8.0 : 4.0,
            height: _waveAnimation1.value,
            color: Colors.blue.withOpacity(0.8),
          ),
        ),
        const SizedBox(width: 2.0),
        AnimatedBuilder(
          animation: _waveAnimation2,
          builder: (context, child) => Container(
            width: isTablet ? 8.0 : 4.0,
            height: _waveAnimation2.value,
            color: Colors.blue.withOpacity(0.6),
          ),
        ),
        const SizedBox(width: 2.0),
        AnimatedBuilder(
          animation: _waveAnimation3,
          builder: (context, child) => Container(
            width: isTablet ? 8.0 : 4.0,
            height: _waveAnimation3.value,
            color: Colors.blue.withOpacity(0.4),
          ),
        ),
      ],
    );
  }
}
