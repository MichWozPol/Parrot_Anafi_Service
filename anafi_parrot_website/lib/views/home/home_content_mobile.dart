import 'package:anafi_parrot_website/widgets/call_to_action/call_to_action.dart';
import 'package:anafi_parrot_website/widgets/website_details/website_details.dart';
import 'package:flutter/material.dart';

class HomeContentMobile extends StatelessWidget {
  const HomeContentMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Expanded(child: WebsiteDetails()),
        CallToAction(title: 'Enter Live View')
      ],
    );
  }
}
