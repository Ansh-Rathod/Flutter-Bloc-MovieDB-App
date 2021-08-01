import 'package:amd/models/tv_shows_info.dart';
import 'package:amd/themes.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class OverviewWidget extends StatelessWidget {
  const OverviewWidget({
    Key? key,
    required this.textColor,
    required this.info,
  }) : super(key: key);

  final Color textColor;
  final TvInfoModel info;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Overview", style: heading.copyWith(color: textColor)),
            SizedBox(height: 10),
            ReadMoreText(
              info.overview,
              trimLines: 6,
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Show more',
              trimExpandedText: 'Show less',
              style: normalText.copyWith(
                  fontWeight: FontWeight.w500, color: textColor),
              moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
