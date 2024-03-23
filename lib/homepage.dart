import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'pages/select_file_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    _goHome();
    // TODO: implement initState
    super.initState();
  }

  void _goHome() async {
    await Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SelectFilePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/start02.jpg'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
