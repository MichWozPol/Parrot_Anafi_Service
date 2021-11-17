import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class WebsiteDetails extends StatelessWidget {
  const WebsiteDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      var textAlignment =
          sizingInformation.deviceScreenType == DeviceScreenType.desktop
              ? TextAlign.left
              : TextAlign.center;
      double titleSize =
          sizingInformation.deviceScreenType == DeviceScreenType.mobile
              ? 50
              : 60;
      double descriptionSize =
          sizingInformation.deviceScreenType == DeviceScreenType.mobile
              ? 16
              : 21;

      return SizedBox(
          width: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'ANAFI PARROT THERMAL DRONE\nLIVE VIEWER.',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  height: .9,
                  fontSize: titleSize,
                ),
                textAlign: textAlignment,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "On this website you can see the status of ANAFI PARROT THERMAL DRONE currently connected to the server. You can check drone sensors status, battery level, current location on Google Maps and live camera view.",
                style: TextStyle(fontSize: descriptionSize, height: 1.7),
                textAlign: textAlignment,
              )
            ],
          ));
    });
  }
}
