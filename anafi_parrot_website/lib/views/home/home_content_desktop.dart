import 'package:flutter/material.dart';
import 'package:anafi_parrot_website/widgets/call_to_action/call_to_action.dart';
import 'package:anafi_parrot_website/widgets/website_details/website_details.dart';

class HomeContentDesktop extends StatelessWidget {
  const HomeContentDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        WebsiteDetails(),
        Expanded(
          child: Center(child: CallToAction(title: 'Enter Live View')),
        )
      ],
    );
  }
}
