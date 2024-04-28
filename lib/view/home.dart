import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:valid_doc/controller/nav_controller.dart';
import 'package:valid_doc/model/data.dart';
import 'package:valid_doc/model/model.dart';
import 'package:valid_doc/prefabs/document_tile.dart';
import 'package:valid_doc/prefabs/style.dart';

import '../prefabs/widget.dart';

class Home extends StatefulWidget {
  @override
  Home_State createState() => Home_State();
}

class Home_State extends State<Home> {
  final _storage = Hive.box('storage');
  DocumentDataBase db = DocumentDataBase();

  void initState() {
    // if this is the 1st time ever openin the app, then create default data
    if (_storage.get("DOCUMENTS") == null) {
      print(db.DocumentsList);
    } else {
      // there already exists data
      db.loadData();
    }

    super.initState();
  }

  void infoPage(index) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.firstColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          Widgets.color_subtitle(context);
                        },
                        icon: const Icon(
                          Icons.info_outline,
                          color: Style.secondColor,
                          size: 24,
                        )),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          Model.clear();
                          setState(() {
                            Model.Doc_type = '';
                            Model.Doc_country = '';
                            Model.Doc_val = '';
                            Model.Doc_name = '';
                          });
                          Navigation.doc_type(context);
                        },
                        icon: const Icon(
                          Icons.add_circle_outline_rounded,
                          color: Style.secondColor,
                          size: 24,
                        )),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: const FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  'Meus Documentos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: Style.fontTitle,
                      fontSize: 36,
                      color: Style.secondColor),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.0001,
            ),
            if (_storage.get("DOCUMENTS") != null || db.DocumentsList.isNotEmpty)
              Expanded(
                flex: 20,
                child: ListView.builder(
                    itemCount: db.DocumentsList.length,
                    itemBuilder: (context, index) {
                      return DocumentTile(
                        onPressed: () {
                          Navigation.info_home(context);
                          Model.SelectedDoc = DocumentSelected(
                            index: index,
                            name: db.DocumentsList[index][0],
                            type: db.DocumentsList[index][1],
                            country: db.DocumentsList[index][2],
                            val: db.DocumentsList[index][3],
                            number: db.DocumentsList[index][4],
                            notes: db.DocumentsList[index][5],
                          );
                        },
                        name: db.DocumentsList[index][0],
                        type: db.DocumentsList[index][1],
                        country: db.DocumentsList[index][2],
                        val: db.DocumentsList[index][3],
                      );
                    }),
              ),
            if (_storage.get("DOCUMENTS") == null || db.DocumentsList.isEmpty)
              const Expanded(
                flex: 20,
                child: Text(
                  'Voce nâo tem documentos cadastrados! :(',
                  style: TextStyle(color: Style.secondColor),
                ),
              )
          ],
        ),
      ),
    );
  }
}
