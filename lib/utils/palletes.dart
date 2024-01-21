import 'dart:math';

import 'package:flutter/material.dart';

List<Color> pallete = [

];

Color getRandomColorOfPallete() {
  return pallete[Random().nextInt(pallete.length)];
}