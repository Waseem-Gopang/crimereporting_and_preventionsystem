import 'package:crimereporting_and_preventionsystem/utils/bottom_navbar.dart';
import 'package:crimereporting_and_preventionsystem/utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_fonts/google_fonts.dart';
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
      appBar: customAppBar(title: "Legal Awareness"),
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
            color: Colors.lightGreenAccent.shade700.withOpacity(.6),
            borderRadius: BorderRadius.circular(10),
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
                style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              )
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
    "name": "Anti Terrorism Act",
    "image": "assets/LegalDocuments/Anti-Terrorism Act.png"
  },
  {
    "name": "Electronic Crimes Act",
    "image": "assets/LegalDocuments/Prevention of Electronic crimes Act.jpg"
  },
  {
    "name": "Human Trafficking Act",
    "image": "assets/LegalDocuments/trafficking.png"
  },
  {
    "name": "Police Laws",
    "image": "assets/LegalDocuments/police laws and criminal procedure.jpg"
  },
  {
    "name": "Criminal Procedure",
    "image": "assets/LegalDocuments/Code of criminal procedure.jpg"
  },
  {"name": "Arms Act", "image": "assets/LegalDocuments/Arms Act.jfif"},
  {
    "name": "Corruption Act",
    "image": "assets/LegalDocuments/Corruption Act.jpg"
  },
  {"name": "Customs Act", "image": "assets/LegalDocuments/Customs Act.jfif"},
  {
    "name": "Foreign Exchange Act",
    "image": "assets/LegalDocuments/Foreign Exchange Act.jpg"
  },
  {"name": "Juvenile Act", "image": "assets/LegalDocuments/Juvenile Act.jpg"}
];
