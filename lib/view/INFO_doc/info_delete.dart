import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:valid_doc/model/model.dart';
import 'package:valid_doc/prefabs/buttons.dart';
import 'package:valid_doc/prefabs/style.dart';
import 'package:valid_doc/view/N_doc/doc_type.dart';
import '../../../controller/nav_controller.dart';
import '../../../model/data.dart';
import '../../../prefabs/widget.dart';

class Info_delete extends StatefulWidget {
  @override
  Info_delete_State createState() => Info_delete_State();
}

class Info_delete_State extends State<Info_delete> {
  DocumentDataBase db = DocumentDataBase();
  final _storage = Hive.box('storage');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.firstColor,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () {
                      Navigation.back(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Style.secondColor,
                      size: 24,
                    )),
              ),
              Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                  child: Icon(
                    Icons.delete_forever,
                    color: Style.secondColor,
                    size: MediaQuery.of(context).size.height * 0.24,
                  )),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: const Text(
                  'Voce tem certeza que deseja excluir',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: Style.fontTitle,
                      fontSize: 25,
                      color: Style.secondColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  Model.SelectedDoc.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: Style.fontDelete,
                      fontSize: 25,
                      color: Style.secondColor),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              TextButton(
                onPressed: () {
                  db.loadData();
                  db.DocumentsList.removeAt(Model.SelectedDoc.index);
                  db.updateData();
                  Navigation.home(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.76,
                  height: MediaQuery.of(context).size.height * 0.072,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(
                            10.0) //                 <--- border radius here
                        ),
                    color: Color(0xff2C402E),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Sim',
                    style: TextStyle(
                      color: Style.secondColor,
                      fontFamily: Style.fontNextButton,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),
              TextButton(
                onPressed: () {
                  db.loadData();
                  db.DocumentsList[Model.SelectedDoc.index][4] =
                      '2421321321512';
                  db.DocumentsList[Model.SelectedDoc.index][5] =
                      'Guardado na 3 gaveta do escritorio atras dos livros, lembrar de tirar foto';
                  db.updateData();
                  Navigation.home(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.76,
                  height: MediaQuery.of(context).size.height * 0.072,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(
                            10.0) //                 <--- border radius here
                        ),
                    color: Color(0xff792E2E),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Style.secondColor,
                      fontFamily: Style.fontNextButton,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
