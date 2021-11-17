import 'package:anafi_parrot_website/views/home/home_content_desktop.dart';
import 'package:anafi_parrot_website/views/home/home_content_mobile.dart';
import 'package:anafi_parrot_website/widgets/centered_view/centered_view.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CenteredView(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ScreenTypeLayout(
                mobile: const HomeContentMobile(),
                desktop: const HomeContentDesktop(),
              ))
            ],
          ),
        ));
  }
}
