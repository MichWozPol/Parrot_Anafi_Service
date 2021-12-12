import 'package:anafi_parrot_website/widgets/call_to_action/call_to_action.dart';
import 'package:anafi_parrot_website/widgets/website_details/website_details.dart';
import 'package:flutter/material.dart';

class HomeContentMobile extends StatelessWidget {
  final List? state;
  HomeContentMobile(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Expanded(child: WebsiteDetails()),
        CallToAction(state: state)
      ],
    );
  }
}
