import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movieinfo/api/key.dart';

import '../models/movie_model.dart';
import '../models/tv_model.dart';

class FetchHomeRepo {
  Future<List<dynamic>> getHomePageMovies() async {
    MovieModelList trandingData;
    MovieModelList nowPlayeingData;
    MovieModelList topRatedData;
    MovieModelList upcomingData;
    TvModelList tvshowData;
    TvModelList topRatedTvData;

    final response = await http.get(
      Uri.parse(BASE_URL + '/home'),
    );
    if (response.statusCode == 200) {
      trandingData =
          MovieModelList.fromJson(json.decode(response.body)['trandingMovies']);
      nowPlayeingData = MovieModelList.fromJson(
          json.decode(response.body)['nowPlayingMovies']);
      topRatedData =
          MovieModelList.fromJson(json.decode(response.body)['topRatedMovies']);
      upcomingData =
          MovieModelList.fromJson(json.decode(response.body)['upcoming']);
      tvshowData =
          TvModelList.fromJson(json.decode(response.body)['trandingtv']);
      topRatedTvData =
          TvModelList.fromJson(json.decode(response.body)['topRatedTv']);
      return [
        trandingData.movies,
        nowPlayeingData.movies,
        topRatedData.movies,
        upcomingData.movies,
        tvshowData.movies,
        topRatedTvData.movies
      ];
    } else {
      throw Exception('Failed to load data');
    }
  }
}
