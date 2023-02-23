import 'package:flutter/material.dart';
import 'package:mediscript/widgets/text_widget.dart';

import '../utils/colors.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: TextBold(text: 'Name of Med', fontSize: 18, color: Colors.white),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 7.5, 20, 7.5),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/images/logo.jpg')),
          )
        ],
      ),
    );
  }
}
