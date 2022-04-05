import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void createPDF() async {
    // pdf 생성
    final pdf = pw.Document();
    // path_provider로 디렉토리 얻어오기
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String fullPath = appDocPath + '/example.pdf';
    // 이미지
    final netImage = await networkImage('https://www.nfet.net/nfet.jpg');
    // 파일생성
    final file = File(fullPath);

    // 페이지 추가
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text('hi~ there~'),
                pw.Image(netImage),
              ],
            ),
          ); // Center
        })); // Page

    // pdf 저장하기
    await file.writeAsBytes(await pdf.save());

    print(fullPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Package'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: createPDF, child: const Text('create PDF'))
          ],
        ),
      ),
    );
  }
}
