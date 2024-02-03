import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int defaultSelectedIndex;

  const CustomBottomNavigationBar(
      {super.key, required this.defaultSelectedIndex});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List<IconData> iconList = [];
  List<String> textList = [];

  @override
  initState() {
    super.initState();
    iconList = [
      Icons.map,
      Icons.local_police_outlined,
      Icons.home,
      Icons.remove_red_eye_outlined,
      Icons.contact_emergency_outlined,
    ];
    textList = [
      'Crime Locations',
      'Crime Report',
      'Home',
      'Awareness',
      'Emergency Off.'
    ];
    _selectedIndex = widget.defaultSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> navBarItemList = [];

    for (var i = 0; i < iconList.length; i++) {
      navBarItemList.add(buildNavBarItem(iconList[i], i, textList[i]));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: navBarItemList,
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, int index, String label) {
    return GestureDetector(
      onTap: () {
        navigateBottom(index);
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / iconList.length,
        decoration: index == _selectedIndex
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 4, color: Colors.red.shade900),
                ),
              )
            : const BoxDecoration(),
        child: Column(
          children: [
            Icon(
              icon,
              color:
                  index == _selectedIndex ? Colors.red.shade900 : Colors.grey,
            ),
            Text(label,
                style: TextStyle(
                  fontSize: 10,
                  color: index == _selectedIndex
                      ? Colors.red.shade900
                      : Colors.grey,
                )),
          ],
        ),
      ),
    );
  }

  void navigateBottom(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, "/crimeAlert");
        break;
      case 1:
        Navigator.pushReplacementNamed(context, "/crimeReport");
        break;
      case 2:
        Navigator.pushReplacementNamed(context, "/home");
        break;
      case 3:
        Navigator.pushReplacementNamed(context, "/awareness");
        break;
      case 4:
        Navigator.pushReplacementNamed(context, "/emergency Official");
        break;
      case 5:
        break;
    }
  }
}
