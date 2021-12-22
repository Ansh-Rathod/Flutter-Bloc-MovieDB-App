import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../api/key.dart';
import '../models/error_model.dart';
import '../models/movie_model.dart';

class FetchMovieDataById {
  Future<List<dynamic>> getDetails(String id) async {
    MovieInfoModel movieData;
    MovieInfoImdb omdbData;
    TrailerList trailersData;
    ImageBackdropList backdropsData;
    CastInfoList castData;
    MovieModelList similarData;
    var images = [];
    var box = Hive.box('Movies');
    var string = json.encode(box.get(id));
    var movie = json.decode(string);
    if (movie == null) {
      var response = await http.get(Uri.parse('$BASE_URL/movie/$id'));
      if (response.statusCode == 200) {
        movie = jsonDecode(response.body);
        await box.put(id, jsonDecode(response.body));
      } else {
        throw FetchDataError('Something went wrong');
      }
    }

    movieData = MovieInfoModel.fromJson(movie['data']);
    trailersData = TrailerList.fromJson(movie['videos']);
    images.addAll(movie['images']['backdrops']);
    images.addAll(movie['images']['posters']);
    images.addAll(movie['images']['logos']);

    backdropsData = ImageBackdropList.fromJson(images);

    castData = CastInfoList.fromJson(movie['credits']);
    similarData = MovieModelList.fromJson(movie['similar']['results']);

    var imdbId = movieData.imdbid;
    final omdbResponse =
        await http.get(Uri.parse('$BASE_URL/movie/omdb/' + imdbId.toString()));
    if (omdbResponse.statusCode == 200) {
      omdbData = MovieInfoImdb.fromJson(jsonDecode(omdbResponse.body)['data']);
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
