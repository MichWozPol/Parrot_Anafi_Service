import 'package:flutter/material.dart';
import 'package:anafi_parrot_website/views/stream/stream_view.dart';

class CallToActionMobile extends StatelessWidget {
  final List? state;
  const CallToActionMobile({Key? key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _onTap() => Navigator.push(
        context, MaterialPageRoute(builder: (context) => StreamView()));

    return GestureDetector(
      onTap: state![2] ? _onTap : null,
      child: Container(
        height: 60,
        alignment: Alignment.center,
        child: Text(state![0],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            )),
        decoration: BoxDecoration(
            color: state![1], borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
