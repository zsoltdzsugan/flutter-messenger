import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:messenger/core/enums/gif_provider.dart';
import 'package:messenger/core/models/gif.dart';

class GiphyService {
  static final _apiKeyWeb = dotenv.env['GIPHY_API_KEY_WEB']!;
  static final _apiKeyAndroid = dotenv.env['GIPHY_API_KEY_ANDROID']!;
  static const _gifBase = 'https://api.giphy.com/v1/gifs';
  static const _stickerBase = 'https://api.giphy.com/v1/stickers';
  static const _limit = 25;

  // ─────────────────────────────
  // GIFs
  // ─────────────────────────────

  Future<List<Gif>> trendingGifs() async {
    final res = await http.get(
      Uri.parse(
        '$_gifBase/trending'
        '?api_key=$_apiKeyWeb'
        '&limit=$_limit'
        '&rating=pg'
        '&lang=hu',
      ),
    );
    return _parse(res);
  }

  Future<List<Gif>> searchGifs(String query) async {
    final res = await http.get(
      Uri.parse(
        '$_gifBase/search'
        '?api_key=$_apiKeyWeb'
        '&q=$query'
        '&limit=$_limit'
        '&rating=pg'
        '&lang=hu',
      ),
    );
    return _parse(res);
  }

  // ─────────────────────────────
  // STICKERS
  // ─────────────────────────────

  Future<List<Gif>> trendingStickers() async {
    final res = await http.get(
      Uri.parse(
        '$_stickerBase/trending'
        '?api_key=$_apiKeyWeb'
        '&limit=$_limit'
        '&rating=pg'
        '&lang=hu',
      ),
    );
    return _parse(res, stickers: true);
  }

  Future<List<Gif>> searchStickers(String query) async {
    final res = await http.get(
      Uri.parse(
        '$_stickerBase/search'
        '?api_key=$_apiKeyWeb'
        '&q=$query'
        '&limit=$_limit'
        '&rating=pg'
        '&lang=hu',
      ),
    );
    return _parse(res, stickers: true);
  }

  // ─────────────────────────────
  // Parser
  // ─────────────────────────────

  List<Gif> _parse(http.Response res, {bool stickers = false}) {
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final List data = json['data'] ?? [];

    return data
        .map<Gif?>((e) {
          final images = e['images'];
          if (images == null) return null;

          // Stickers → transparent, lighter
          final animated = images['fixed_width'] ?? images['downsized_medium'];
          final preview = images['fixed_width_still'] ?? images['preview_gif'];

          if (animated == null) return null;

          return Gif(
            url: animated['url'],
            previewUrl: preview?['url'] ?? animated['url'],
            width: double.parse(animated['width']),
            height: double.parse(animated['height']),
            provider: GifProvider.giphy,
          );
        })
        .whereType<Gif>()
        .toList();
  }
}
