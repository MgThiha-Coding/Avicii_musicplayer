import 'package:avicii_/notifier/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Music extends ConsumerWidget {
  const Music({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final music = ref.watch(musicProvider);
    final notifier = ref.watch(musicProvider.notifier);

    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));
      return "$minutes:$seconds";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Of Avicii'),
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
          children: [
            Container(
              height: 400,
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
            const SizedBox(height: 20),
            Column(
              children: [
                Text(
                  music.songtitle[music.currentSongIndex],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  music.singer[music.currentSongIndex],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: Text(
                    formatDuration(music.position),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2.0,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 25.0),
                      activeTrackColor: Colors.red,
                      inactiveTrackColor: Colors.grey,
                      thumbColor: Colors.white,
                      overlayColor: Colors.red.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: music.position.inSeconds
                          .clamp(0, music.duration.inSeconds)
                          .toDouble(),
                      min: 0.0,
                      max: music.duration.inSeconds > 0
                          ? music.duration.inSeconds.toDouble()
                          : 1.0, // Ensure max is never 0.0
                      onChanged: (double value) {
                        notifier.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: Text(
                    formatDuration(music.duration),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        color: music.isRepeating ? Colors.blue : Colors.white70,
                        size: 28,
                      ),
                      if (music.isRepeating)
                        Positioned(
                          top: 9,
                          right: 11,
                          child: Text(
                            '1',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 8,
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
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              
                   
               if ( music.isPlaying)
               IconButton(onPressed: (){
                  notifier.pause();
               }, icon: Icon(Icons.pause,size: 32,))
               else IconButton(onPressed: (){
                  notifier.play();
               }, icon: Icon(Icons.play_arrow,size: 32,)),
                    
                  
                
                IconButton(
                  onPressed: () {
                    notifier.next();
                  },
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    notifier.toggleShuffle();
                  },
                  icon: Icon(
                    Icons.shuffle,
                    color: music.isShuffling ? Colors.blue : Colors.white70,
                    size: 28,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
