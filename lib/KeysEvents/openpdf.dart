import 'dart:io';
import 'package:assingment/widget/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

bool _isLoading = false;

class OpenPdf extends StatefulWidget {
  Uint8List? _documentBytes;
  OpenPdf({super.key});

  @override
  State<OpenPdf> createState() => _OpenPdfState();
}

class _OpenPdfState extends State<OpenPdf> {
  Uint8List? _documentBytes;
  @override
  void initState() {
    // getPdfBytes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pdf Viewer'),
        backgroundColor: blue,
      ),
      body: SfPdfViewer.asset('assets/Jammu_Smart_City_Limited.pdf'),
    );
  }

  // void getPdfBytes() async {
  //   String? path = '';

  //   if (kIsWeb) {
  //     firebase_storage.Reference pdfRef =
  //         firebase_storage.FirebaseStorage.instanceFor(
  //                 bucket: 'tp-zap-solz.appspot.com')
  //             .refFromURL(path);
  //     //size mentioned here is max size to download from firebase.
  //     print(pdfRef);
  //     await pdfRef.getData().then((value) {
  //       _documentBytes = value;
  //       setState(() {
  //         _isLoading = true;
  //       });
  //     });
  //   } else {
  //     HttpClient client = HttpClient();
  //     final Uri url = Uri.base.resolve(path!);
  //     final HttpClientRequest request = await client.getUrl(url);
  //     final HttpClientResponse response = await request.close();
  //     _documentBytes = await consolidateHttpClientResponseBytes(response);
  //     setState(() {});
  //   }
  // }

  NodataAvailable() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(10),
        height: 1000,
        width: 1000,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: blue)),
        child: Column(children: [
          Image.asset(
            'assets/Tata-Power.jpeg',
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/sustainable.jpeg',
                height: 100,
                width: 100,
              ),
              SizedBox(width: 50),
              Image.asset(
                'assets/Green.jpeg',
                height: 100,
                width: 100,
              )
            ],
          ),
          const SizedBox(height: 50),
          Center(
            child: Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: blue)),
              child: const Text(
                'No Checklist available yet \n Please wait for upload checklist',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ]),
      ),
    )
        // Text(
        //   "No Depot Available at This Time....",
        //   style: TextStyle(color: black),
        // ),
        );
  }
}
