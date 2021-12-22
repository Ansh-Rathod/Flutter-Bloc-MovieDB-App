import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/formated_time_genrator.dart';
import '../../widgets/movie_card.dart';
import '../../widgets/no_results_found.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            largeTitle: Text(
              'Favorites',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            border: Border(
              bottom: BorderSide(
                width: .6,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ValueListenableBuilder<Box>(
                valueListenable: Hive.box('Favorites').listenable(),
                builder: (context, box, child) {
                  if (box.isEmpty) {
                    return const EmptyFavorites();
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        final info = box.getAt(i);

                        return Dismissible(
                          key: Key(info['id'].toString()),
                          onDismissed: (direction) {
                            box.deleteAt(i);
                          },
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            child: const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Icon(
                                CupertinoIcons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: HorizontalMovieCard(
                            poster: info['poster'],
                            name: info['title'],
                            backdrop: '',
                            date: info['date'] != ''
                                ? "${monthgenrater(info['date'].split("-")[1])} ${info['date'].split("-")[2]}, ${info['date'].split("-")[0]}"
                                : "Not Available",
                            id: info['id'],
                            color: Colors.white,
                            isMovie: info['type'] == 'MOVIE',
                            rate: info['rating'],
                          ),
                        );
                      },
                      itemCount: box.length);
                }),
          ),
        ],
      ),
    );
  }
}
