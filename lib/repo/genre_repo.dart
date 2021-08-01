import 'dart:convert';

import 'package:amd/models/movie_model.dart';
import 'package:amd/models/people_model.dart';
import 'package:amd/models/tv_model.dart';
import 'package:http/http.dart' as http;

class GenreRepo {
  var movieResultsCount;
  var showsResultsCount;
  Future<MovieModelList> getMovies(String id, int no) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&sort_by=popularity.desc&with_genres=$id&page=$no');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    movieResultsCount = data1['total_results'];

    return MovieModelList.fromJson(list);
  }

  Future<TvModelList> getTvShows(String id, int no) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/discover/tv?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&sort_by=popularity.desc&with_genres=$id&page=$no');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];

    showsResultsCount = data1['total_results'];

    return TvModelList.fromJson(list);
  }
}
