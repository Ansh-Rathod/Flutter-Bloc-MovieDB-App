import 'package:flutter/material.dart';

import '../constants.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error,
                size: 45,
                color: Colors.white.withOpacity(.6),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Something wants wrong!",
                style: heading.copyWith(color: Colors.white.withOpacity(.9)),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "We so sorry about the error.please try again later.",
                textAlign: TextAlign.center,
                style: normalText.copyWith(color: Colors.white.withOpacity(.9)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyFavorites extends StatelessWidget {
  const EmptyFavorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .8,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              size: 45,
              color: Colors.white.withOpacity(.6),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Your Favorites is Empty",
              style: heading.copyWith(color: Colors.white.withOpacity(.9)),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Add Your Favorite movies and tv shows to track your favorites list.",
              textAlign: TextAlign.center,
              style: normalText.copyWith(color: Colors.white.withOpacity(.9)),
            ),
          ],
        ),
      ),
    );
  }
}

class WatchListFavorites extends StatelessWidget {
  const WatchListFavorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .8,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_add,
              size: 45,
              color: Colors.white.withOpacity(.6),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Your WatchList is Empty",
              style: heading.copyWith(color: Colors.white.withOpacity(.9)),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Add shows and movies to watchlist keep track of what you want to watch..",
              textAlign: TextAlign.center,
              style: normalText.copyWith(color: Colors.white.withOpacity(.9)),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyCollections extends StatelessWidget {
  const EmptyCollections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .8,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.list,
              size: 45,
              color: Colors.white.withOpacity(.6),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "You don't have any collections",
              style: heading.copyWith(color: Colors.white.withOpacity(.9)),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Create your own collection of movies and tv shows.",
              textAlign: TextAlign.center,
              style: normalText.copyWith(color: Colors.white.withOpacity(.9)),
            ),
          ],
        ),
      ),
    );
  }
}

class NoResultsFound extends StatelessWidget {
  const NoResultsFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .7,
      padding: const EdgeInsets.all(26),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search,
                size: 45,
                color: Colors.white.withOpacity(.6),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "404 not found",
                style: heading.copyWith(color: Colors.white.withOpacity(.9)),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "We didn't found anything related with your query, please search with little accurate word.",
                textAlign: TextAlign.center,
                style: normalText.copyWith(color: Colors.white.withOpacity(.9)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
