import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/constants.dart';
import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/screens/cast_info_screen/bloc/castinfo_bloc.dart';
import 'package:moviedb/screens/cast_info_screen/cast_info_screen.dart';

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
    return Container(
      constraints: BoxConstraints(minHeight: 290, maxHeight: 310),
      child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(width: 10),
          for (var i = 0; i < castList.length; i++)
            if (castList[i].image != "")
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => CastinfoBloc(),
                          child: CastInFoScreen(
                            id: castList[i].id,
                            backdrop: castList[i].image,
                          ),
                        ),
                      ),
                    );
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
              ),
        ],
      ),
    );
  }
}
