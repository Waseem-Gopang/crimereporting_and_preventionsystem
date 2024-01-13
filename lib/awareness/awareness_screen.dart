import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Awareness extends StatefulWidget {
  const Awareness({Key? key}) : super(key: key);

  @override
  State<Awareness> createState() => _AwarenessState();
}

class _AwarenessState extends State<Awareness> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Awareness Laws"),
      ),
      body: buildGridView(),
    );
  }

  Widget buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: pdfData.length,
      itemBuilder: (context, index) {
        return buildGridItem(index);
      },
    );
  }

  Widget buildGridItem(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfScreen(
                pdfName: pdfData[index]["name"],
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                pdfData[index]["image"]!,
                height: 120,
                width: 100,
              ),
              Text(
                pdfData[index]["name"]!,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PdfScreen extends StatefulWidget {
  final String? pdfName;
  final String? pdfImage;

  const PdfScreen({
    Key? key,
    required this.pdfName,
    this.pdfImage,
  }) : super(key: key);

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  late String pdfUrl = '';

  @override
  void initState() {
    super.initState();
    fetchPdfUrl();
  }

  Future<void> fetchPdfUrl() async {
    try {
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('pdffiles/${widget.pdfName}.pdf')
          .getDownloadURL();

      setState(() {
        pdfUrl = downloadURL;
      });
    } catch (e) {
      print("Error fetching PDF URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pdfName!),
      ),
      body: pdfUrl.isNotEmpty
          ? SfPdfViewer.network(
              pdfUrl,
              canShowPaginationDialog: true,
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

List<Map<String, String>> pdfData = [
  {"name": "20sw002", "image": "assets/pdf1.png"},
  {"name": "Sentence-Correction", "image": "assets/pdf2.png"},
  {"name": "PDF 3", "image": "assets/pdf3.png"},
];
