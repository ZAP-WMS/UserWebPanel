import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseApi extends ChangeNotifier {
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }

  static Future downloadFile(Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');

    await ref.writeToFile(file);
  }

  energydefaultKeyEventsField(
      String collectionName,
      String cityName,
      String collectionName2,
      String deponame,
      String collectionName3,
      String year) {
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(cityName)
        .collection(collectionName2)
        .doc(deponame)
        .collection(collectionName3)
        .doc(year)
        .set({'depoName': deponame});
  }

  energynestedKeyEventsField(
      String collectionName,
      String cityName,
      String collectionName2,
      String deponame,
      String collectionName3,
      String year,
      String collectionName4,
      String monthName) {
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(cityName)
        .collection(collectionName2)
        .doc(deponame)
        .collection(collectionName3)
        .doc(year)
        .collection(collectionName4)
        .doc(monthName)
        .set({'depoName': deponame});
  }

  energynestedKeyEventsField2(
      String collectionName,
      String cityName,
      String collectionName2,
      String deponame,
      String collectionName3,
      String year,
      String collectionName4,
      String monthName,
      String collectionName5,
      String date) {
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(cityName)
        .collection(collectionName2)
        .doc(deponame)
        .collection(collectionName3)
        .doc(year)
        .collection(collectionName4)
        .doc(monthName)
        .collection(collectionName5)
        .doc(date)
        .set({'depoName': deponame});
  }

  defaultKeyEventsField(String collectionName, String deponame) {
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(deponame)
        .set({'depoName': deponame});
  }

  nestedKeyEventsField(String collectionName, String deponame1,
      String collectionName1, String userid) async {
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(deponame1)
        .collection(collectionName1)
        .doc(userid)
        .set({'depoName': deponame1});
  }
}

class FirebaseFile {
  final Reference ref;
  final String name;
  final String url;

  const FirebaseFile({
    required this.ref,
    required this.name,
    required this.url,
  });
}
