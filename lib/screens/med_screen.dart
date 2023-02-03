import 'package:flutter/material.dart';
import 'package:mediscript/utils/colors.dart';
import 'package:mediscript/widgets/text_widget.dart';

class MedScreen extends StatelessWidget {
  const MedScreen({super.key});

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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextBold(text: 'Name of Med', fontSize: 18, color: Colors.black),
            const SizedBox(
              height: 20,
            ),
            TextBold(text: 'Generic Name', fontSize: 14, color: Colors.black),
            const SizedBox(
              height: 5,
            ),
            TextRegular(text: 'Generic Name', fontSize: 10, color: Colors.grey),
            const SizedBox(
              height: 10,
            ),
            TextBold(text: 'Brand Name', fontSize: 14, color: Colors.black),
            const SizedBox(
              height: 5,
            ),
            TextRegular(text: 'Brand Name', fontSize: 10, color: Colors.grey),
            const SizedBox(
              height: 10,
            ),
            TextRegular(
                text:
                    'Sunt culpa elit eu incididunt non fugiat magna occaecat labore eiusmod dolor pariatur sit in.',
                fontSize: 14,
                color: Colors.black),
            const SizedBox(
              height: 5,
            ),
            TextRegular(text: 'Warnings', fontSize: 10, color: Colors.grey),
            const SizedBox(
              height: 10,
            ),
            TextRegular(
                text:
                    'Sunt culpa elit eu incididunt non fugiat magna occaecat labore eiusmod dolor pariatur sit in.',
                fontSize: 14,
                color: Colors.black),
            const SizedBox(
              height: 5,
            ),
            TextRegular(text: 'Purpose', fontSize: 10, color: Colors.grey),
            const SizedBox(
              height: 10,
            ),
            TextRegular(
                text:
                    'Duis ut nulla consequat consequat tempor mollit irure. Lorem exercitation mollit proident pariatur amet. Occaecat deserunt do aliqua adipisicing est anim cupidatat cupidatat eu duis fugiat proident ad aliqua. Laborum laborum ut sit dolor laboris sit dolor esse minim adipisicing elit dolor culpa. Culpa exercitation quis aute aute.',
                fontSize: 14,
                color: Colors.black),
            const SizedBox(
              height: 5,
            ),
            TextRegular(text: 'Description', fontSize: 10, color: Colors.grey),
            const SizedBox(
              height: 10,
            ),
            TextRegular(
                text:
                    'Sunt culpa elit eu incididunt non fugiat magna occaecat labore eiusmod dolor pariatur sit in.',
                fontSize: 14,
                color: Colors.black),
            const SizedBox(
              height: 5,
            ),
            TextRegular(text: 'Dosage', fontSize: 10, color: Colors.grey),
            const SizedBox(
              height: 20,
            ),
            TextBold(text: 'Alternatives', fontSize: 12, color: Colors.black),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SizedBox(
                child: ListView.builder(itemBuilder: ((context, index) {
                  return ListTile(
                    title: TextBold(
                        text: 'Med $index', fontSize: 12, color: Colors.black),
                    trailing: TextButton(
                      onPressed: (() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const MedScreen()));
                      }),
                      child: TextRegular(
                          text: 'More Info', fontSize: 12, color: Colors.grey),
                    ),
                  );
                })),
              ),
            )
          ],
        ),
      ),
    );
  }
}
