import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ViewJmrFiles extends StatefulWidget {
  String path;
  ViewJmrFiles({super.key, required this.path});

  @override
  State<ViewJmrFiles> createState() => _ViewJmrFilesState();
}

class _ViewJmrFilesState extends State<ViewJmrFiles> {
  bool isLoading = true;
  List<Widget> files = [];
  @override
  void initState() {
    fetchAllImages(widget.path);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JMR Files'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.all(5.0),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5),
                  itemBuilder: (context, index) {
                    return files[index];
                  })),
    );
  }

  Future<void> fetchAllImages(String imagePath) async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref(imagePath);
    ListResult result = await ref.listAll();
    for (dynamic img in result.items) {
      final imgUrl = await img.getDownloadURL();
      final path = await img.fullPath;
      files.add(Image.network(
        imgUrl,
        filterQuality: FilterQuality.low,
        width: 100,
      ));
    }
    setState(() {
      isLoading = false;
    });
  }
}
