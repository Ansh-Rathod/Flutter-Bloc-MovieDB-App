import 'dart:math';

import '../models/movie_info_model.dart';
import '../models/tv_shows_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/tv_model.dart';

class TVRepo {
  Future<TvModelList> getTvShows() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/trending/tv/day?api_key=84ebd14770d7675041b532f1d88ce324');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return TvModelList.fromJson(list);
  }

  Future<TvModelList> getPopularTvShows() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/tv/popular?api_key=84ebd14770d7675041b532f1d88ce324&page=${Random().nextInt(30)}');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return TvModelList.fromJson(list);
  }

  Future<TvModelList> getTopRatedTvShows() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/tv/top_rated?api_key=84ebd14770d7675041b532f1d88ce324&page=${Random().nextInt(97)}');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return TvModelList.fromJson(list);
  }

  Future<TvModelList> getSimilarShows(String id) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/tv/$id/similar?api_key=84ebd14770d7675041b532f1d88ce324');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return TvModelList.fromJson(list);
  }

  Future<TvInfoModel> getTvDataById(String id) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/tv/$id?api_key=84ebd14770d7675041b532f1d88ce324');
    final response = await http.get(url);
    final data = json.decode(response.body);
    return TvInfoModel.fromJson(data);
  }

  Future<TrailerList> getTvShowTrailerById(String id) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/tv/$id/videos?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US');
    final response = await http.get(url);
    final data = json.decode(response.body);
    return TrailerList.fromJson(data);
  }

  Future<ImageBackdropList> getTvImagesById(String id) async {
    List<dynamic> backdrops = [];
    List<dynamic> posters = [];
    List<dynamic> logos = [];
    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/tv/$id/images?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data6 = json.decode(response6.body);
    backdrops.addAll(data6['backdrops']);
    logos.addAll(data6['logos']);
    posters.addAll(data6['posters']);
    return ImageBackdropList.fromJson(backdrops, posters, logos);
  }

  Future<CastInfoList> getTvCastById(String id) async {
    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/tv/$id/credits?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data = json.decode(response6.body);
    return CastInfoList.fromJson(data);
  }
}
