import 'package:assingment/widget/style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widget/custom_appbar.dart';

class UploadQualityDocument extends StatefulWidget {
  String? title;
  String? subtitle;
  String? cityName;
  String? depoName;
  dynamic userId;
  String? tablename;
  String? date;
  int srNo;

  UploadQualityDocument({
    super.key,
    required this.title,
    required this.subtitle,
    required this.cityName,
    required this.depoName,
    required this.userId,
    required this.tablename,
    required this.date,
    required this.srNo,
  });

  @override
  State<UploadQualityDocument> createState() => _UploadQualityDocumentState();
}

class _UploadQualityDocumentState extends State<UploadQualityDocument> {
  FilePickerResult? result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: CustomAppBar(
              text: 'Upload Checklist',
              haveSynced: false,
            ),
            preferredSize: const Size.fromHeight(50)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (result != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Selected file:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: result?.files.length ?? 0,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Text(result?.files[index].name ?? '',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            );
                          })
                    ],
                  ),
                ),
              ElevatedButton(
                  onPressed: () async {
                    result = await FilePicker.platform.pickFiles(
                      withData: true,
                      type: FileType.any,
                      allowMultiple: true,
                      // allowedExtensions: ['pdf']
                    );
                    if (result == null) {
                      print("No file selected");
                    } else {
                      setState(() {});
                      result?.files.forEach((element) {
                        print(element.name);
                      });
                    }
                  },
                  child: const Text('Pick file')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () async {
                    if (result != null) {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          content: SizedBox(
                            height: 50,
                            width: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: blue,
                              ),
                            ),
                          ),
                        ),
                      );
                      Uint8List? fileBytes = result!.files.first.bytes;

                      // String? fileName = result!.files.first.name;

                      await FirebaseStorage.instance
                          .ref(
                            '${widget.title}/${widget.subtitle}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.tablename!}/${widget.date}/${result!.files.first.name}',
                          )
                          .putData(
                            fileBytes!,
                            // SettableMetadata(contentType: 'application/pdf')
                          )
                          .whenComplete(() =>
                              // setState(() => result == null)
                              // );
                              Navigator.pop(context));
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Image is Uploaded')));
                    }
                  },
                  child: const Text('Upload file')),
            ],
          ),
        ));
  }
}
