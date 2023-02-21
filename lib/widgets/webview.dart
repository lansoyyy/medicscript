import 'package:flutter/material.dart';

class WebviewWidget extends StatelessWidget {
  late String link = '';

  WebviewWidget({required this.link});

  @override
  Widget build(BuildContext context) {
    return WebviewWidget(
      link: link,
    );
  }
}
