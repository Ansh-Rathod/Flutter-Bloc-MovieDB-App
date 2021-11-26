import 'package:bottom_nav_bar/persistent-tab-view.dart';
import 'package:moviedb/constants.dart';
import 'package:moviedb/data/fetch_decvice_info.dart';
import 'package:moviedb/data/fetch_favorite_repo.dart';
import 'package:moviedb/screens/movie_info_screen/bloc/movie_info_bloc.dart';
import 'package:moviedb/screens/movie_info_screen/movie_Info_screen.dart';
import 'package:moviedb/screens/tvshow_info_screen/bloc/tv_show_detail_bloc.dart';
import 'package:moviedb/screens/tvshow_info_screen/tvshow_info_screen.dart';
import 'package:moviedb/widgets/no_results_found.dart';
import 'package:moviedb/widgets/star_icon_display.dart';

import 'bloc/collection_tab_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class CollectionsTab extends StatefulWidget {
  @override
  _CollectionsTabState createState() => _CollectionsTabState();
}

class _CollectionsTabState extends State<CollectionsTab> {
  final repo = LoadUserCollections();
  final deviceRepo = DeviceInfoRepo();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionTabBloc, CollectionTabState>(
      builder: (context, state) {
        if (state is CollectionTabLoading) {
          return Container(
            child: Center(
                child: CircularProgressIndicator(
              color: Colors.cyanAccent,
            )),
          );
        } else if (state is CollectionTabLoaded) {
          if (state.collections.isNotEmpty) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  GridView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 10 / 18),
                    children: [
                      for (var i = 0; i < state.collections.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return new AlertDialog(
                                      backgroundColor: scaffoldColor,
                                      title: new Text(
                                          "Are you really want to remove whole collection? ",
                                          style: normalText.copyWith(
                                              color: Colors.white)),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Cancel",
                                                style: normalText.copyWith(
                                                    color: Colors.white))),
                                        TextButton(
                                            onPressed: () async {
                                              var newid = await deviceRepo
                                                  .deviceDetails();
                                              try {
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'UserCollections')
                                                    .doc(newid)
                                                    .collection('Collections')
                                                    .doc(state
                                                        .collections[i].name)
                                                    .delete();
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'UserCollections')
                                                    .doc(newid)
                                                    .collection('allMovies')
                                                    .where('inCollection',
                                                        isEqualTo: state
                                                            .collections[i]
                                                            .name)
                                                    .get()
                                                    .then((value) async {
                                                  for (var coll in value.docs) {
                                                    await coll.reference
                                                        .delete();
                                                  }
                                                });
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'UserCollections')
                                                    .doc(newid)
                                                    .collection(
                                                        'CollectionInfo')
                                                    .doc(state
                                                        .collections[i].name)
                                                    .delete();
                                                setState(() {
                                                  state.collections.removeAt(i);
                                                });
                                                Navigator.of(context).pop();
                                              } catch (e) {
                                                print(e.toString());
                                              }
                                            },
                                            child: Text(
                                              "Remove",
                                              style: normalText.copyWith(
                                                color: Colors.cyanAccent,
                                              ),
                                            ))
                                      ],
                                    );
                                  });
                            },
                            onTap: () async {
                              var newid = await deviceRepo.deviceDetails();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CollectionInfo(
                                      collectionName: state.collections[i].name,
                                      deviceId: newid,
                                      image: state.collections[i].image,
                                      date: state.collections[i].time)));
                            },
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: CachedNetworkImage(
                                      imageUrl: state.collections[i].image,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    state.collections[i].name,
                                    style: normalText.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    state.collections[i].time,
                                    style: normalText.copyWith(
                                      color: Colors.white.withOpacity(.8),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            );
          } else {
            return EmptyCollections();
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class CollectionInfo extends StatelessWidget {
  const CollectionInfo(
      {Key? key,
      required this.deviceId,
      required this.collectionName,
      required this.image,
      required this.date})
      : super(key: key);
  final String deviceId;
  final String collectionName;
  final String image;
  final String date;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
              backgroundColor: scaffoldColor,
              pinned: true,
              expandedHeight: 400,
              brightness: Brightness.dark,
              stretch: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                      size: 35,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  collectionName,
                  style: heading.copyWith(
                    color: Colors.white,
                  ),
                ),
                stretchModes: [
                  StretchMode.fadeTitle,
                  StretchMode.zoomBackground
                ],
                centerTitle: true,
                collapseMode: CollapseMode.pin,
                background: DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: BoxDecoration(),
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                  color: scaffoldColor,
                                  image: DecorationImage(
                                      image:
                                          CachedNetworkImageProvider(image))),
                            ),
                            SizedBox(height: 30),
                            Text("CREATED BY YOU ON " + date.toUpperCase(),
                                style: normalText.copyWith(
                                    color: Colors.white, fontSize: 12))
                          ],
                        ),
                      ),
                    )),
              )),
          SliverToBoxAdapter(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('UserCollections')
                    .doc(deviceId)
                    .collection('Collections')
                    .doc(collectionName)
                    .collection('movies & Tv')
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snp) {
                  if (!snp.hasData) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black,
                          color: Colors.cyanAccent,
                        ),
                      ),
                    );
                  } else if (snp.hasData) {
                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        ...snp.data!.docs
                            .map((doc) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      if (doc['isMovie']) {
                                        pushNewScreen(
                                          context,
                                          screen: BlocProvider(
                                            create: (context) =>
                                                MovieInfoBloc(),
                                            child: MovieDetailsScreen(
                                              backdrop: doc['backdrop'],
                                              id: doc['id'],
                                            ),
                                          ),
                                          withNavBar: false,
                                        );
                                      } else {
                                        pushNewScreen(
                                          context,
                                          withNavBar: false,
                                          screen: BlocProvider(
                                            create: (context) =>
                                                TvShowDetailBloc(),
                                            child: TvShowDetailScreen(
                                              backdrop: doc['backdrop'],
                                              id: doc['id'],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              color: Colors.grey.shade900,
                                              child: CachedNetworkImage(
                                                imageUrl: doc['image'],
                                                height: 190,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    flex: 2,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          doc['name'],
                                                          style:
                                                              heading.copyWith(
                                                            fontSize: 20,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(doc['date'],
                                                            style: normalText
                                                                .copyWith(
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            IconTheme(
                                                              data:
                                                                  IconThemeData(
                                                                color: Colors
                                                                    .cyanAccent,
                                                                size: 20,
                                                              ),
                                                              child:
                                                                  StarDisplay(
                                                                value: ((doc['rate'] *
                                                                            5) /
                                                                        10)
                                                                    .round(),
                                                              ),
                                                            ),
                                                            Text(
                                                              "  " +
                                                                  doc['rate']
                                                                      .toString() +
                                                                  "/10",
                                                              style: normalText
                                                                  .copyWith(
                                                                color: Colors
                                                                    .cyanAccent,
                                                                letterSpacing:
                                                                    1.2,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.close,
                                                        color: Colors.white),
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'UserCollections')
                                                          .doc(deviceId)
                                                          .collection(
                                                              'Collections')
                                                          .doc(collectionName)
                                                          .collection(
                                                              'movies & Tv')
                                                          .doc(doc['id'])
                                                          .delete();
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                            .toList()
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
          )
        ],
      ),
    );
  }
}
