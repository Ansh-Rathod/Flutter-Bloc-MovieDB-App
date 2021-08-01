import 'dart:convert';
import 'dart:math';
import '../models/movie_info_model.dart';
import '../models/movie_model.dart';
import '../models/tv_model.dart';
import '../screeens/info_pages/movies_info/movies_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';

class ColorGenrator {
  Future<Color> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor!.color;
  }

  Color calculateTextColor(Color background) {
    return background.computeLuminance() >= 0.4 ? Colors.black : Colors.white;
  }
}

class MoviesRepo {
  Future<MovieModelList> getMovies() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/trending/movie/day?api_key=84ebd14770d7675041b532f1d88ce324');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return MovieModelList.fromJson(list);
  }

  Future<MovieModelList> getNowPlayingMovies() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=84ebd14770d7675041b532f1d88ce324');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return MovieModelList.fromJson(list);
  }

  Future<MovieModelList> getTopRatedMovies() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=84ebd14770d7675041b532f1d88ce324&page=${Random().nextInt(100)}');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return MovieModelList.fromJson(list);
  }

  Future<MovieModelList> getSimilarMovies(String id) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/similar?api_key=84ebd14770d7675041b532f1d88ce324');
    final response = await http.get(url);
    final data1 = json.decode(response.body);
    List<dynamic> list = data1['results'];
    return MovieModelList.fromJson(list);
  }

  Future<MovieInfoModel> getMovieDataById(String id) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id?api_key=84ebd14770d7675041b532f1d88ce324');
    final response = await http.get(url);
    final data = json.decode(response.body);
    final imdb_id = data['imdb_id'];
    return MovieInfoModel.fromJson(data);
  }

  Future<TrailerList> getMovieTrailerById(String id) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/videos?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US');
    final response = await http.get(url);
    final data = json.decode(response.body);
    return TrailerList.fromJson(data);
  }

  Future<ImageBackdropList> getMovieImagesById(String id) async {
    List<dynamic> backdrops = [];
    List<dynamic> posters = [];
    List<dynamic> logos = [];
    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/images?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data6 = json.decode(response6.body);
    backdrops.addAll(data6['backdrops']);
    logos.addAll(data6['logos']);
    posters.addAll(data6['posters']);
    return ImageBackdropList.fromJson(backdrops, posters, logos);
  }

  Future<CastInfoList> getMovieCastById(String id) async {
    var urlNew = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/credits?api_key=84ebd14770d7675041b532f1d88ce324&language=en-US&include_image_language=en');
    final response6 = await http.get(urlNew);
    final data = json.decode(response6.body);
    return CastInfoList.fromJson(data);
  }

  Future<MovieInfoImdb> getImdbDataById(String id) async {
    var omdburl = Uri.parse('http://www.omdbapi.com/?i=$id&apikey=114165f2');
    final response = await http.get(omdburl);
    final data = json.decode(response.body);
    return MovieInfoImdb.fromJson(data);
  }
}
