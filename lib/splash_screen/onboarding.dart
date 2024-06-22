import 'package:assil_app/splash_screen/onboarding_page.dart';
import 'package:flutter/material.dart';

class onboard extends StatefulWidget {
  @override
  State<onboard> createState() => _onboardState();
}

class _onboardState extends State<onboard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(
        pages: [
          OnboardingPageModel(
            title: 'The Ultimate Kindergarten Management Tool',
            description: '',
            image: 'assets/page1.png',
            bgColor: Colors.indigo,
          ),
          OnboardingPageModel(
            title: ' Daily Tasks, Tracking, and Lesson Planning',
            description: '',
            image: 'assets/page2.png',
            bgColor: const Color(0xff1eb090),
          ),
          OnboardingPageModel(
            title: 'Stay Connected, Stay Informed with Rawdati',
            description: '',
            image: 'assets/page3.png',
            bgColor: const Color(0xfffeae4f),
          ),
          // OnboardingPageModel(
          //   title: 'Follow creators',
          //   description: 'Follow your favourite creators to stay in the loop.',
          //   image: 'assets/page1.png',
          //   bgColor: Colors.purple,
          // ),
        ],
      ),
    );
  }
}
