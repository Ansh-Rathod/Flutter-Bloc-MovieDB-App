import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api/key.dart';
import '../models/error_model.dart';
import '../models/movie_model.dart';
import '../models/season_details_model.dart';

class FetchSeasonInfo {
  Future<List<dynamic>> getSeasonDetail(String id, String snum) async {
    SeasonModel seasonInfo;
    CastInfoList castList;
    TrailerList trailerList;
    ImageBackdropList backdropList;

    var res = await http.get(Uri.parse('$BASE_URL/tv/$id/season/$snum'));

    if (res.statusCode == 200) {
      seasonInfo = SeasonModel.fromJson(jsonDecode(res.body)['data']);
      castList = CastInfoList.fromJson(jsonDecode(res.body)['credits']);
      trailerList = TrailerList.fromJson(jsonDecode(res.body)['videos']);
      backdropList =
          ImageBackdropList.fromJson(jsonDecode(res.body)['images']['posters']);
      return [
        seasonInfo,
        castList.castList,
        trailerList.trailers,
        backdropList.backdrops,
      ];
    } else {
      throw FetchDataError('Something Went wrong!');
    }
  }
}
