import 'package:crimereporting_and_preventionsystem/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// AppBar customAppBar(
//     {String? title,
//     IconButton? iconButton,
//     Color? textColor,
//     PreferredSizeWidget? bottomBar}) {
//   return AppBar(
//       leading: iconButton,
//       title: Center(
//           child: Text(title!,
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 24))),
//       backgroundColor: Colors.redAccent,
//       iconTheme: const IconThemeData(
//         color: Colors.white, //change your color here
//       ),
//       bottom: bottomBar);
// }

// AppBar customAppBarAction(
//     {String? title,
//     IconButton? iconButton,
//     Color? textColor,
//     PreferredSizeWidget? bottomBar,
//     Widget? actions}) {
//   return AppBar(
//       leading: iconButton,
//       title: Center(
//           child: Text(title!,
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 24))),
//       backgroundColor: Colors.redAccent,
//       iconTheme: const IconThemeData(
//         color: Colors.white, //change your color here
//       ),
//       bottom: bottomBar,
//       actions: [
//         Padding(
//           padding: const EdgeInsets.only(right: 8.0),
//           child: actions ??
//               const IconButton(
//                   icon: Icon(Icons.arrow_left_rounded),
//                   iconSize: 0,
//                   onPressed: null),
//         )
//       ]);
// }
AppBar customAppBar({
  String? title,
  IconButton? iconButton,
  Color? textColor,
  PreferredSizeWidget? bottomBar,
}) {
  return AppBar(
    leading: iconButton,

    title: Center(
      child: Text(title ?? '',
          style: GoogleFonts.satisfy(
              color: textColor, fontSize: 28, fontWeight: FontWeight.w600)),
    ),
    backgroundColor: Colors.redAccent, // changed to a deeper orange color
    iconTheme: const IconThemeData(
      color: Colors.white, //change your color here
    ),
    elevation: 6, // increased elevation for a more prominent app bar
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom:
            Radius.circular(35), // increased radius for a more rounded corner
      ),
    ),
    bottom: bottomBar,
  );
}

AppBar customAppBarAction({
  String? title,
  IconButton? iconButton,
  Color? textColor,
  PreferredSizeWidget? bottomBar,
  Widget? actions,
}) {
  return AppBar(
    leading: iconButton,
    title: Center(
      child: Text(title ?? '',
          style: GoogleFonts.satisfy(
              color: textColor, fontSize: 28, fontWeight: FontWeight.w600)),
    ),
    backgroundColor: Colors.redAccent, // changed to a deeper orange color
    iconTheme: const IconThemeData(
      color: Colors.white, //change your color here
    ),
    elevation: 6, // increased elevation for a more prominent app bar
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom:
            Radius.circular(35), // increased radius for a more rounded corner
      ),
    ),
    bottom: bottomBar,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: actions ??
            const IconButton(
              icon: Icon(Icons.arrow_left_rounded),
              onPressed: null,
            ),
      )
    ],
  );
}

getTextField(
    {String? text,
    String? valError,
    bool? readonly,
    Function(String)? onChanged,
    bool? obscureText,
    String? Function(String?)? validator,
    bool isEdit = false,
    TextInputType? keyboardType,
    int? minLines,
    int? maxLines,
    InputDecoration? decoration}) {
  TextEditingController controller = TextEditingController();
  if (isEdit) {
    controller.text = text!;
  }
  return Container(
    padding: const EdgeInsets.only(bottom: 20),
    decoration: ThemeHelper().inputBoxDecorationShaddow(),
    child: TextFormField(
      controller: isEdit ? controller : null,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      readOnly: readonly ?? false,
      obscureText: obscureText ?? false,
      decoration: decoration,
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
