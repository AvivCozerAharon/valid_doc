import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:valid_doc/model/model.dart';
import 'package:valid_doc/prefabs/buttons.dart';
import 'package:valid_doc/prefabs/style.dart';
import 'package:valid_doc/view/N_doc/doc_type.dart';
import '../../controller/nav_controller.dart';
import '../../model/data.dart';
import '../../prefabs/widget.dart';

class Doc_who extends StatefulWidget {
  @override
  Doc_who_State createState() => Doc_who_State();
}
final TextController = TextEditingController();

class Doc_who_State extends State<Doc_who> {
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
                child: const FittedBox(
                  fit: BoxFit.cover,
                  child: Text(
                    'A quem pertece o documento?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: Style.fontTitle,
                        fontSize: 36,
                        color: Style.secondColor),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
               TextField(
                controller: TextController,
                maxLength: 10,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Style.secondColor
                    ),
                  ),),
                  style: const TextStyle(
                  color: Style.secondColor,
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet:
          Button.next(onPressed: (){
            if (_storage.get("DOCUMENTS") == null) {
            } else {
              db.loadData();
            }

            switch(Model.Doc_type){
              case 'passport':
                Model.Doc_name = 'Passporte ${Model.Doc_country} ${TextController.text}';
                break;
              case 'id':
                Model.Doc_name = 'Identidade ${Model.Doc_country} ${TextController.text}';
                break;
              case 'visa':
                Model.Doc_name = 'VISA ${TextController.text}';
                break;
              case 'car_id':
                Model.Doc_name = 'Carteira de Motorista ${Model.Doc_country} ${TextController.text}';
                break;

            }
            db.DocumentsList.add([Model.Doc_name,Model.Doc_type,Model.Doc_country,Model.Doc_val]);
            TextController.clear();
            db.updateData();
            Model.clear();

            Navigation.home(context);
          }, text: 'Continuar', context: context),
    );
  }
}
