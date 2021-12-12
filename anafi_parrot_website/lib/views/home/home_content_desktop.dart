import 'package:flutter/material.dart';
import 'package:anafi_parrot_website/widgets/call_to_action/call_to_action.dart';
import 'package:anafi_parrot_website/widgets/website_details/website_details.dart';

class HomeContentDesktop extends StatelessWidget {
  final List? state;
  HomeContentDesktop(this.state);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const WebsiteDetails(),
        Expanded(
          child: Center(child: CallToAction(state: state)),
        )
      ],
    );
  }
}
