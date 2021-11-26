import 'package:dio/dio.dart';
import 'package:moviedb/models/error_model.dart';
import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/screens/movie_info_screen/movie_Info_screen.dart';

class FetchMovieDataById {
  Future<List<dynamic>> getDetails(String id) async {
    var http = Dio();

    var moviedataByIdurl =
        'https://api.themoviedb.org/3/movie/$id?api_key=84ebd14770d7675041b532f1d88ce324';
    var trailersUrl =
        'https://api.themoviedb.org/3/movie/$id/videos?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US';
    var movieBackdropsUrl =
        'https://api.themoviedb.org/3/movie/$id/images?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en';
    var movecastUrl =
        'https://api.themoviedb.org/3/movie/$id/credits?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en';
    var omdburl = 'http://www.omdbapi.com/?i=$id&apikey=114165f2';
    var smiliarmovieUrl =
        'https://api.themoviedb.org/3/movie/$id/similar?api_key=84ebd14770d7675041b532f1d88ce324';
    MovieInfoModel movieData;
    MovieInfoImdb omdbData;
    TrailerList trailersData;
    ImageBackdropList backdropsData;
    CastInfoList castData;
    MovieModelList similarData;
    var responses = await Future.wait([
      http.get(moviedataByIdurl),
      http.get(trailersUrl),
      http.get(movieBackdropsUrl),
      http.get(movecastUrl),
      http.get(smiliarmovieUrl),
    ]);
    if (responses[0].statusCode == 200) {
      movieData = MovieInfoModel.fromJson(responses[0].data);
    } else {
      throw FetchDataError('Error Fetching data');
    }
    var imdbId = movieData.imdbid;

    final omdbResponse =
        await http.get('http://www.omdbapi.com/?i=$imdbId&apikey=114165f2');
    if (omdbResponse.statusCode == 200) {
      omdbData = MovieInfoImdb.fromJson(omdbResponse.data);
    } else {
      throw FetchDataError('Error Fetching data');
    }
    if (responses[1].statusCode == 200) {
      trailersData = TrailerList.fromJson(responses[1].data);
    } else {
      throw FetchDataError('Error Fetching data');
    }
    if (responses[2].statusCode == 200) {
      backdropsData =
          ImageBackdropList.fromJson(responses[2].data['backdrops']);
    } else {
      throw FetchDataError('Error Fetching data');
    }
    if (responses[3].statusCode == 200) {
      castData = CastInfoList.fromJson(responses[3].data);
    } else {
      throw FetchDataError('Error Fetching data');
    }
    if (responses[4].statusCode == 200) {
      similarData = MovieModelList.fromJson(responses[4].data['results']);
    } else {
      throw FetchDataError('Error Fetching data');
    }

    return [
      movieData,
      trailersData.trailers,
      backdropsData.backdrops,
      castData.castList,
      omdbData,
      similarData.movies,
    ];
  }
}
