import 'package:amd/themes.dart';
import 'package:flutter/material.dart';

class NoResultsFound extends StatelessWidget {
  const NoResultsFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .8,
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 45,
              color: Colors.white.withOpacity(.6),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "404 not found",
              style: heading.copyWith(color: Colors.white.withOpacity(.9)),
            ),
            SizedBox(
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
    );
  }
}
