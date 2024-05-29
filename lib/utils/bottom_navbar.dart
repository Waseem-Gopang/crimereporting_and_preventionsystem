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

  final List<Color> _iconColors = [
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
  ];

  final List<Color> _selectedIconColors = [
    Colors.red,
    Colors.red,
    Colors.red,
    Colors.red,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultSelectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    navigateBottom(index);
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
        route = "/emergency Official";
        break;
      default:
        return;
    }
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: List.generate(_iconList.length, (index) {
            return BottomNavigationBarItem(
              icon: Icon(
                _iconList[index],
                color: _iconColors[index],
              ),
              activeIcon: Icon(
                _iconList[index],
                color: _selectedIconColors[index],
              ),
              label: _textList[index],
              backgroundColor: Colors.white,
            );
          }),
          selectedItemColor: Colors.red,
          unselectedItemColor: _iconColors[_selectedIndex],
          type: BottomNavigationBarType.shifting,
          elevation: 2,
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
