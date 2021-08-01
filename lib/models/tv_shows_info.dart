import 'package:flutter/foundation.dart';

class TvInfoModel {
  final String tmdbId;
  final String overview;
  final String title;
  final List languages;
  final String backdrops;
  final String poster;
  final String tagline;
  final double rateing;
  final String homepage;
  final List genres;
  final List<Seasons> seasons;
  final List created;
  final List networks;
  final String numberOfSeasons;
  final String date;
  final String formatedDate;
  final String episoderuntime;
  TvInfoModel({
    required this.tmdbId,
    required this.overview,
    required this.title,
    required this.languages,
    required this.backdrops,
    required this.poster,
    required this.tagline,
    required this.rateing,
    required this.homepage,
    required this.genres,
    required this.seasons,
    required this.created,
    required this.networks,
    required this.numberOfSeasons,
    required this.date,
    required this.formatedDate,
    required this.episoderuntime,
  });
  factory TvInfoModel.fromJson(json) {
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

    var string = '';
    try {
      string =
          "${monthgenrater(json['first_air_date'].split("-")[1])} ${json['first_air_date'].split("-")[2]}, ${json['first_air_date'].split("-")[0]}";
    } catch (e) {}
    return TvInfoModel(
      title: json['name'] ?? '',
      homepage: json['homepage'] ?? "",
      languages: (json['spoken_languages'] as List)
          .map((laung) => laung['english_name'])
          .toList(),
      created:
          (json['created_by'] as List).map((laung) => laung['name']).toList(),
      genres: (json['genres'] as List).map((laung) => laung['name']).toList(),
      networks:
          (json['networks'] as List).map((laung) => laung['name']).toList(),
      overview: json['overview'] ?? '',
      backdrops: json['backdrop_path'] != null
          ? "https://image.tmdb.org/t/p/original" + json['backdrop_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      poster: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['poster_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      rateing: json['vote_average'],
      tagline: json['tagline'] ?? '',
      tmdbId: json['id'].toString(),
      numberOfSeasons: json['number_of_seasons'].toString(),
      seasons: (json['seasons'] as List)
          .map((season) => Seasons.fromJson(season))
          .toList(),
      date: json['first_air_date'] ?? '',
      episoderuntime: (json['episode_run_time'] as List).isNotEmpty
          ? json['episode_run_time'][0].toString() + " Minutes"
          : "N/A",
      formatedDate: string,
    );
  }
}

class Seasons {
  final String overview;
  final String name;
  final String id;
  final String image;
  final String date;
  final String customOverView;
  final String episodes;
  final String snum;
  Seasons({
    required this.overview,
    required this.name,
    required this.id,
    required this.image,
    required this.date,
    required this.customOverView,
    required this.episodes,
    required this.snum,
  });

  factory Seasons.fromJson(json) {
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
            "premiered on ${monthgenrater(json['air_date'].split("-")[1])} ${json['air_date'].split("-")[2]}, ${json['air_date'].split("-")[0]}";
      } catch (e) {
        print(e.toString());
      }
    }

    getString();
    return Seasons(
      date: json['air_date'] ?? '',
      episodes: json['episode_count'].toString(),
      id: json['id'].toString(),
      image: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + (json['poster_path'] ?? "")
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      name: json['name'] ?? '',
      overview: json['overview'] == "" ? "N/A" : json['overview'] ?? "",
      customOverView: string,
      snum: json['season_number'].toString(),
    );
  }
}
