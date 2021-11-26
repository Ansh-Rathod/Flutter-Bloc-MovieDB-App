import 'package:dio/dio.dart';
import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/models/people_model.dart';
import 'package:moviedb/models/tv_model.dart';

class GenreRepo {
  var movieResultsCount;
  var showsResultsCount;
  var http = Dio();
  Future<MovieModelList> getMovies(String id, int no) async {
    final res = await http.get(
        'https://api.themoviedb.org/3/discover/movie?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&sort_by=popularity.desc&with_genres=$id&page=$no');
    var data = res.data;
    List<dynamic> list = data['results'];
    movieResultsCount = data['total_results'];

    return MovieModelList.fromJson(list);
  }

  Future<TvModelList> getTvShows(String id, int no) async {
    var res = await http.get(
        'https://api.themoviedb.org/3/discover/tv?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&sort_by=popularity.desc&with_genres=$id&page=$no');
    var data = res.data;

    List<dynamic> list = data['results'];

    showsResultsCount = data['total_results'];

    return TvModelList.fromJson(list);
  }
}

class SearchRepo {
  var movieResultsCount;
  var showsResultsCount;
  var peopleResultsCount;
  var http = Dio();
  Future<MovieModelList> getMovies(String query, int page) async {
    var res = await http.get(
        'https://api.themoviedb.org/3/search/movie?api_key=84ebd14770d7675041b532f1d88ce324&query=$query&page=$page&include_adult=true');
    var data = res.data;

    List<dynamic> list = data['results'];
    movieResultsCount = data['total_results'];
    return MovieModelList.fromJson(list);
  }

  Future<TvModelList> getTvShows(String query, int page) async {
    var url = await http.get(
        'https://api.themoviedb.org/3/search/tv?api_key=84ebd14770d7675041b532f1d88ce324&query=$query&page=$page&include_adult=true');
    var data1 = url.data;
    List<dynamic> list = data1['results'];
    showsResultsCount = data1['total_results'];
    return TvModelList.fromJson(list);
  }

  Future<PeopleModelList> getPeoples(String query, int page) async {
    var url = await http.get(
        'https://api.themoviedb.org/3/search/person?api_key=84ebd14770d7675041b532f1d88ce324&query=$query&page=$page');
    var data1 = url.data;
    List<dynamic> list = data1['results'];
    showsResultsCount = data1['total_results'];
    return PeopleModelList.fromJson(list);
  }
}
