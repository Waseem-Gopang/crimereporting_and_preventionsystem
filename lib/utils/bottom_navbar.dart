import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int defaultSelectedIndex;

  const CustomBottomNavigationBar(
      {Key? key, required this.defaultSelectedIndex})
      : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int _selectedIndex;
  final List<IconData> _iconList = [
    Icons.map,
    Icons.local_police_outlined,
    Icons.home,
    Icons.remove_red_eye_outlined,
    Icons.contact_emergency_outlined,
  ];
  final List<String> _textList = [
    'Crime Locations',
    'Crime Report',
    'Home',
    'Awareness',
    'Emergency Off.',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: _selectedIndex,
      height: 75.0,
      items: List.generate(_iconList.length, (index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _iconList[index],
              size: 30,
              color:
                  _selectedIndex == index ? Colors.red.shade900 : Colors.grey,
            ),
            Text(
              _textList[index],
              style: TextStyle(
                fontSize: 10,
                color:
                    _selectedIndex == index ? Colors.red.shade900 : Colors.grey,
              ),
            ),
          ],
        );
      }),
      color: Colors.red.shade100,
      buttonBackgroundColor: Colors.yellow,
      backgroundColor: Colors.white,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        navigateBottom(index);
      },
      letIndexChange: (index) => true,
    );
  }

  void navigateBottom(int index) {
    String route;
    switch (index) {
      case 0:
        route = "/crimeAlert";
        break;
      case 1:
        route = "/crimeReport";
        break;
      case 2:
        route = "/home";
        break;
      case 3:
        route = "/awareness";
        break;
      case 4:
        route = "/emergencyOfficial";
        break;
      default:
        return;
    }
    Navigator.pushReplacementNamed(context, route);
  }
}
