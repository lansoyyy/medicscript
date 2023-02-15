import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mediscript/screens/med_screen.dart';
import 'package:mediscript/utils/colors.dart';
import 'package:mediscript/widgets/text_widget.dart';

class ResultScreen extends StatelessWidget {
  List<String> meds = [];

  ResultScreen({required this.meds});
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primary,
        title: TextBold(text: 'MediScript', fontSize: 18, color: Colors.white),
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
      body: GridView.builder(
          itemCount: meds.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MedScreen()));
                },
                child: Card(
                  elevation: 3,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            image: AssetImage('assets/images/logo.jpg'),
                            fit: BoxFit.cover)),
                    height: 1000,
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration:
                              const BoxDecoration(color: Colors.black54),
                          child: ListTile(
                            title: TextBold(
                                text: 'Medicine Name',
                                fontSize: 12,
                                color: Colors.white),
                            trailing: TextRegular(
                                text: '1/30/2023',
                                fontSize: 12,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          })),
    );
  }
}
