import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valid_doc/model/model.dart';
import 'package:valid_doc/prefabs/buttons.dart';
import 'package:valid_doc/prefabs/style.dart';
import '../../controller/nav_controller.dart';
import '../../prefabs/widget.dart';

class Doc_date extends StatefulWidget {
  @override
  Doc_date_State createState() => Doc_date_State();
}

DateTime val = DateTime.now();

class Doc_date_State extends State<Doc_date> {

  @override
  void initState() {
    if(val != DateTime.now()){
      val = DateTime.now();
    }

    super.initState();
  }
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Widgets.date_picker((DateTime newtime) {
                  setState(() {
                    val = newtime;
                  });
                }, context,false,DateTime.now()),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Button.next(
          onPressed: () {
            Model.Doc_val = '${val.day}/${val.month}/${val.year}';
            Navigation.doc_who(context);

          },
          text: 'Continuar',
          context: context),
    );
  }
}
