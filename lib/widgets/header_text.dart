import 'package:flutter/material.dart';

import '../constants.dart';

class HeaderText extends StatelessWidget {
  final String text;
  const HeaderText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Text(text, style: heading.copyWith(color: Colors.white)),
    );
  }
}
