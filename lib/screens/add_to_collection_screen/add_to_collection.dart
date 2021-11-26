import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moviedb/constants.dart';

class AddToCollection extends StatelessWidget {
  final String title;
  final String date;
  final String devid;
  final String image;
  final String backdrop;
  final bool isMovie;
  final double rate;
  final String movieid;

  AddToCollection({
    Key? key,
    required this.title,
    required this.date,
    required this.rate,
    required this.devid,
    required this.image,
    required this.backdrop,
    required this.isMovie,
    required this.movieid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController con = TextEditingController();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "My Collections",
            style: heading,
          ),
          elevation: 0,
          backgroundColor: scaffoldColor,
          brightness: Brightness.dark,
        ),
        backgroundColor: scaffoldColor,
        body: Container(
            child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: RaisedButton(
                color: Colors.cyanAccent,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: scaffoldColor,
                          title: new Text(
                            "Give your collection a name.",
                            style: heading.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          content: TextField(
                            controller: con,
                            cursorColor: Colors.cyanAccent,
                            style: heading.copyWith(
                                color: Colors.white, fontSize: 24),
                            autofocus: true,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.cyanAccent, width: 2))),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "CANCEL",
                                style: normalText.copyWith(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            TextButton(
                                onPressed: () async {
                                  FirebaseFirestore.instance
                                      .collection('UserCollections')
                                      .doc(devid)
                                      .collection('Collections')
                                      .doc(con.text.trim())
                                      .collection('movies & Tv')
                                      .doc(movieid)
                                      .set({
                                    "name": title,
                                    "image": image,
                                    'rate': rate,
                                    "id": movieid,
                                    "date": date,
                                    "backdrop": backdrop,
                                    "isMovie": isMovie,
                                  });
                                  FirebaseFirestore.instance
                                      .collection('UserCollections')
                                      .doc(devid)
                                      .collection('CollectionInfo')
                                      .doc(con.text)
                                      .set({
                                    "name": con.text,
                                    "image": image,
                                    "time": DateTime.now()
                                  });
                                  FirebaseFirestore.instance
                                      .collection('UserCollections')
                                      .doc(devid)
                                      .collection('allMovies')
                                      .doc(movieid)
                                      .set({
                                    "inCollection": con.text.trim(),
                                  });

                                  Navigator.pop(context);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Fluttertoast.showToast(
                                    msg: "Added to collection ${con.text}",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                  );
                                },
                                child: Text("CREATE AND ADD",
                                    style: normalText.copyWith(
                                        color: Colors.cyanAccent,
                                        fontSize: 15)))
                          ],
                        );
                      });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    Text(
                      "New collection",
                      style: normalText.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('UserCollections')
                    .doc(devid)
                    .collection('CollectionInfo')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snp) {
                  if (snp.hasData) {
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        ...snp.data!.docs
                            .map((coll) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection('UserCollections')
                                          .doc(devid)
                                          .collection('Collections')
                                          .doc(coll['name'].trim())
                                          .collection('movies & Tv')
                                          .doc(movieid)
                                          .set({
                                        "name": title,
                                        "image": image,
                                        "id": movieid,
                                        "backdrop": backdrop,
                                        'rate': rate,
                                        "date": date,
                                        "isMovie": isMovie,
                                      });
                                      FirebaseFirestore.instance
                                          .collection('UserCollections')
                                          .doc(devid)
                                          .collection('allMovies')
                                          .doc(movieid)
                                          .set({
                                        "inCollection": coll['name'].trim(),
                                      });
                                      Fluttertoast.showToast(
                                        msg:
                                            "Added to collection ${coll['name']}",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                      );
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    leading: Image.network(coll['image']),
                                    title: Text(
                                      coll['name'],
                                      style: normalText.copyWith(
                                          color: Colors.white),
                                    ),
                                  ),
                                ))
                            .toList()
                      ],
                    );
                  } else if (!snp.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.cyanAccent,
                      ),
                    );
                  } else {
                    return Container();
                  }
                })
          ],
        )),
      ),
    );
  }
}
