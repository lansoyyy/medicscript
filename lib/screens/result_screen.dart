import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mediscript/utils/colors.dart';
import 'package:mediscript/widgets/text_widget.dart';
import 'package:http/http.dart' as http;
import 'package:mediscript/widgets/webview.dart';

class ResultScreen extends StatelessWidget {
  Future<bool> linkExists(String url) async {
    final thisUrl = url;

    final response = await http.head(Uri.parse(thisUrl));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

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
            return linkExists(
                        'https://www.drugs.com/${meds[index].toLowerCase()}.html') ==
                    true
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WebviewWidget(
                                link:
                                    'https://www.drugs.com/${meds[index].toLowerCase()}.html')));
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
          })),
    );
  }
}
