import 'package:dio/dio.dart';
import 'package:moviedb/models/error_model.dart';
import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/models/season_details_model.dart';

class FetchSeasonInfo {
  Future<List<dynamic>> getSeasonDetail(String id, String snum) async {
    print("$id, $snum");
    var http = Dio();

    var seasonInfoUrl =
        'https://api.themoviedb.org/3/tv/$id/season/$snum?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en';
    var seasonCastUrl =
        'https://api.themoviedb.org/3/tv/$id/season/$snum/credits?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en';
    var seasonTrailerUrl =
        'https://api.themoviedb.org/3/tv/$id/season/$snum/videos?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US';
    var seasonImageUrl =
        'https://api.themoviedb.org/3/tv/$id/season/$snum/images?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en';

    SeasonModel seasonInfo;
    CastInfoList castList;
    TrailerList trailerList;
    ImageBackdropList backdropList;

    var res = await Future.wait([
      http.get(seasonInfoUrl),
      http.get(seasonCastUrl),
      http.get(seasonTrailerUrl),
      http.get(seasonImageUrl),
    ]);

    if (res[0].statusCode == 200) {
      seasonInfo = SeasonModel.fromJson(res[0].data);
    } else {
      throw FetchDataError('Something Went wrong!');
    }
    if (res[1].statusCode == 200) {
      castList = CastInfoList.fromJson(res[1].data);
    } else {
      throw FetchDataError('Something Went wrong!');
    }
    if (res[2].statusCode == 200) {
      trailerList = TrailerList.fromJson(res[2].data);
    } else {
      throw FetchDataError('Something Went wrong!');
    }
    if (res[3].statusCode == 200) {
      backdropList = ImageBackdropList.fromJson(res[3].data['posters']);
    } else {
      throw FetchDataError('Something Went wrong!');
    }

    return [
      seasonInfo,
      castList.castList,
      trailerList.trailers,
      backdropList.backdrops,
    ];
  }
}
