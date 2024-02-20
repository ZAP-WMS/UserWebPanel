import 'dart:typed_data';

import 'package:assingment/KeysEvents/view_AllFiles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/custom_appbar.dart';
import '../widget/style.dart';

class UploadDocument extends StatefulWidget {
  String? title;
  String? subtitle;
  String? cityName;
  String? depoName;
  dynamic userId;
  String? fldrName;
  String? date;
  int? srNo;
  String? pagetitle;
  FileType? type;
  List<String>? customizetype;

  UploadDocument(
      {super.key,
      this.title,
      this.subtitle,
      required this.cityName,
      required this.depoName,
      required this.userId,
      required this.fldrName,
      this.date,
      this.srNo,
      this.pagetitle,
      this.type,
      this.customizetype});

  @override
  State<UploadDocument> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  FilePickerResult? result;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
            // ignore: sort_child_properties_last
            child: CustomAppBar(
              cityname: widget.cityName,
              depotName: widget.depoName,
              text: '${widget.cityName}/${widget.depoName}/Upload',
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
                            if (result!.files.first.name.contains('.pdf')) {
                              return Center(
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: blue),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(result?.files[index].name ?? '',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ),
                              );
                            } else if (widget.pagetitle != 'ClosureReport') {
                              if (result!.files.first.name.contains('.jpg') ||
                                  result!.files.first.name.contains('.jpeg') ||
                                  result!.files.first.name.contains('.png') ||
                                  result!.files.first.name.contains('.pdf')) {
                                return Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: blue),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(result?.files[index].name ?? '',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                );
                              } else {
                                WidgetsBinding.instance.addPostFrameCallback(
                                    (_) => ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            backgroundColor: red,
                                            content: Text(
                                              '! Invalid file format. Only JPEG,JPG, PNG and PDF are accepted.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: white,
                                                fontSize: 20,
                                              ),
                                            ))));
                              }
                            } else {
                              WidgetsBinding.instance.addPostFrameCallback(
                                  (_) => ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          backgroundColor: red,
                                          content: Text(
                                            '! Invalid file format. Only PDF are accepted.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: white,
                                              fontSize: 20,
                                            ),
                                          ))));
                            }
                          })
                    ],
                  ),
                ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 100,
                      child: ElevatedButton(
                          onPressed: () async {
                            result = await FilePicker.platform.pickFiles(
                                withData: true,
                                type: widget.pagetitle == 'ClosureReport'
                                    ? FileType.custom
                                    : FileType.any,
                                allowMultiple: false,
                                allowedExtensions:
                                    widget.pagetitle == 'ClosureReport'
                                        ? widget.customizetype!
                                        : null);
                            if (result == null) {
                              print("No file selected");
                            } else {
                              setState(() {});
                              result?.files.forEach((element) {
                                print(element.name);
                              });
                            }
                          },
                          child: const Text(
                            'Pick file',
                            style: TextStyle(fontSize: 16),
                          )),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      width: 120,
                      height: 100,
                      child: ElevatedButton(
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
                              String refname = (widget.title ==
                                      'QualityChecklist'
                                  ? '${widget.title}/${widget.subtitle}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.fldrName}/${widget.date}/${widget.srNo}/${result!.files.first.name}'
                                  :
                                  //widget.pagetitle == 'ClosureReport' ||
                                  widget.pagetitle == 'Overview Page'
                                      ? '${widget.pagetitle}/${widget.cityName}/${widget.depoName}/${widget.fldrName}/${result!.files.first.name}'
                                      : widget.pagetitle == 'ClosureReport'
                                          ? '${widget.pagetitle}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.fldrName}/${result!.files.first.name}'
                                          : '${widget.pagetitle}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.date}/${widget.fldrName}/${result!.files.first.name}');

                              // String? fileName = result!.files.first.name;

                              await FirebaseStorage.instance
                                  .ref(refname)
                                  .putData(
                                    fileBytes!,
                                    // SettableMetadata(contentType: 'application/pdf')
                                  )
                                  .whenComplete(() =>
                                      // setState(() => result == null)
                                      // );
                                      Navigator.pop(context));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Image is Uploaded')));
                            }
                          },
                          child: const Text(
                            'Upload file',
                            style: TextStyle(fontSize: 16),
                          )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                          'Back to ${widget.title == 'QualityChecklist' ? 'Quality Checklist' : widget.pagetitle}')),
                ),
              ),
              widget.pagetitle == 'Overview Page'
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ViewAllPdf(
                              title: 'Overview Page',
                              cityName: widget.cityName,
                              depoName: widget.depoName,
                              userId: widget.userId,
                              docId: 'OverviewepoImages',
                            );
                          },
                        ));
                      },
                      child: const Text('View File'))
                  : Container()
            ],
          ),
        ));
  }
}
