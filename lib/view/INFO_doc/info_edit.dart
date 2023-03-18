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

class Info_edit extends StatefulWidget {
  @override
  Info_edit_State createState() => Info_edit_State();
}
class Info_edit_State extends State<Info_edit> {
  DateTime val = DateFormat('dd/MM/yyyy').parse(Model.SelectedDoc.val);
  String newval = '';
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
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: const Text(
                  'Qual a data de expiração do documento?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: Style.fontTitle,
                      fontSize: 30,
                      color: Style.secondColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child:  Text(
                  'Antiga: ${Model.SelectedDoc.val}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(                     color: Style.secondColor),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Widgets.date_picker((DateTime newtime) {
                  setState(() {
                    val = newtime;
                  });
                }, context,true,val),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Button.next(
          onPressed: () {
            db.loadData();
            newval = '${val.day}/${val.month}/${val.year}';
            db.DocumentsList[Model.SelectedDoc.index][3] = newval;
            db.updateData();
            Navigation.home(
                context);
          },
          text: 'Continuar',
          context: context),
    );
  }
}
