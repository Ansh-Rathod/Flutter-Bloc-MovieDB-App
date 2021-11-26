import 'package:dio/dio.dart';
import 'package:moviedb/models/cast_info_model.dart';
import 'package:moviedb/models/error_model.dart';
import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/models/tv_model.dart';

class FetchCastInfoById {
  Future<List<dynamic>> getCastDetails(String id) async {
    var http = Dio();
    String castpersonalinfo =
        "https://api.themoviedb.org/3/person/$id?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en";
    String socialMediaInfo =
        "https://api.themoviedb.org/3/person/$id/external_ids?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en";
    String images =
        "https://api.themoviedb.org/3/person/$id/images?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en";
    String casttv =
        "https://api.themoviedb.org/3/person/$id/tv_credits?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en";
    String castMovie =
        "https://api.themoviedb.org/3/person/$id/movie_credits?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en";
    CastPersonalInfo prinfo;
    SocialMediaInfo socialMedia;
    ImageBackdropList backdrops;
    MovieModelList movies;
    TvModelList tv;
    var responses = await Future.wait([
      http.get(castpersonalinfo),
      http.get(socialMediaInfo),
      http.get(images),
      http.get(casttv),
      http.get(castMovie),
    ]);

    if (responses[0].statusCode == 200) {
      prinfo = CastPersonalInfo.fromJson(responses[0].data);
    } else {
      throw FetchDataError('Error while fetching results');
    }

    if (responses[1].statusCode == 200) {
      socialMedia = SocialMediaInfo.fromJson(responses[1].data);
    } else {
      throw FetchDataError('Error while fetching results');
    }
    if (responses[2].statusCode == 200) {
      backdrops = ImageBackdropList.fromJson(responses[2].data['profiles']);
    } else {
      throw FetchDataError('Error while fetching results');
    }
    if (responses[4].statusCode == 200) {
      movies = MovieModelList.fromJson(responses[4].data['cast']);
      print(responses[4].data['cast']);
    } else {
      throw FetchDataError('Error while fetching results');
    }
    if (responses[3].statusCode == 200) {
      tv = TvModelList.fromJson(responses[3].data['cast']);
    } else {
      throw FetchDataError('Error while fetching results');
    }

    return [
      prinfo,
      socialMedia,
      backdrops.backdrops,
      movies.movies,
      tv.movies,
    ];
  }
}
