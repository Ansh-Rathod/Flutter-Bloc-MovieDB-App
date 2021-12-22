import 'package:flutter/material.dart';

class Genres {
  final String id;
  final String name;
  final String image;
  final Color color;
  Genres({
    required this.color,
    required this.image,
    required this.id,
    required this.name,
  });
  factory Genres.fromJson(json) {
    return Genres(
      id: json['id'].toString(),
      name: json['name'],
      image: json['image'].toString(),
      color: json['color'],
    );
  }
}

class GenresList {
  final List<Genres> list;
  GenresList({
    required this.list,
  });
  factory GenresList.fromJson(json) {
    return GenresList(
        list: (json as List).map((genre) => Genres.fromJson(genre)).toList());
  }
}

final genreslist = [
  {
    "id": 28,
    "name": "Action",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/3FUJT82YKY1EJ1dmunQhW5PUZAT.jpg",
    "color": const Color(0xFFA59A04),
  },
  {
    "id": 12,
    "name": "Adventure",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/tOEOlmLP71IojeJ91dyJ9Nsb8O8.jpg",
    "color": const Color(0xff1d0d87)
  },
  {
    "id": 16,
    "name": "Animation",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/4nssBcQUBadCTBjrAkX46mVEKts.jpg",
    "color": const Color(0xFF036B4C)
  },
  {
    "id": 35,
    "name": "Comedy",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/8kOWDBK6XlPUzckuHDo3wwVRFwt.jpg",
    "color": const Color(0xff375304)
  },
  {
    "id": 80,
    "name": "Crime",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/6PX0r5TRRU5y0jZ70y1OtbLYmoD.jpg",
    "color": const Color(0xff4004d7)
  },
  {
    "id": 99,
    "name": "Documentary",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/n0ybibhJtQ5icDqTp8eRytcIHJx.jpg",
    "color": const Color(0xFF6A680B)
  },
  {
    "id": 18,
    "name": "Drama",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/nel144y4dIOdFFid6twN5mAX9Yd.jpg",
    "color": const Color(0xFF7D0396)
  },
  {
    "id": 10751,
    "name": "Family",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/uwslHj6nEyPX5IbNXhuEeI0PTth.jpg",
    "color": const Color(0xFF03774B)
  },
  {
    "id": 14,
    "name": "Fantasy",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/kEl2t3OhXc3Zb9FBh1AuYzRTgZp.jpg",
    "color": const Color(0xff039620)
  },
  {
    "id": 36,
    "name": "History",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/bQLrHIRNEkE3PdIWQrZHynQZazu.jpg",
    "color": const Color(0xffb49208)
  },
  {
    "id": 27,
    "name": "Horror",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/7pEn2fCFWa8DIwQnxG6Cq7iaKLv.jpg",
    "color": const Color(0xFF682303)
  },
  {
    "id": 10402,
    "name": "Music",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/gbmkFWdtihe1VfydTDsieQ6VfGL.jpg",
    "color": const Color(0xffc01111)
  },
  {
    "id": 9648,
    "name": "Mystery",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/o6qT33idpxWV51FsIjAyGDyp5Ou.jpg",
    "color": const Color(0xff504907)
  },
  {
    "id": 10749,
    "name": "Romance",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/9yguvvrOG8dBVIbxCst0GyzVJu1.jpg",
    "color": const Color(0xffa00e80)
  },
  {
    "id": 878,
    "name": "Science Fiction",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/th5UkDLIa7yyma9UYDAWaIgDh6z.jpg",
    "color": const Color(0xff8a08b5)
  },
  {
    "id": 53,
    "name": "Thriller",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/vqzNJRH4YyquRiWxCCOH0aXggHI.jpg",
    "color": const Color(0xff0b7f1e)
  },
  {
    "id": 10752,
    "name": "War",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/34nDCQZwaEvsy4CFO5hkGRFDCVU.jpg",
    "color": const Color(0xff9d105b)
  },
  {
    "id": 37,
    "name": "Western",
    "image":
        "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/uHA5COgDzcxjpYSHHulrKVl6ByL.jpg",
    "color": const Color(0xffb49208)
  },

  // {
  //   "id": 10762,
  //   "name": "Kids",
  // },

  // {
  //   "id": 10763,
  //   "name": "News",
  // },
  // {
  //   "id": 10764,
  //   "name": "Reality",
  // },
  // {
  //   "id": 10765,
  //   "name": "Sci-Fi & Fantasy",
  // },
  // {
  //   "id": 10766,
  //   "name": "Soap",
  // },
  // {
  //   "id": 10767,
  //   "name": "Talk",
  // },
  // {
  //   "id": 10768,
  //   "name": "War & Politics",
  // },
];
