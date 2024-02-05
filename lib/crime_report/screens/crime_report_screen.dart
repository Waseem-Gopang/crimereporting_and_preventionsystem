import 'dart:convert';
import 'package:crimereporting_and_preventionsystem/service/api.dart';
import 'package:crimereporting_and_preventionsystem/utils/bottom_navbar.dart';
import 'package:crimereporting_and_preventionsystem/utils/custom_widget.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/theme.dart';
import 'package:google_maps_webservice/places.dart';

import '../models/crime_list.dart';
import 'package:http/http.dart' as http;

class CrimeReportScreen extends StatefulWidget {
  const CrimeReportScreen({Key? key}) : super(key: key);

  @override
  State<CrimeReportScreen> createState() => _CrimeReportScreenState();
}

const key = 'AIzaSyCgHCbmvovZvbTqg-DUBRWUm8HVJfVfXsY';
bool isChecked = false;

class _CrimeReportScreenState extends State<CrimeReportScreen> {
  final _formKey = GlobalKey<FormState>();

  bool haveFile = false;

  String iNo = "";
  String email = "";
  String mobileNo = "";

  String evidenceList = "";
  String addDetails = "";

  String? formattedDate;

  String? type;
  final Mode _mode = Mode.overlay;

  String? location;
  double? lng;
  double? lat;

  String? description;

  DateTime? pickedDate;
  TextEditingController dateCtl = TextEditingController();

  TimeOfDay? pickedTime;
  TextEditingController timeCtl = TextEditingController();

  List selectedFiles = [];

  void selectFiles() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'mp4', 'jpeg'],
        allowMultiple: true);
    if (result == null) return;

    selectedFiles = result.files;

    setState(() {
      haveFile = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Crime Report'),
      body: ListView(children: [
        SafeArea(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getLocationField(),
                  getTextField(
                      hint: 'Enter your CNIC No.',
                      suffixIcon: const Icon(
                        Icons.badge_outlined,
                        color: Colors.red,
                      ),
                      valError: 'Please enter your Cnic no.',
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please enter your CNIC No.";
                        } else if ((val.isNotEmpty) &&
                            !RegExp(r'^\d{5}-\d{7}-\d{1}$').hasMatch(val)) {
                          return "Enter a valid Cnic No. with dashes";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          iNo = value;
                        });
                      }),
                  getTextField(
                      hint: 'Enter your email',
                      suffixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.red,
                      ),
                      valError: 'Please enter your Email',
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter your email';
                        } else if ((val.isNotEmpty) &&
                            !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                .hasMatch(val)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      }),
                  getTextField(
                    hint: 'Enter your Mobile number',
                    suffixIcon: const Icon(
                      Icons.phone,
                      color: Colors.red,
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter your mobile number";
                      } else if ((val.isNotEmpty) &&
                          !RegExp(r'^\92[3456789]\d{9}$').hasMatch(val)) {
                        return "Enter a valid mobile number like 923001283753";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        mobileNo = value;
                      });
                    },
                  ),
                  getDateTimeFields(),
                  selectCrimeTypeField(),
                  getCrimeDescField(),
                  getCustomButton(
                      text: "Add Evidence Media / Files",
                      background: Colors.black,
                      fontSize: 15,
                      padding: 45,
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {
                        selectFiles();
                      }),
                  getShowSelectedImages(),
                  getSubmitCancelButtonBar()
                ],
              ),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: const CustomBottomNavigationBar(
        defaultSelectedIndex: 1,
      ),
    );
  }

  getLocationField() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: OutlinedButton(
          onPressed: _handlePressButton,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.grey.shade900))),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.red,
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 250,
                height: 18,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Text(
                      location ?? "Enter the Location of the Incident",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: key,
        language: 'en',
        mode: _mode,
        strictbounds: false,
        types: [""],
        logo: Container(
          height: 1,
        ),
        decoration: InputDecoration(
            hintText: 'Enter the Location of the Incident',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white))),
        components: [
          Component(Component.country, "pk"),
          Component(Component.country, "usa"),
          Component(Component.country, "my")
        ]);
    if (p != null) {
      displayPrediction(p);
      setState(() {
        location = "${p.terms[0].value} ${p.terms[1].value}";
      });
    } else {
      print("p is giving null value");
    }
  }

  Future<void> displayPrediction(Prediction p) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: key, apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    lat = detail.result.geometry!.location.lat;
    lng = detail.result.geometry!.location.lng;
  }

  getDateTimeFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          width: 175,
          decoration: ThemeHelper().inputBoxDecorationShaddow(),
          child: TextFormField(
            controller: dateCtl,
            readOnly: true,
            decoration: ThemeHelper().textInputDecoReport('Select Date',
                const Icon(Icons.calendar_today, color: Colors.red)),
            onTap: () async {
              pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.red, // <-- SEE HERE
                        onPrimary: Colors.white, // <-- SEE HERE
                        onSurface: Colors.grey[900]!, // <-- SEE HERE
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red, // button text color
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate!);
              dateCtl.text = formattedDate!;
            },
            validator: (val) {
              if (val!.isEmpty) {
                return "Please select a date";
              }
              return null;
            },
          ),
        ),
        Container(
          width: 155,
          padding: const EdgeInsets.only(bottom: 10),
          decoration: ThemeHelper().inputBoxDecorationShaddow(),
          child: TextFormField(
            controller: timeCtl,
            readOnly: true,
            decoration: ThemeHelper().textInputDecoReport(
                'Select Time',
                const Icon(
                  Icons.watch_later_outlined,
                  color: Colors.red,
                )),
            onTap: () async {
              pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.red, // <-- SEE HERE
                        onPrimary: Colors.white, // <-- SEE HERE
                        onSurface: Colors.grey[900]!, // <-- SEE HERE
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red, // button text color
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              timeCtl.text = formatTimeOfDay(pickedTime!);
            },
            validator: (val) {
              if (val!.isEmpty) {
                return "Please enter a time";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  getTextField(
      {String? hint,
      String? valError,
      Function(String)? onChanged,
      Icon? suffixIcon,
      String? Function(String?)? validator}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: TextFormField(
        decoration: ThemeHelper().textInputDecoReport(hint!, suffixIcon),
        onChanged: onChanged,
        validator: validator ??
            (val) {
              if (val!.isEmpty) {
                return valError;
              }
              return null;
            },
      ),
    );
  }

  selectCrimeTypeField() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
          width: 400,
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              isExpanded: true,
              hint: const Text("Select Type of Crime"),
              items: crimes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              validator: (value) {
                if (type == null) {
                  return "Please select the type of Crime";
                }
                return null;
              },
              onChanged: (value) {
                type = value.toString();
              },
            ),
          )),
    );
  }

  getCrimeDescField() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: TextFormField(
        minLines: 3,
        maxLines: 5,
        keyboardType: TextInputType.multiline,
        decoration: ThemeHelper()
            .textInputDecoReport("Enter the description of the incident"),
        onChanged: (val) {
          setState(() {
            description = val;
          });
        },
        validator: (val) {
          if (val!.isEmpty) {
            return "Description of the incident is required";
          }
          return null;
        },
      ),
    );
  }

  getShowSelectedImages() {
    return Visibility(
      visible: haveFile,
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
            height: 150,
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    itemCount: selectedFiles.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      final extension =
                          selectedFiles[index].extension ?? 'none';
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade500,
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Text(
                              '.$extension',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                          Text(selectedFiles[index].name)
                        ],
                      );
                    }))),
      ),
    );
  }

  Future sendEmail(String id) async {
    //final user = Global.instance.user!;
    const serviceId = 'service_xsnm6c1';
    const templateId = 'template_up4q9z5';
    const userId = 'I0cSQ5dcivRQxheSu';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'subject': '$id - $type Case at $formattedDate',
          // 'user_contact': user.mobileNo,
          // 'user_name': user.fName,
          // 'user_email': user.email,
          // 'address': '${user.address}, ${user.zipcode}, ${user.city}, '
          //     '${user.state}, ${user.country}',
          'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'crime': type,
          'in_date': formattedDate,
          'in_time': formatTimeOfDay(pickedTime!),
          'in_location': location,
          'description': description,
          'evidence_list': evidenceList,
          'add_details': addDetails,
        }
      }),
    );
    print(response.body);
  }

  getSubmitCancelButtonBar() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      getCustomButton(
          text: "Cancel",
          padding: 45,
          background: Colors.black,
          fontSize: 16,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/crimeReport');
          }),
      getCustomButton(
          text: "Submit",
          padding: 45,
          background: Colors.red.shade900,
          fontSize: 16,
          onPressed: () async {
            showDialog(
                context: context,
                builder: ((context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                        title: const Center(child: Text("Terms & Conditions")),
                        insetPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        titleTextStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        scrollable: true,
                        content: const Wrap(
                          runAlignment: WrapAlignment.center,
                          runSpacing: 10,
                          children: [
                            Text(
                              "User Agreement",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Thank you for using our Crime Reporting And Prevention App! By submitting this report, you agree to the following terms:",
                              style:
                                  TextStyle(fontSize: 15, fontFamily: 'Roboto'),
                            ),
                            Text(
                              "1. Provide accurate information.",
                              style:
                                  TextStyle(fontSize: 15, fontFamily: 'Roboto'),
                            ),
                            Text(
                              "2. Report only genuine incidents.",
                              style:
                                  TextStyle(fontSize: 15, fontFamily: 'Roboto'),
                            ),
                            Text(
                              "3. Do not submit false or misleading reports.",
                              style:
                                  TextStyle(fontSize: 15, fontFamily: 'Roboto'),
                            ),
                            Text(
                              "Misuse of this reporting feature may result in legal actions and account penalties under Pakistani jurisdiction.",
                              strutStyle: StrutStyle(
                                fontFamily: 'Roboto',
                                height: 1.5,
                              ),
                              style: TextStyle(fontFamily: 'Roboto'),
                            ),
                          ],
                        ),
                        actions: [
                          Wrap(runSpacing: 2, children: [
                            Row(
                              children: [
                                Checkbox(
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                    value: isChecked,
                                    onChanged: ((bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    })),
                                const Text(
                                  'I agree with the Terms and Conditions',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Center(
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    onPressed: (() {
                                      if (isChecked == false) {
                                        Get.snackbar("Error",
                                            "Please agree to the terms and conditions",
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                            duration:
                                                const Duration(seconds: 3));
                                      } else {
                                        Navigator.of(context).pop(AlertDialog);
                                        if (_formKey.currentState!.validate()) {
                                          // String uID = Global.instance.user!.uId!;

                                          DatabaseReference reportRef =
                                              FirebaseDatabase.instance
                                                  .ref()
                                                  .child('reports');

                                          String reportID =
                                              reportRef.push().key!;

                                          //upload new report data to database
                                          reportRef.child(reportID).set({
                                            //'location': location,
                                            // 'longitude': lng!.toStringAsFixed(6),
                                            //'userID': uID,
                                            //'latitude': lat!.toStringAsFixed(6),
                                            'Cnic No': iNo,
                                            'email': email,
                                            'mobile No': mobileNo,
                                            'date': formattedDate,
                                            'time':
                                                formatTimeOfDay(pickedTime!),
                                            'type': type,
                                            'descr': description,
                                          });

                                          //add media files list if have any in the report
                                          if (selectedFiles.isNotEmpty) {
                                            evidenceList =
                                                "The following are links to evidence media attached:";
                                            DatabaseReference mediaRef =
                                                reportRef
                                                    .child(reportID)
                                                    .child('evidences');
                                            var url;
                                            int index = 1;
                                            selectedFiles.forEach((file) async {
                                              url =
                                                  await uploadFile(file: file!);
                                              mediaRef
                                                  .child(index.toString())
                                                  .set({'file': url});
                                              evidenceList +=
                                                  "\n$index File link: $url";
                                              index++;
                                            });
                                          }

                                          //send email to official services and auto-reply to user
                                          sendEmail(reportID).whenComplete(() {
                                            Get.snackbar("Congratulation!",
                                                "Report Submitted and Emailed to Respected Officials Successfully",
                                                duration:
                                                    const Duration(seconds: 5),
                                                backgroundColor: Colors.green,
                                                colorText: Colors.white);
                                            Navigator.pushReplacementNamed(
                                                context, '/crimeReport');
                                          });
                                        }
                                      }
                                    }),
                                    child: const Text(
                                      "Continue",
                                      style: TextStyle(color: Colors.white),
                                    )))
                          ])
                        ]);
                  });
                }));
          })
    ]);
  }
}
