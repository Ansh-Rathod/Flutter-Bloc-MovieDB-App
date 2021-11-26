import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorGenrator {
  Future<List<Color>> getImagePalette(ImageProvider imageProvider) async {
    try {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        imageProvider,
        timeout: Duration(seconds: 3),
      );
      return [
        paletteGenerator.dominantColor!.color,
        paletteGenerator.dominantColor!.color.computeLuminance() >= 0.4
            ? Colors.black
            : Colors.white,
      ];
    } catch (e) {
      print(e.toString());
      return [
        Colors.black,
        Colors.white,
      ];
    }
  }
}
