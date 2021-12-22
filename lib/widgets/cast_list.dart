import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieinfo/animation.dart';

import '../constants.dart';
import '../models/movie_model.dart';
import '../screens/cast_info_screen/bloc/castinfo_bloc.dart';
import '../screens/cast_info_screen/cast_info_screen.dart';

class CastList extends StatelessWidget {
  const CastList({
    Key? key,
    required this.castList,
  }) : super(key: key);

  final List<CastInfo> castList;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 300, maxHeight: 320),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: 10),
          for (var i = 0; i < castList.length; i++)
            if (castList[i].image != "")
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: InkWell(
                  onTap: () {
                    pushNewScreen(
                      context,
                      BlocProvider(
                        create: (context) => CastinfoBloc(),
                        child: CastInFoScreen(
                          id: castList[i].id,
                          backdrop: castList[i].image,
                        ),
                      ),
                    );
                  },
                  child: Tooltip(
                    message: "${castList[i].name} as ${castList[i].character}",
                    child: Container(
                      width: 130,
                      constraints: const BoxConstraints(minHeight: 290),
                      child: Column(
                        children: [
                          Container(
                              height: 200,
                              width: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade900,
                                boxShadow: kElevationToShadow[8],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: castList[i].image,
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: 130,
                                ),
                              )),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 130,
                            child: Text(
                              castList[i].name,
                              maxLines: 2,
                              style: normalText.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: 130,
                            child: Text(
                              castList[i].character,
                              maxLines: 2,
                              style: normalText.copyWith(
                                  color: Colors.white.withOpacity(.8),
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
