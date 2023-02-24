import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:mediscript/widgets/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/colors.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final db = Localstore.instance;

  @override
  void initState() {
    super.initState();
    getData();
  }

  var hasLoaded = false;

  List<String> names = [];
  List<String> links = [];

  getData() async {
    final items = await db.collection('History').get();

    if (items != null) {
      items.forEach((key, value) {
        names.add(value['name']);
        links.add(value['link']);
      });
    }

    setState(() {
      hasLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return hasLoaded
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: primary,
              title:
                  TextBold(text: 'History', fontSize: 18, color: Colors.white),
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
                itemCount: names.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (await canLaunch(links[index])) {
                          await launch(links[index]);
                        } else {
                          throw 'Could not launch ${links[index]}';
                        }
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
                                      text: names[index],
                                      fontSize: 15,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })))
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
