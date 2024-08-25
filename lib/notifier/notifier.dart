import 'dart:math';
import 'package:avicii_/notifier/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerNotifier extends StateNotifier<MusicPlayer> {
  final AudioPlayer player = AudioPlayer();

  MusicPlayerNotifier({
    required List<String> playlist,
    required List<String> songtitle,
    required List<String> singer,
    required List<String> musicImage,
  }) : super(MusicPlayer(
          isPlaying: false,
          position: Duration.zero,
          duration: Duration.zero,
          playlist: playlist,
          songtitle: songtitle,
          singer: singer,
          musicImage: musicImage,
          currentSongIndex: 0,
        )) {
    _initializePlayer();
    load(playlist[0]);
  }

  void _initializePlayer() {
    player.positionStream.listen((position) {
      if (player.playing) {
        state = state.copyWith(position: position);
      }
    });

    player.durationStream.listen((duration) {
      state = state.copyWith(duration: duration ?? Duration.zero);
    });

    player.processingStateStream.listen((processingState) {
      if (processingState == ProcessingState.completed) {
        _onTrackCompleted();
      }
    });
  }

  Future<void> _onTrackCompleted() async {
    if (state.isRepeating) {
      await seek(Duration.zero);
      play();
    } else {
      next();
    }
  }

  Future<void> load(String assetPath) async {
    await player.setAsset(assetPath);
    final duration = player.duration ?? Duration.zero;
    state = state.copyWith(position: Duration.zero, duration: duration);
  }

  void play() {
    player.play();
    state = state.copyWith(isPlaying: true);
  }

  void pause() {
    player.pause();
    state = state.copyWith(isPlaying: false);
  }

  Future<void> next() async {
    final nextIndex = state.isShuffling
        ? Random().nextInt(state.playlist.length)
        : (state.currentSongIndex + 1) % state.playlist.length;
    state = state.copyWith(currentSongIndex: nextIndex);
    await load(state.playlist[nextIndex]);
    play();
  }

  Future<void> previous() async {
    final previousIndex = state.currentSongIndex > 0
        ? state.currentSongIndex - 1
        : state.playlist.length - 1;
    state = state.copyWith(currentSongIndex: previousIndex);
    await load(state.playlist[previousIndex]);
    play();
  }

  Future<void> seek(Duration position) async {
    await player.seek(position);
    state = state.copyWith(position: position);
  }
  Future<void> seekTo(int index) async {
  if (index >= 0 && index < state.playlist.length) {
   
    state = state.copyWith(currentSongIndex: index);
    final currentPosition = state.position;
    await load(state.playlist[index]);
    state = state.copyWith(position: currentPosition);
    play();
  }
}

  void toggleShuffle() {
    state = state.copyWith(isShuffling: !state.isShuffling);
  }

  void toggleRepeat() {
    state = state.copyWith(isRepeating: !state.isRepeating);
  }
}

final musicProvider =
    StateNotifierProvider<MusicPlayerNotifier, MusicPlayer>((ref) {
  return MusicPlayerNotifier(
    playlist: [
      'assets/song1.mp3',
      'assets/song2.mp3',
      'assets/song3.mp3',
      'assets/song4.mp3',
      'assets/song5.mp3',
      'assets/song6.mp3',
      'assets/song7.mp3',
      'assets/song8.mp3',
      'assets/song9.mp3',
      'assets/song10.mp3',
      'assets/song11.mp3',
      'assets/song12.mp3',
    ],
    songtitle: [
      'Wake Me Up',
      'Levels',
      'Hey Brother',
      'The Nights',
      'Waiting For Love',
      'Without You',
      'Lonely Together',
      'You Make Me',
      'Silhouettes',
      'I Could Be The One',
      'Addicted To You',
      'Broken Arrow',
    ],
    singer: [
      "Avicii, Aloe Blacc",
      "Avicii",
      "Avicii",
      "Avicii",
      "Avicii",
      "Avicii, Sandro Cavazza",
      "Avicii, Rita Ora",
      "Avicii",
      "Avicii",
      "Avicii, Nicky Romero",
      "Avicii, Audra Mae",
      "Avicii, Alex Ebert",
    ],
    musicImage: [
      'assets/album/image1.jpg',
      'assets/album/image2.jpg',
      'assets/album/image3.jpg',
      'assets/album/image4.jpg',
      'assets/album/image5.jpg',
      'assets/album/image6.jpg',
      'assets/album/image7.jpg',
      'assets/album/image8.jpg',
      'assets/album/image9.jpg',
      'assets/album/image10.jpg',
      'assets/album/image11.jpg',
      'assets/album/image12.jpg',
    ],
  );
});
