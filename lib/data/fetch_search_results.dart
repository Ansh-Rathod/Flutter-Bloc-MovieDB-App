import 'package:dio/dio.dart';
import 'package:moviedb/models/error_model.dart';
import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/models/people_model.dart';
import 'package:moviedb/models/tv_model.dart';

class SearchResultsRepo {
  var movieResultsCount;
  var showsResultsCount;
  var peopleResultsCount;
  var http = Dio();
  Future<List<dynamic>> getAllResults(String query, int page) async {
    var movieUrl =
        'https://api.themoviedb.org/3/search/movie?api_key=84ebd14770d7675041b532f1d88ce324&query=$query&page=$page&include_adult=true';
    var tvUrl =
        'https://api.themoviedb.org/3/search/tv?api_key=84ebd14770d7675041b532f1d88ce324&query=$query&page=$page&include_adult=true';
    var peopleUrl =
        'https://api.themoviedb.org/3/search/person?api_key=84ebd14770d7675041b532f1d88ce324&query=$query&page=$page';
    MovieModelList movies;
    PeopleModelList people;
    TvModelList tv;
    var res = await Future.wait([
      http.get(movieUrl),
      http.get(peopleUrl),
      http.get(tvUrl),
    ]);
    if (res[0].statusCode == 200) {
      movies = MovieModelList.fromJson(res[0].data['results']);
      movieResultsCount = res[0].data['total_results'];
    } else {
      throw FetchDataError("Something went wrong!");
    }
    if (res[1].statusCode == 200) {
      people = PeopleModelList.fromJson(res[1].data['results']);
      peopleResultsCount = res[1].data['total_results'];
    } else {
      throw FetchDataError("Something went wrong!");
    }
    if (res[2].statusCode == 200) {
      tv = TvModelList.fromJson(res[2].data['results']);
      showsResultsCount = res[2].data['total_results'];
    } else {
      throw FetchDataError("Something went wrong!");
    }
    return [
      movies.movies,
      tv.movies,
      people.peoples,
    ];
  }
}
