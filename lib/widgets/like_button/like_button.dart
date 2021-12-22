import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/like_button_cubit.dart';

class LikeButton extends StatelessWidget {
  final String id;
  final String date;
  final String title;
  final String poster;
  final String type;
  final double rate;
  const LikeButton({
    Key? key,
    required this.id,
    required this.date,
    required this.title,
    required this.poster,
    required this.type,
    required this.rate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LikeButtonCubit()..init(id),
      child: BlocBuilder<LikeButtonCubit, LikeButtonState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: kElevationToShadow[2]),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 50),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.5),
                    ),
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<LikeButtonCubit>(context).like(
                            date: date,
                            id: id,
                            poster: poster,
                            rating: rate,
                            title: title,
                            type: type);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            !state.isLiked
                                ? const Icon(
                                    CupertinoIcons.heart,
                                    color: Colors.white,
                                    size: 30,
                                  )
                                : const Icon(
                                    CupertinoIcons.heart_solid,
                                    color: Colors.amber,
                                    size: 30,
                                  ),
                            const SizedBox(width: 10),
                            Text(
                              !state.isLiked
                                  ? "Add to Favorite"
                                  : "Your Favorite",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
