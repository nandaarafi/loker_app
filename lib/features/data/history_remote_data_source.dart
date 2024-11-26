import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';


class HistoryRemoteDataSource {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<String>> fetchImages({
    required bucketName
}) async {
    List<String> imageUrls = [];
    final ListResult result = await storage.ref(bucketName).listAll();
    final List<Reference> allFiles = result.items;

    for (var file in allFiles) {
      final String url = await file.getDownloadURL();
      imageUrls.add(url);
    }
    return imageUrls;
  }
}