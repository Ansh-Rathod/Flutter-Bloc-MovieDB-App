import 'dart:convert';

import 'package:amd/models/tv_model.dart';

import '../models/cast_info.dart';
import '../models/movie_info_model.dart';
import '../models/movie_model.dart';
import 'package:http/http.dart' as http;

class CastMovies {
  Future<MovieModelList> getCastMoviesById(String id) async {
    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/person/$id/movie_credits?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data = json.decode(response6.body);
    return MovieModelList.fromJson(data['cast']);
  }

  Future<TvModelList> getCastTvById(String id) async {
    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/person/$id/tv_credits?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data = json.decode(response6.body);
    return TvModelList.fromJson(data['cast']);
  }

  Future<CastPersonalInfo> getCastInfoById(String id) async {
    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/person/$id?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data = json.decode(response6.body);
    return CastPersonalInfo.fromJson(data);
  }

  Future<ImageBackdropList> getImageBackdropList(String id) async {
    List<dynamic> dataimages = [];
    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/person/$id/images?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data6 = json.decode(response6.body);
    dataimages.addAll(data6['profiles']);
    return ImageBackdropList.fromJson(dataimages, [], []);
  }

  Future<SocialMediaInfo> getSocialMedia(String id) async {
    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/person/$id/external_ids?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data6 = json.decode(response6.body);
    return SocialMediaInfo.fromJson(data6);
  }
}
