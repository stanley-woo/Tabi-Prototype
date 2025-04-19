import 'package:flutter/material.dart';
import 'home_page.dart';

class MainScaffold extends StatefulWidget {
    const MainScaffold({super.key});

    @override
    State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
    int _selectedIndex = 0;

    final List<Widget> _pages = [
        const HomePage(),
        const Center(child: Text('+')),
        const Center(child: Text('Profile')),
    ];

    void _onItemTapped(int index) {
        setState(() {
            _selectedIndex = index;
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: _pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
                items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        label: 'Home',
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.add_circle_outline),
                        label: 'Trip add',
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline),
                        label: 'You',
                    ),
                ],
            )
        );
    }
}