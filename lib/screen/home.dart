
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

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: Text(
          "Best of Avicii",
          style: TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: music.playlist.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(music.musicImage[index]),
            ),
            title: Text(
              music.songtitle[index],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              music.singer[index],
              style: TextStyle(
                color: Colors.orangeAccent,
              ),
            ),
            trailing: music.currentSongIndex == index
                ? MusicWaveAnimation(isPlaying: music.isPlaying)
                : null,
            onTap: () {
              notifier.seekTo(index);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Music()),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
class MusicWaveAnimation extends StatefulWidget {
  final bool isPlaying;

  const MusicWaveAnimation({Key? key, required this.isPlaying}) : super(key: key);

  @override
  _MusicWaveAnimationState createState() => _MusicWaveAnimationState();
}

class _MusicWaveAnimationState extends State<MusicWaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 4.0, end: 12.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant MusicWaveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isPlaying && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 4.0; // Reset to the initial value
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: 4.0,
                height: _animation.value - (index * 2.0),
                color: Colors.blue,
              );
            },
          ),
        );
      }),
    );
  }
}
