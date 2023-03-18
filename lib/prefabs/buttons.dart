import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:valid_doc/prefabs/style.dart';

import '../controller/nav_controller.dart';
import '../model/model.dart';

class Button {
  static Widget button_doc_type({type, context}) {
    return TextButton(
      onPressed: (){
        if (type == 'visa'){
          Model.Doc_type = type;
          Model.Doc_country = 'USA';
          Navigation.doc_date(context);

        }else{
          Model.Doc_type = type;
          Navigation.doc_country(context);

        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.32,
        height: MediaQuery.of(context).size.height * 0.17,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(15.0) //                 <--- border radius here
              ),
          color: Style.thirdColor,
        ),
        alignment: Alignment.center,
        child: Image.asset(
          'files/${type}.png',
          width: 75,
          height: 75,
        ),
      ),
    );

  }
  static Widget underline({@required onPressed,text, context}) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text,style: const TextStyle(fontFamily: Style.fontButton,decoration: TextDecoration.underline,color: Style.secondColor)),
    );
}

  static Widget next({@required onPressed, text, context}) {
    return Container(
      decoration: const BoxDecoration(
        color: Style.firstColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Style.firstColor,
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Container(
        margin:
        const EdgeInsets.only(top: 10, left: 50, right: 50, bottom: 10),
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.08,
        child: TextButton(
          onPressed: onPressed,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.06,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(
                  10.0) //                 <--- border radius here
              ),
              color: Colors.black,
            ),
            alignment: Alignment.center,
            child:  Text(
              text,
              style: const TextStyle(
                color: Style.secondColor,
                fontFamily: Style.fontNextButton,
                fontSize: 22,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
        ),
      ),
    );

  }
}