import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:messenger/core/enums/devices.dart';
import 'package:messenger/core/enums/gif_provider.dart';
import 'package:messenger/core/models/gif.dart';

class TenorService {
  static final _apiKey = dotenv.env['TENOR_API_KEY']!;
  static const _baseUrl = 'https://tenor.googleapis.com/v2';
  static const _limit = 25;
  static const _locale = 'hu';

  Future<List<Gif>> trending({required DeviceType device}) async {
    final res = await http.get(
      Uri.parse(
        '$_baseUrl/featured'
        '?key=$_apiKey'
        '&limit=$_limit'
        '&media_filter=basic'
        '&locale=$_locale',
      ),
    );

    return _parse(res, device);
  }

  Future<List<Gif>> search(String query, {required DeviceType device}) async {
    final res = await http.get(
      Uri.parse(
        '$_baseUrl/search'
        '?q=$query'
        '&key=$_apiKey'
        '&limit=$_limit'
        '&media_filter=basic'
        '&locale=$_locale',
      ),
    );

    return _parse(res, device);
  }

  List<Gif> _parse(http.Response res, DeviceType device) {
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final List results = json['results'] ?? [];

    print(results.length);
    print(results.first['media_formats'].keys);

    return results
        .map<Gif?>((e) {
          final media = e['media_formats'];
          if (media == null) return null;

          final preview =
              media['gifpreview'] ??
              media['tinygifpreview'] ??
              media['nanogif'];

          final animated =
              (device == DeviceType.desktop || device == DeviceType.tablet)
              ? media['mediumgif'] ?? media['tinygif']
              : media['nanogif'] ?? media['tinygif'];

          if (preview == null || animated == null) return null;

          return Gif(
            previewUrl: preview['url'],
            url: animated['url'],
            width: (animated['dims'][0] as num).toDouble(),
            height: (animated['dims'][1] as num).toDouble(),
            provider: GifProvider.tenor,
          );
        })
        .whereType<Gif>()
        .toList();
  }
}
