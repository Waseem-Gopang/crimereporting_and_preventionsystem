import 'package:crimereporting_and_preventionsystem/utils/bottom_navbar.dart';
import 'package:crimereporting_and_preventionsystem/utils/custom_widget.dart';
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
      appBar: customAppBar(title: "Awareness Laws"),
      body: buildGridView(),
      bottomNavigationBar:
          const CustomBottomNavigationBar(defaultSelectedIndex: 3),
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
                height: 100,
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
          .child('LegalDocuments/${widget.pdfName}.pdf')
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
      appBar: customAppBar(
        title: widget.pdfName!,
      ),
      body: pdfUrl.isNotEmpty
          ? SfPdfViewer.network(
              pdfUrl,
              canShowPaginationDialog: true,
              canShowScrollHead: true,
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

List<Map<String, String>> pdfData = [
  {"name": "Pakistan Penal Code", "image": "assets/LegalDocuments/ppc.jpg"},
  {
    "name": "Anti-Terrorism-Act-1997",
    "image": "assets/LegalDocuments/Anti-Terrorism Act.png"
  },
  {
    "name": "Prevention of Electronic crimes Act",
    "image": "assets/LegalDocuments/Prevention of Electronic crimes Act.jpg"
  },
  {
    "name": "Prevention of Trafficking in persons Act",
    "image": "assets/LegalDocuments/trafficking.png"
  },
  {
    "name": "Police Laws and Criminal Procedure",
    "image": "assets/LegalDocuments/police laws and criminal procedure.jpg"
  },
  {
    "name": "Code of criminal procedure 1898",
    "image": "assets/LegalDocuments/Code of criminal procedure.jpg"
  }
];
