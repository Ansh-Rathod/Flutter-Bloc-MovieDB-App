import 'package:dio/dio.dart';
import 'package:moviedb/models/error_model.dart';
import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/models/tv_model.dart';

class FetchTvShowDetail {
  Future<List<dynamic>> getTvDetails(String id) async {
    var http = Dio();
    var dataUrl =
        'https://api.themoviedb.org/3/tv/$id?api_key=84ebd14770d7675041b532f1d88ce324';
    var trailersurl =
        'https://api.themoviedb.org/3/tv/$id/videos?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US';
    var imagesurl =
        'https://api.themoviedb.org/3/tv/$id/images?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en';
    var casturl =
        'https://api.themoviedb.org/3/tv/$id/credits?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en';
    var similarurl =
        'https://api.themoviedb.org/3/tv/$id/similar?api_key=84ebd14770d7675041b532f1d88ce324';

    TvInfoModel info;
    TrailerList trailerList;
    ImageBackdropList backdropList;
    CastInfoList castInfoList;
    TvModelList similarshows;
    var res = await Future.wait([
      http.get(dataUrl),
      http.get(trailersurl),
      http.get(imagesurl),
      http.get(casturl),
      http.get(similarurl)
    ]);
    if (res[0].statusCode == 200) {
      info = TvInfoModel.fromJson(res[0].data);
    } else {
      throw FetchDataError('Error while fetching data');
    }
    if (res[1].statusCode == 200) {
      trailerList = TrailerList.fromJson(res[1].data);
    } else {
      throw FetchDataError('Error while fetching data');
    }
    if (res[2].statusCode == 200) {
      backdropList = ImageBackdropList.fromJson(res[2].data['backdrops']);
    } else {
      throw FetchDataError('Error while fetching data');
    }
    if (res[3].statusCode == 200) {
      castInfoList = CastInfoList.fromJson(res[3].data);
    } else {
      throw FetchDataError('Error while fetching data');
    }
    if (res[4].statusCode == 200) {
      similarshows = TvModelList.fromJson(res[4].data['results']);
    } else {
      throw FetchDataError('Error while fetching data');
    }

    return [
      info,
      trailerList.trailers,
      backdropList.backdrops,
      castInfoList.castList,
      similarshows.movies,
    ];
  }
}
