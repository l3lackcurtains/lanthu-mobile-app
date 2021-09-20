import 'package:flutter/material.dart';
import 'package:lanthu_bot/pages/add_token.dart';
import 'package:lanthu_bot/pages/add_trade.dart';
import 'package:lanthu_bot/pages/tokens.dart';
import 'package:lanthu_bot/pages/trades.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lanthu'),
      ),
      body: Container(
        child: [
          const Trades(),
          const Tokens(),
        ].elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedIndex == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return const AddTrade();
            })).then((value) => setState(() {}));
          } else {
            Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const AddToken();
                    })).then((value) => setState(() {}));
          }
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: "Trading",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: "Tokens",
            ),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.deepPurple,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed),
    );
  }
}
