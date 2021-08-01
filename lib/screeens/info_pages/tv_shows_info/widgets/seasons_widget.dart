import 'package:amd/models/tv_shows_info.dart';
import 'package:amd/screeens/info_pages/season_info/bloc/season_info_bloc.dart';
import 'package:amd/screeens/info_pages/season_info/season_info.dart';
import 'package:amd/themes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';

class SeasonsWidget extends StatelessWidget {
  const SeasonsWidget({
    Key? key,
    required this.info,
    required this.season,
    required this.textColor,
  }) : super(key: key);

  final TvInfoModel info;
  final Seasons season;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (context) => SeasonInfoBloc()
                      ..add(LoadSeasonInfo(id: info.tmdbId, snum: season.snum)),
                    child: SeasonInfo(
                      image: season.image,
                      title: info.title + " (${season.name})",
                    ),
                  )));
        },
        child: Container(
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Colors.black,
                    child: CachedNetworkImage(
                      imageUrl: season.image,
                      height: 200,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          season.name,
                          style:
                              heading.copyWith(color: textColor, fontSize: 24),
                        ),
                        SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            style: normalText.copyWith(
                                color: textColor, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: season.date.split("-")[0] + " | ",
                              ),
                              TextSpan(
                                text: season.episodes + " Episodes",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        SizedBox(height: 5),
                        ReadMoreText(
                          season.overview == "N/A"
                              ? "${season.name} of ${info.title} " +
                                  season.customOverView
                              : season.overview,
                          trimLines: 4,
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                          style: normalText.copyWith(
                              fontWeight: FontWeight.w500, color: textColor),
                          moreStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
