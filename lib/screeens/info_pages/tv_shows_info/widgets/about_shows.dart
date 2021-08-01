import 'package:amd/models/tv_shows_info.dart';
import 'package:amd/themes.dart';
import 'package:amd/widgets/expandable.dart';
import 'package:flutter/material.dart';

class AboutShowWidget extends StatelessWidget {
  const AboutShowWidget({
    Key? key,
    required this.textColor,
    required this.info,
  }) : super(key: key);

  final Color textColor;
  final TvInfoModel info;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: ExpandableGroup(
          isExpanded: true,
          expandedIcon: Icon(
            Icons.arrow_drop_up,
            color: textColor != Colors.white ? Colors.black : Colors.white,
          ),
          collapsedIcon: Icon(
            Icons.arrow_drop_down,
            color: textColor != Colors.white ? Colors.black : Colors.white,
          ),
          header: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "About Show",
              style: heading.copyWith(color: textColor),
            ),
          ),
          items: [
            if (info.created.isNotEmpty)
              ListTile(
                title: Text(
                  "Created By",
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    style: normalText.copyWith(color: textColor),
                    children: [
                      ...info.created
                          .map(
                            (genre) => TextSpan(text: "$genre, "),
                          )
                          .toList()
                    ],
                  ),
                ),
              ),
            if (info.networks.isNotEmpty)
              ListTile(
                title: Text(
                  "Avalable on",
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    style: normalText.copyWith(color: textColor),
                    children: [
                      ...info.networks
                          .map(
                            (genre) => TextSpan(text: "$genre, "),
                          )
                          .toList()
                    ],
                  ),
                ),
              ),
            ListTile(
                title: Text(
                  "Number Of Seasons",
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: Text(
                  info.numberOfSeasons,
                  style: normalText.copyWith(color: textColor),
                )),
            ListTile(
                title: Text(
                  "Episode Run Time",
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: Text(
                  info.episoderuntime,
                  style: normalText.copyWith(color: textColor),
                )),
            if (info.formatedDate != "")
              ListTile(
                title: Text(
                  "First Episode Released on",
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    style: normalText.copyWith(color: textColor),
                    children: [
                      TextSpan(text: info.formatedDate),
                    ],
                  ),
                ),
              ),
            if (info.tagline != "")
              ListTile(
                title: Text(
                  "Show Tagline",
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: Text(
                  info.tagline,
                  style: normalText.copyWith(color: textColor),
                ),
              )
          ],
        ),
      ),
    );
  }
}
