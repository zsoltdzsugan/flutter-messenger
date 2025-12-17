import 'package:messenger/core/enums/devices.dart';
import 'package:messenger/core/enums/gif_provider.dart';
import 'package:messenger/core/models/gif.dart';
import 'package:messenger/core/services/giphy.dart';
import 'package:messenger/core/services/tenor.dart';

class GifController {
  final _giphy = GiphyService();
  final _tenor = TenorService();

  Future<List<Gif>> trending(
    GifProvider provider, {
    required DeviceType device,
  }) {
    switch (provider) {
      case GifProvider.giphy:
        return _giphy.trendingGifs();
      case GifProvider.tenor:
        return _tenor.trending(device: device);
      default:
        return _tenor.trending(device: device);
    }
  }

  Future<List<Gif>> search(
    GifProvider provider, {
    required String query,
    required DeviceType device,
  }) {
    switch (provider) {
      case GifProvider.giphy:
        return _giphy.searchGifs(query);
      case GifProvider.tenor:
        return _tenor.search(query, device: device);
      default:
        return _tenor.search(query, device: device);
    }
  }

  Future<List<Gif>> trendingStickers() {
    return _giphy.trendingStickers();
  }

  Future<List<Gif>> searchStickers(String query) {
    return _giphy.searchStickers(query);
  }
}
