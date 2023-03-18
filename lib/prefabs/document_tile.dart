import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valid_doc/model/model.dart';
import 'package:valid_doc/prefabs/style.dart';

import '../controller/nav_controller.dart';

class DocumentTile extends StatelessWidget {
  final String name;
  final String val;
  final String type;
  final String country;
  final Function() onPressed;

  const DocumentTile(
      {super.key,
      required this.name,
      required this.type,
      required this.country,
      required this.val,
      required this.onPressed});

  checkValColor() {
    DateTime checkVal = DateFormat('dd/MM/yyyy').parse(val);
    DateTime now = DateTime.now();
    int difference = checkVal.difference(now).inDays;
    int differenceHour = checkVal.difference(now).inHours;
    if (difference >= 365 * 2) {
      return const  Color(0xff558459);
    } else if (365 * 2 > difference && difference >= 365) {
      return const Color(0xffDA8130);
    } else if (difference < 365 && difference > 183) {
      return const Color(0xffDA4430);
    } else if (difference <= 183 && difference >= 0 && differenceHour > 0) {
      return const Color(0xffFF0000);
    } else if (difference <= 0) {
      return const Color(0xff766E6E);
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: SizedBox(
            height: MediaQuery.of(context).size.height < 590?MediaQuery.of(context).size.height * 0.3:MediaQuery.of(context).size.height >850?MediaQuery.of(context).size.height * 0.18:MediaQuery.of(context).size.height * 0.2,
            child:Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),

          ),
          color: checkValColor(),
          elevation: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children:  <Widget>[
              ListTile(
                leading:  ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 68,
                    maxWidth: 150,
                  ),
                  child: Image.asset('files/$type.png',
                      fit: BoxFit.fill)),

                title: Text(
                  name,
                    textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: Style.fontButton,
                      fontSize: 17,
                      color: Style.secondColor),
                ),

                subtitle: Text(
                    val,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: Style.fontSubButton,
                        fontSize: 17,
                        color: Style.secondColor),
                  ),
                trailing: Image.asset(
                  'files/flags/${country.toLowerCase()}.png',
                  width: 36,
                  height: 36,
                ),

              ),
            ],
          ),
        )));
  }
}
