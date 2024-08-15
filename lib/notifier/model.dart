
class MusicPlayer {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final List<String> playlist;
  final List<String> songtitle;
  final List<String> singer;
  final List<String> musicImage;
  final int currentSongIndex;
  final bool isShuffling;
  final bool isRepeating;
  

  MusicPlayer({
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.playlist,
    required this.songtitle,
    required this.singer,
    required this.musicImage,
    required this.currentSongIndex,
    this.isShuffling = false,
    this.isRepeating = false,
  });

  MusicPlayer copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    List<String>? playlist,
    List<String>? songtitle,
    List<String>? singer,
    List<String>? musicImage,
    int? currentSongIndex,
    bool? isShuffling,
    bool? isRepeating,
  }) {
    return MusicPlayer(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      playlist: playlist ?? this.playlist,
      songtitle: songtitle ?? this.songtitle,
      singer: singer ?? this.singer,
      musicImage: musicImage?? this.musicImage,
      currentSongIndex: currentSongIndex ?? this.currentSongIndex,
      isShuffling: isShuffling ?? this.isShuffling,
      isRepeating: isRepeating ?? this.isRepeating,
    );
  }
}
