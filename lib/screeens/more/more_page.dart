import 'package:amd/themes.dart';
import 'package:amd/widgets/expandable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class More extends StatelessWidget {
  const More({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldColor,
        elevation: 0,
        brightness: Brightness.dark,
        title: Text(
          "About",
          style: heading.copyWith(
            color: Colors.cyanAccent,
            fontSize: 24,
          ),
        ),
      ),
      backgroundColor: scaffoldColor,
      body: ListView(
        children: [
          SizedBox(height: 20),
          Container(
            child: Center(
              child: CachedNetworkImage(
                  height: 140,
                  imageUrl:
                      'https://media-exp1.licdn.com/dms/image/C4D0BAQEdRMOG3VMr0Q/company-logo_200_200/0/1585407202899?e=1635984000&v=beta&t=1CoAmRySnEeR9mBOT77oJDLUeWWyVzpKq9vNPK-_exo'),
            ),
          ),
          SizedBox(height: 20),
          ExpandableGroup(
            isExpanded: false,
            collapsedIcon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.cyanAccent,
            ),
            expandedIcon: Icon(
              Icons.keyboard_arrow_up,
              color: Colors.cyanAccent,
            ),
            header: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Terms of Use",
                style: heading.copyWith(color: Colors.white),
              ),
            ),
            items: [
              ListTile(
                  title: Text("Acceptance of Terms",
                      style: normalText.copyWith(color: Colors.white)),
                  subtitle: Text(
                      "If you use our products from a mobile device, we may collect, either through your mobile device or the application itself, your mobile device identifier, hardware model, operating system version or mobile network information (as well as any registration data you provide to us). We may also collect geolocation information, which may be used for operational and product-related purposes, such as to customize information based on your location.",
                      style: normalText.copyWith(color: Colors.white))),
              ListTile(
                title: Text("License",
                    style: normalText.copyWith(color: Colors.white)),
                subtitle: Text(
                    "The TMDb APIs are owned by TMDb, Inc. (hereinafter \"TMDb\") and are licensed to you on a worldwide (except as limited below), non-exclusive, non-transferable, non-sublicenseable basis on the terms and conditions set forth herein. These terms define legal use of the TMDb APIs, all updates, revisions, substitutions that may be made available by TMDb, and any copies of the TMDb APIs made by or for you. TMDb reserves all rights not expressly granted to you.",
                    style: normalText.copyWith(color: Colors.white)),
              ),
            ],
          ),
          ExpandableGroup(
            isExpanded: false,
            collapsedIcon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.cyanAccent,
            ),
            expandedIcon: Icon(
              Icons.keyboard_arrow_up,
              color: Colors.cyanAccent,
            ),
            header: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "About TMDb",
                style: heading.copyWith(color: Colors.white),
              ),
            ),
            items: [
              ListTile(
                title: Text(
                  "The Movie Database (TMDb) is a community built movie and TV database. Every piece of data has been added by our amazing community dating back to 2008. TMDb's strong international focus and breadth of data is largely unmatched and something we're incredibly proud of. Put simply, we live and breathe community and that's precisely what makes us different.",
                  style: normalText.copyWith(color: Colors.white),
                ),
              )
            ],
          ),
          ExpandableGroup(
            isExpanded: false,
            collapsedIcon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.cyanAccent,
            ),
            expandedIcon: Icon(
              Icons.keyboard_arrow_up,
              color: Colors.cyanAccent,
            ),
            header: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "App Information",
                style: heading.copyWith(color: Colors.white),
              ),
            ),
            items: [
              ListTile(
                title: Text('App Created with Flutter bloc library.',
                    style: normalText.copyWith(color: Colors.white)),
              ),
              ListTile(
                  onTap: () {
                    launch("https://www.themoviedb.org/documentation/api");
                  },
                  title: Text('Build with TMDb opan source api',
                      style: normalText.copyWith(color: Colors.cyanAccent))),
              ListTile(
                onTap: () {
                  launch("https://github.com/Ansh-Rathod");
                },
                title: Text(
                  'Socure code of application',
                  style: normalText.copyWith(
                    color: Colors.cyanAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
