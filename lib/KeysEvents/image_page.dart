import 'dart:html' as html;
import 'package:assingment/KeysEvents/viewFIle.dart';
import 'package:assingment/KeysEvents/view_excel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../FirebaseApi/firebase_api.dart';
import '../widget/style.dart';
import 'package:http/http.dart' as http;

class ImagePage extends StatefulWidget {
  final FirebaseFile file;

  const ImagePage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isImage = ['.jpeg', '.jpg', '.png'].any(widget.file.name.contains);
    final isPdf = ['.pdf'].any(widget.file.name.contains);
    final isexcel = ['.xlsx'].any(widget.file.name.contains);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.file.name),
        backgroundColor: blue,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () async {
              Reference storageReference = FirebaseStorage.instance
                  .ref()
                  .child(widget.file.ref.fullPath.toString());

              String downloadURL = await storageReference.getDownloadURL();
              String fileName = storageReference.name;
              // print("Download URL: $downloadURL");
              downloadImage(downloadURL, fileName);

              final snackBar = SnackBar(
                content: Text('Downloaded ${widget.file.name}'),
              );
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          const SizedBox(width: 12),
          IconButton(
              onPressed: () {
                FirebaseStorage.instance
                    .ref()
                    .child(widget.file.url)
                    .delete()
                    .then((value) {
                  print('Delete Successfull');
                  Navigator.pop(context);
                });
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: isImage
          ? Center(
              child: Image.network(
                widget.file.url,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          : isPdf
              ? ViewFile(path: widget.file.url)
              : isexcel
                  ? ViewExcel(path: widget.file.ref)
                  : const Center(
                      child: Text(
                        'Cannot be displayed',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
    );
  }

  void downloadImage(String imageUrl, String fileName) {
    html.AnchorElement anchorElement = html.AnchorElement(href: imageUrl);
    anchorElement.download = fileName;
    anchorElement.click();
  }
}
