import 'package:intl/intl.dart';

import 'formated_time_genrator.dart';

class CastPersonalInfo {
  final String image;
  final String name;
  final String bio;
  final String id;
  final String birthday;
  final String placeOfBirth;
  final String knownfor;
  final String imdbId;
  final String old;
  final String gender;
  CastPersonalInfo({
    required this.image,
    required this.name,
    required this.bio,
    required this.id,
    required this.birthday,
    required this.placeOfBirth,
    required this.knownfor,
    required this.imdbId,
    required this.old,
    required this.gender,
  });
  factory CastPersonalInfo.fromJson(json) {
    getyears(String birthDateString) {
      String datePattern = "yyyy-MM-dd";

      DateTime birthDate = DateFormat(datePattern).parse(birthDateString);
      DateTime today = DateTime.now();

      int yearDiff = today.year - birthDate.year;
      return yearDiff;
    }

    var string = "Not Available";
    try {
      string =
          "${monthgenrater(json['birthday'].split("-")[1])} ${json['birthday'].split("-")[2]}, ${json['birthday'].split("-")[0]}";
      // ignore: empty_catches
    } catch (e) {}
    return CastPersonalInfo(
      bio: json['biography'] ?? '',
      birthday: string,
      id: json['id'].toString(),
      image: json['profile_path'] != null
          ? "https://image.tmdb.org/t/p/original" + json['profile_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      imdbId: json['imdb_id'] ?? "",
      name: json['name'] ?? '',
      placeOfBirth: json['place_of_birth'] ?? '',
      knownfor: json['known_for_department'] ?? '',
      gender: json['gender'] == 2 ? 'Male' : 'Female',
      old: json['birthday'] != null
          ? getyears(json['birthday']).toString() + " years"
          : "N/A",
    );
  }
}

class SocialMediaInfo {
  final String instagram;
  final String twitter;
  final String facebook;
  final String imdbId;
  SocialMediaInfo({
    required this.instagram,
    required this.twitter,
    required this.facebook,
    required this.imdbId,
  });
  factory SocialMediaInfo.fromJson(json) {
    return SocialMediaInfo(
      facebook: json['facebook_id'] != null
          ? "https://facebook.com/" + json['facebook_id']
          : "",
      imdbId: json['imdb_id'] != null
          ? "https://www.imdb.com/name/" + json['imdb_id']
          : "",
      instagram: json['instagram_id'] != null
          ? "https://www.instagram.com/" + json['instagram_id']
          : "",
      twitter: json['twitter_id'] != null
          ? "https://twitter.com/" + json['twitter_id']
          : "",
    );
  }
}
