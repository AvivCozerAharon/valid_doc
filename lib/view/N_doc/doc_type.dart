import 'package:flutter/material.dart';
import 'package:valid_doc/prefabs/buttons.dart';
import 'package:valid_doc/prefabs/style.dart';

import '../../controller/nav_controller.dart';

class Doc_type extends StatefulWidget {
  @override
  Doc_type_State createState() => Doc_type_State();
}

class Doc_type_State extends State<Doc_type> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.firstColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 4),
                child: IconButton(
                  onPressed: () => Navigation.home(context),
                  icon: const Icon(Icons.close,
                      color: Style.secondColor, size: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: const Text(
                    'Qual será o novo documento?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: Style.fontTitle,
                        fontSize: 36,
                        color: Style.secondColor),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // passport usa 'passport' e arquivo passport.png
                  Button.button_doc_type(type: 'passport', context: context),
                  // identidade: tipo salvo como 'id', mas arquivo é 'ident.png'
                  Button.button_doc_type(type: 'id', context: context),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Button.button_doc_type(type: 'car_id', context: context),
                  Button.button_doc_type(type: 'visa', context: context),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Button.underline(
                  onPressed: null,
                  text: 'Não encontrei o tipo do meu documento'),
            ],
          ),
        ),
      ),
    );
  }
}
