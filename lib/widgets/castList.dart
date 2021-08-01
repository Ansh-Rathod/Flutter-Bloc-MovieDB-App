import 'package:amd/screeens/info_pages/get_cast_movie/bloc/cast_movies_bloc.dart';
import 'package:amd/screeens/info_pages/get_cast_movie/cast_info.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/movie_info_model.dart';
import '../themes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CastList extends StatelessWidget {
  const CastList({
    Key? key,
    required this.castList,
    required this.textColor,
  }) : super(key: key);

  final List<CastInfo> castList;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 10),
          for (var i = 0; i < castList.length; i++)
            if (castList[i].image != "")
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              create: (context) => CastMoviesBloc()
                                ..add(LoadCastInfo(id: castList[i].id)),
                              child: CastPersonalInfoScreen(
                                image: castList[i].image,
                                title: castList[i].name,
                              ),
                            )));
                  },
                  child: Tooltip(
                    message: "${castList[i].name} as ${castList[i].character}",
                    child: Container(
                      width: 130,
                      constraints: BoxConstraints(minHeight: 290),
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            width: 130,
                            color: Colors.black,
                            child: CachedNetworkImage(
                              imageUrl: castList[i].image,
                              fit: BoxFit.cover,
                              height: 200,
                              width: 130,
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: 130,
                            child: Text(
                              castList[i].name,
                              maxLines: 2,
                              style: normalText.copyWith(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: 130,
                            child: Text(
                              castList[i].character,
                              maxLines: 2,
                              style: normalText.copyWith(
                                  color: textColor.withOpacity(.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
        ],
      ),
    );
  }
}
