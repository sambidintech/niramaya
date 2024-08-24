import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_clone/presentation/auth/pages/signup_or_signin.dart';
import 'package:spotify_clone/presentation/song/page/song_page.dart';
// import 'package:spotify_clone/presentation/choose_mode/pages/choose_mode.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
// import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
// import 'package:spotify_clone/core/config/assets/app_images.dart';
// import 'package:spotify_clone/core/config/assets/app_vectors.dart';
// import 'package:spotify_clone/core/config/theme/app_color.dart';

void main(){
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const MeditationDashboard(),
    const MeditationHomePage(),
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Meditate',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MeditationDashboard extends StatelessWidget {
  const MeditationDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Drawer(
        elevation: 0,
        child: ListView(
          children: [
            ListTile(
              title: const Text('Log Out'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupOrSignInPage()),
                );
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text('Hello Sambid!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white
                  )),
                  subtitle: Text('Good Morning', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white54
                  )),

                ),
                const SizedBox(height: 30)
              ],
            ),
          ),

          Container(
          color: Theme.of(context).primaryColorDark,
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),


            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 40,
              mainAxisSpacing: 30,
              children: [
                _buildDashboardItem(Icons.self_improvement, 'Meditation',Colors.deepOrange,context,const MeditationHomePage()),
                _buildDashboardItem(Icons.music_note, 'Music',Colors.green,context,const SongPage()),
                _buildDashboardItem(Icons.nature, 'Nature Sounds',Colors.purple,context,const MeditationHomePage()),
                _buildDashboardItem(Icons.book, 'Guided Sessions',Colors.brown,context,const MeditationHomePage()),
                _buildDashboardItem(Icons.bar_chart, 'Progress',Colors.teal,context,const MeditationHomePage()),
                _buildDashboardItem(Icons.person, 'Profile',Colors.pinkAccent,context,const MeditationHomePage()),
              ],
            ),
          ),
        ),]
      ),
    );
  }

  Widget _buildDashboardItem(IconData icon, String title, Color background, BuildContext context, Widget targetPage){
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            Navigator.push(context, MaterialPageRoute(builder: (context)=>targetPage)) as Route<Object?>);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 5),
              spreadRadius: 2,
              blurRadius: 4
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black, size: 50, ),
            ),
            const SizedBox(height: 10),
            Text(title.toUpperCase(), style: const TextStyle(fontSize: 8)),
      ],
      ),
      ),
    );
  }
}

class MeditationHomePage extends StatefulWidget {
  const MeditationHomePage({super.key});

  @override
  _MeditationHomePageState createState() => _MeditationHomePageState();
}

class _MeditationHomePageState extends State<MeditationHomePage> {
  Timer? _timer;
  int _start = 300; // 5 minutes in seconds
  bool _isMeditating = false;

  void startTimer() {
    setState(() {
      _isMeditating = true;
    });
    const oneSec =  Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            _isMeditating = false;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void resetTimer() {
    setState(() {
      _start = 300;
      _isMeditating = false;
      _timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation Timer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Time to Meditate',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              '${(_start ~/ 60).toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: _start / 300,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isMeditating ? null : startTimer,
              child: const Text('Start Meditation'),
            ),
            ElevatedButton(
              onPressed: resetTimer,
              child: const Text('Reset'),
            ),
            const SizedBox(height: 20),
            const Text(
              '“Meditation is a journey to the center of your being.”',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}