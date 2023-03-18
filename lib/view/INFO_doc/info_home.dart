import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valid_doc/model/model.dart';
import 'package:valid_doc/prefabs/buttons.dart';
import 'package:valid_doc/prefabs/style.dart';
import 'package:valid_doc/view/N_doc/doc_type.dart';
import '../../../controller/nav_controller.dart';
import '../../../model/data.dart';
import '../../../prefabs/widget.dart';

class Info_home extends StatefulWidget {
  @override
  Info_home_State createState() => Info_home_State();
}

String color_text = '';

checkValColor() {
  DateTime checkVal = DateFormat('dd/MM/yyyy').parse(Model.SelectedDoc.val);
  DateTime now = DateTime.now();
  int difference = checkVal.difference(now).inDays;
  int differenceHour = checkVal.difference(now).inHours;
  if (difference >= 365 * 2) {
    color_text = 'Expira em mais de 2 anos';
    return const Color(0xff558459);
  } else if (365 * 2 > difference && difference >= 365) {
    color_text = 'Expira em menos de 2 anos';
    return const Color(0xffDA8130);
  } else if (difference < 365 && difference > 183) {
    color_text = 'Expira em menos de 1 anos';
    return const Color(0xffDA4430);
  } else if (difference <= 183 && difference >= 0 && differenceHour > 0) {
    color_text = 'Expira em menos de 6 meses';
    return const Color(0xffFF0000);
  } else if (difference <= 0) {
    color_text = 'Expirado';
    return const Color(0xff766E6E);
  } else {
    return Colors.black;
  }
}

class Info_home_State extends State<Info_home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.firstColor,
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            decoration: BoxDecoration(
              color: checkValColor(),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            height: MediaQuery.of(context).size.height < 590
                ? MediaQuery.of(context).size.height * 0.45
                : MediaQuery.of(context).size.height > 850
                    ? MediaQuery.of(context).size.height * 0.25
                    : MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
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
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.delete,
                              color: Style.secondColor,
                              size: 24,
                            )),
                      ),
                    ),
                  ],
                ),
                FittedBox(
                  fit: BoxFit.cover,
                  child: Text(
                    Model.SelectedDoc.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: Style.fontButton,
                        fontSize: 19,
                        color: Style.secondColor),
                  ),
                ),
                Text(
                  color_text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: Style.fontSubButton,
                      fontSize: 15,
                      color: Style.secondColor),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.010,
                ),
                Image.asset(
                  'files/flags/${Model.SelectedDoc.country.toLowerCase()}.png',
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.010,
                ),
                Text(
                  Model.SelectedDoc.val,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: Style.fontSubButton,
                      fontSize: 20,
                      color: Style.secondColor),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: null,
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.08,
                    color: const Color(0xff383434),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        ),
                        const Text(
                          'Numero:',
                          style: TextStyle(
                            color: Style.secondColor,
                            fontFamily: Style.fontButton,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        ),
                        const Text(
                          '065.909.437-10',
                          style: TextStyle(
                            color: Style.secondColor,
                            fontFamily: Style.fontTitle,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),




              TextButton(
                onPressed: null,
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.25,
                    color: const Color(0xff383434),
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                          const Text(
                            'Notas do documento:',
                            style: TextStyle(
                              color: Style.secondColor,
                              fontFamily: Style.fontButton,
                              fontSize: 15,
                            ),
                          ),
                        ],),

                        Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 30,top: 15),
                            child: const Text(
                              'Guardado na caixa de documentos na caveta do escritorio no saco azul',
                              maxLines: 5,

                              style: TextStyle(
                                fontFamily: Style.fontTitle,
                                fontSize: 20,
                                color: Style.secondColor,
                              ),
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Row(children: [
                          Icon(Icons.edit),
                        ],mainAxisAlignment: MainAxisAlignment.end,)
                      ],
                    )),
              ),
            ],
          )
        ])));
  }
}
