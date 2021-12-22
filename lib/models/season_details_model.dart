import 'formated_time_genrator.dart';
import 'movie_model.dart';

class EpisodeModel {
  final String id;
  final String name;
  final String overview;
  final String seasonNumber;
  final String stillPath;
  final double voteAverage;
  final String date;
  final String number;
  final String customDate;
  final List<CastInfo> castInfoList;

  EpisodeModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.stillPath,
    required this.voteAverage,
    required this.date,
    required this.number,
    required this.customDate,
    required this.castInfoList,
  });

  factory EpisodeModel.fromJson(json) {
    var string = "Not Available";
    getString() {
      try {
        string =
            "${monthgenrater(json['air_date'].split("-")[1])} ${json['air_date'].split("-")[2]}, ${json['air_date'].split("-")[0]}";
        // ignore: empty_catches
      } catch (e) {}
    }

    getString();
    return EpisodeModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      overview: json['overview'] ?? '',
      seasonNumber: json['season_number'].toString(),
      stillPath: json['still_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['still_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      voteAverage: json['vote_average'].toDouble() ?? 0.0,
      date: json['air_date'],
      number: json['episode_number'].toString(),
      castInfoList: (json['guest_stars'] as List)
          .map((star) => CastInfo.fromJson(star))
          .toList(),
      customDate: string,
    );
  }
}

class SeasonModel {
  final String name;
  final String overview;
  final String id;
  final String posterPath;
  final String seasonNumber;
  final String customDate;
  final List<EpisodeModel> episodes;
  SeasonModel({
    required this.name,
    required this.overview,
    required this.id,
    required this.posterPath,
    required this.seasonNumber,
    required this.customDate,
    required this.episodes,
  });

  factory SeasonModel.fromJson(json) {
    var string = "Not Available";
    getString() {
      try {
        string =
            "${monthgenrater(json['air_date'].split("-")[1])} ${json['air_date'].split("-")[2]}, ${json['air_date'].split("-")[0]}";
        // ignore: empty_catches
      } catch (e) {}
    }

    getString();
    return SeasonModel(
      name: json['name'] ?? '',
      overview: json['overview'] == "" ? "N/A" : json['overview'] ?? "",
      id: json['id'].toString(),
      posterPath: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['poster_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      seasonNumber: json['season_number'].toString(),
      episodes: ((json['episodes'] ?? []) as List)
          .map((episode) => EpisodeModel.fromJson(episode))
          .toList(),
      customDate: string,
    );
  }
}
