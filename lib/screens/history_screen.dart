import 'package:flutter/material.dart';
import 'package:mediscript/widgets/text_widget.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../utils/colors.dart';

class HistoryScreen extends StatelessWidget {
  Future<bool> linkExists(String url) async {
    final thisUrl = url;

    final response =
        await http.head(Uri.parse('https://www.drugs.com/${url.trim()}.html'));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  List<String> meds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primary,
          title:
              TextBold(text: 'Name of Med', fontSize: 18, color: Colors.white),
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
              return FutureBuilder<bool>(
                  future: linkExists(meds[index].toLowerCase()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(); // Show empty space while waiting for the future
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      bool exists = snapshot.data!;

                      return exists == true
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () async {
                                  if (await canLaunch(
                                      'https://www.drugs.com/${meds[index].toLowerCase().trim()}.html')) {
                                    await launch(
                                        'https://www.drugs.com/${meds[index].toLowerCase().trim()}.html');
                                  } else {
                                    throw 'Could not launch https://www.drugs.com/${meds[index].toLowerCase().trim()}.html';
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
                                                text: meds[index],
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
            })));
  }
}
