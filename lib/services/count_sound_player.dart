import 'package:audioplayers/audioplayers.dart';

import '../models/app_settings.dart';

class CountSoundPlayer {
  CountSoundPlayer({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  final AudioPlayer _player;

  Future<void> play(CountButtonOption option) async {
    await _player.stop();
    await _player.play(AssetSource(option.soundAsset), volume: 1);
  }

  Future<void> dispose() => _player.dispose();
}
