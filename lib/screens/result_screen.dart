import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:mediscript/utils/colors.dart';
import 'package:mediscript/widgets/text_widget.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ResultScreen extends StatefulWidget {
  List<String> meds = [];

  ResultScreen({required this.meds});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Future<bool> linkExists(String url) async {
    bool containsNumbers = RegExp(r'\d').hasMatch(url);
    if (containsNumbers) {
      return false;
    } else {
      final response = await http
          .head(Uri.parse('https://www.drugs.com/${url.trim()}.html'));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
  }

  final db = Localstore.instance;

  @override
  Widget build(BuildContext context) {
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
          itemCount: widget.meds.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: ((context, index) {
            return FutureBuilder<bool>(
                future: linkExists(widget.meds[index].toLowerCase()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(); // Show empty space while waiting for the future
                  } else if (snapshot.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    bool exists = snapshot.data!;

                    if (exists == true) {
                      final id = db.collection('History').doc().id;

                      db.collection('History').doc(id).set({
                        'name': widget.meds[index],
                        'link':
                            'https://www.drugs.com/${widget.meds[index].toLowerCase().trim()}.html'
                      });
                    }

                    return exists == true
                        ? Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () async {
                                if (await canLaunch(
                                    'https://www.drugs.com/${widget.meds[index].toLowerCase().trim()}.html')) {
                                  await launch(
                                      'https://www.drugs.com/${widget.meds[index].toLowerCase().trim()}.html');
                                } else {
                                  throw 'Could not launch https://www.drugs.com/${widget.meds[index].toLowerCase().trim()}.html';
                                }
                              },
                              child: Card(
                                elevation: 3,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/logo.jpg'),
                                          fit: BoxFit.cover)),
                                  height: 1000,
                                  width: 200,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                            color: Colors.black54),
                                        child: ListTile(
                                          title: TextBold(
                                              text: widget.meds[index],
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox();
                  }
                });
          })),
    );
  }
}
