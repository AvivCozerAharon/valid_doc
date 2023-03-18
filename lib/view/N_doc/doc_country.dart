import 'package:flutter/material.dart';
import 'package:valid_doc/model/model.dart';
import 'package:valid_doc/prefabs/buttons.dart';
import 'package:valid_doc/prefabs/style.dart';

import '../../controller/nav_controller.dart';
import '../../prefabs/widget.dart';

class Doc_country extends StatefulWidget {
  @override
  Doc_country_State createState() => Doc_country_State();
}

List country = ['Brazil', 'USA', 'Canada','Mexico','Israel','England', 'Germany','Spain', 'France','Portugal','Poland','Italy','Argentina','Chile','Uruguay','Colombia','Paraguay','Peru','Japan','China','Australia','Russia'];
String SelectedCountry = '';

class Doc_country_State extends State<Doc_country> {
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
                child:  IconButton(
                    onPressed: (){
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
                    'Qual país do seu documento?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: Style.fontTitle,
                        fontSize: 36,
                        color: Style.secondColor),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Widgets.country_picker((index){
                  setState(() {
                    if(index == 1){
                      SelectedCountry = 'Brazil';

                    }
                    SelectedCountry = country[index];

                  });
                }, country, context),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Button.next(onPressed: (){
        if(SelectedCountry == ''){
          Model.Doc_country = 'Brazil';

        }else{
          Model.Doc_country = SelectedCountry;
        }
        Navigation.doc_date(context);
      }, text: 'Continuar', context: context),
    );
  }
}
