import 'package:flutter/foundation.dart';

class MovieModel {
  final String title;
  final String poster;
  final String id;
  final String backdrop;
  final double vote_average;
  final String release_date;
  MovieModel({
    required this.title,
    required this.poster,
    required this.id,
    required this.backdrop,
    required this.vote_average,
    required this.release_date,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    monthgenrater(String date) {
      switch (date) {
        case "01":
          return months[0];
        case "02":
          return months[1];
        case "03":
          return months[2];
        case "04":
          return months[3];
        case "05":
          return months[4];
        case "06":
          return months[5];
        case "07":
          return months[6];
        case "08":
          return months[7];
        case "09":
          return months[8];
        case "10":
          return months[9];
        case "11":
          return months[10];
        case "12":
          return months[11];
        default:
          return date + ",";
      }
    }

    var string = "";
    getString() {
      try {
        string =
            "${monthgenrater(json['release_date'].split("-")[1])} ${json['release_date'].split("-")[2]}, ${json['release_date'].split("-")[0]}";
      } catch (e) {
        print(e.toString());
      }
    }

    getString();
    return new MovieModel(
      backdrop: json['backdrop_path'] != null
          ? "https://image.tmdb.org/t/p/original" + json['backdrop_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      poster: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['poster_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      id: json['id'].toString(),
      title: json['title'],
      vote_average: json['vote_average'].toDouble() ?? 0.0,
      release_date: string,
    );
  }
}

class MovieModelList {
  final List<MovieModel> movies;
  MovieModelList({
    required this.movies,
  });
  factory MovieModelList.fromJson(List<dynamic> json) {
    return new MovieModelList(
        movies:
            (json as List).map((list) => MovieModel.fromJson(list)).toList());
  }
}
