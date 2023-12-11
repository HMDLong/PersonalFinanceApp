import 'dart:io';
import 'dart:math';

const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

String getRandomKey() {
  var rng = Random();
  return List<String>.generate(20, (index) => chars[rng.nextInt(51)]).join("");
}

void main() {
  for(int i = 0; i < 100; i++) {
    File('ids.txt').writeAsStringSync(
      '${getRandomKey()}\n',
      mode: FileMode.append,
    );
  }
}
