import 'dart:convert';

import 'package:amd/models/movie_model.dart';
import 'package:amd/models/people_model.dart';
import 'package:amd/models/tv_model.dart';
import 'package:http/http.dart' as http;

class SearchRepo {
  var movieResultsCount;
  var showsResultsCount;
  var peopleResultsCount;
  Future<MovieModelList> getMovies(String query, int page) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=84ebd14770d7675041b532f1d88ce324&query=$query&page=$page&include_adult=true');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    movieResultsCount = data1['total_results'];
    return MovieModelList.fromJson(list);
  }

  Future<TvModelList> getTvShows(String query, int page) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/search/tv?api_key=84ebd14770d7675041b532f1d88ce324&query=$query&page=$page&include_adult=true');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    showsResultsCount = data1['total_results'];
    return TvModelList.fromJson(list);
  }

  Future<PeopleModelList> getPeoples(String query, int page) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/search/person?api_key=84ebd14770d7675041b532f1d88ce324&query=$query&page=$page');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    peopleResultsCount = data1['total_results'];
    return PeopleModelList.fromJson(list);
  }

  Future<MovieModelList> getUpcomingMovies() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=84ebd14770d7675041b532f1d88ce324');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return MovieModelList.fromJson(list);
  }

  Future<TvModelList> getUpcomingTvShows() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/tv/on_the_air?api_key=84ebd14770d7675041b532f1d88ce324');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return TvModelList.fromJson(list);
  }
}
