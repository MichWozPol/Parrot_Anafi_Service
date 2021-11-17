import 'package:anafi_parrot_website/widgets/call_to_action/call_to_action_mobile.dart';
import 'package:anafi_parrot_website/widgets/call_to_action/call_to_action_tablet_desktop.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:anafi_parrot_website/extensions/hover_extensions.dart';

class CallToAction extends StatelessWidget {
  final String? title;
  const CallToAction({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: CallToActionMobile(title: title),
      desktop: CallToActionTabletDesktop(title: title),
    ).showCursorOnHover.moveUpOnHover;
  }
}
