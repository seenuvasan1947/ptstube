// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'audio_player.dart';
import 'playlist_page.dart';

class NavbarPage extends StatefulWidget {
  const NavbarPage({super.key});

  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {


 final _pageController = PageController(initialPage: 1);

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 1);

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
     audplayer(),
    // const Page2(),
    const playlistPage(),

   
  ];
  
  @override

  Widget build(BuildContext context) {
    return MaterialApp(

      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          body: PageView(
                   controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                          bottomBarPages.length, (index) => bottomBarPages[index]),
          
                          
          ),
           extendBody: true,
           bottomNavigationBar: (bottomBarPages.length <= maxCount)
                        ? AnimatedNotchBottomBar(
                            /// Provide NotchBottomBarController
                            notchBottomBarController: _controller,
                            color: Colors.white,
                            showLabel: true,
                            notchColor: Colors.pinkAccent,
            
                            /// restart app if you change removeMargins
                            removeMargins: false,
                            bottomBarWidth: 500,
                            durationInMilliSeconds: 300,
                            bottomBarItems: [
                              // const BottomBarItem(
            
                              //   inActiveItem: Icon(
                              //     Icons.star,
                              //     color: Colors.blueGrey,
                              //   ),
                              //   activeItem: Icon(
                              //     Icons.star,
                              //     color: Colors.blueAccent,
                              //   ),
                              //   itemLabel: 'Page',
            
                              // ),
            
                              ///svg example
            
                              BottomBarItem(
                                inActiveItem: const Icon(
                                  Icons.contact_page_rounded,
                                  color: Colors.blueGrey,
                                ),
                                activeItem: const Icon(
                                  Icons.contact_page_rounded,
                                  color: Colors.blueAccent,
                                ),
                                // itemLabel: AppLocale.contact_us.getString(context),
                                // itemLabel: 'contact'
                              ),
                              BottomBarItem(
                                inActiveItem: const Icon(
                                  Icons.home_filled,
                                  color: Colors.blueGrey,
                                ),
                                activeItem: const Icon(
                                  Icons.home_filled,
                                  color: Colors.blueAccent,
                                ),
                                // itemLabel: AppLocale.home_page.getString(context),
                              ),
            
                             
                            ],
                            onTap: (index) {
                              /// perform action on tab change and to update pages you can update pages without pages
                              // log('current selected index $index');
                              _pageController.jumpToPage(index);
                            },
                          )
                        : null,
                  
        ),
      ),
    );
  }
}