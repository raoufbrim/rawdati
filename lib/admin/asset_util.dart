import 'dart:math';
import 'package:flutter/services.dart';
import 'dart:convert';

Future<String> getRandomClassImage() async {
  final random = Random();
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  final classImages = manifestMap.keys
      .where((String key) => key.startsWith('assets/classes/'))
      .toList();

  if (classImages.isNotEmpty) {
    final randomIndex = random.nextInt(classImages.length);
    return classImages[randomIndex];
  } else {
    return 'assets/default_image.png'; // Default image if no class images are found
  }
}
