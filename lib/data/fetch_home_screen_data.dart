import 'dart:math';

import 'package:dio/dio.dart';
import 'package:moviedb/models/error_model.dart';
import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/models/tv_model.dart';

class FetchHomeRepo {
  Future<List<dynamic>> getHomePageMovies() async {
    var http = Dio();
    var trandingurl =
        'https://api.themoviedb.org/3/trending/movie/day?api_key=84ebd14770d7675041b532f1d88ce324';
    var nowPlayingurl =
        'https://api.themoviedb.org/3/movie/now_playing?api_key=84ebd14770d7675041b532f1d88ce324';
    var topRatedurl =
        'https://api.themoviedb.org/3/movie/top_rated?api_key=84ebd14770d7675041b532f1d88ce324&page=${Random().nextInt(100)}';
    var tvshowurl =
        'https://api.themoviedb.org/3/trending/tv/day?api_key=84ebd14770d7675041b532f1d88ce324';
    var topRatedShowsurl =
        'https://api.themoviedb.org/3/tv/top_rated?api_key=84ebd14770d7675041b532f1d88ce324&page=${Random().nextInt(97)}';
    var upcomingMoviesUrl =
        'https://api.themoviedb.org/3/movie/upcoming?api_key=84ebd14770d7675041b532f1d88ce324';
    MovieModelList trandingData;
    MovieModelList nowPlayeingData;
    MovieModelList topRatedData;
    MovieModelList upcomingData;
    TvModelList tvshowData;
    TvModelList topRatedTvData;

    var responses = await Future.wait([
      http.get(trandingurl),
      http.get(nowPlayingurl),
      http.get(topRatedurl),
      http.get(tvshowurl),
      http.get(topRatedShowsurl),
      http.get(upcomingMoviesUrl),
    ]);
    if (responses[0].statusCode == 200) {
      trandingData = MovieModelList.fromJson(responses[0].data['results']);
    } else {
      throw FetchDataError('Error while fetching results');
    }
    if (responses[1].statusCode == 200) {
      nowPlayeingData = MovieModelList.fromJson(responses[1].data['results']);
    } else {
      throw FetchDataError('Error while fetching results');
    }
    if (responses[2].statusCode == 200) {
      topRatedData = MovieModelList.fromJson(responses[2].data['results']);
    } else {
      throw FetchDataError('Error while fetching results');
    }
    if (responses[5].statusCode == 200) {
      upcomingData = MovieModelList.fromJson(responses[5].data['results']);
    } else {
      throw FetchDataError('Error while fetching results');
    }
    if (responses[3].statusCode == 200) {
      tvshowData = TvModelList.fromJson(responses[3].data['results']);
    } else {
      throw FetchDataError('Error while fetching results');
    }
    if (responses[4].statusCode == 200) {
      topRatedTvData = TvModelList.fromJson(responses[4].data['results']);
    } else {
      throw FetchDataError('Error while fetching results');
    }

    return [
      trandingData.movies,
      nowPlayeingData.movies,
      topRatedData.movies,
      upcomingData.movies,
      tvshowData.movies,
      topRatedTvData.movies
    ];
  }
}
