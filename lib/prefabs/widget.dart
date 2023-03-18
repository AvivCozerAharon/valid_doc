import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:valid_doc/prefabs/style.dart';

class Widgets {
  static Widget country_picker(
      onSelectedItemChanged, @required List list, BuildContext context) {
    return CupertinoPicker(
      itemExtent: 80,
      onSelectedItemChanged: onSelectedItemChanged,
      children: List<Widget>.generate(list.length, (index) {
        return Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              list[index],
              style: const TextStyle(
                fontFamily: Style.fontButton,
                color: Style.secondColor,
              ),
            ),
            CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('files/flags/${list[index].toString().toLowerCase()}.png'),
            ),
          ],
        ));
      }),
    );
  }

  static Widget date_picker(onDateTimeChanged, BuildContext context,bool edit,DateTime date ) {
    return CupertinoTheme(
        data: const CupertinoThemeData(
          brightness: Brightness.dark,),
        child: CupertinoDatePicker(
          onDateTimeChanged: onDateTimeChanged,
          initialDateTime: date,
          mode: CupertinoDatePickerMode.date,
          minimumYear:DateTime.now().year - 20,
          maximumYear: DateTime.now().year + 50,
        ));
  }

  static Widget subtitle_square(text, color, context) {
    return Row(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.1,
          height: MediaQuery.of(context).size.height * 0.05,
          color: color,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.025,
        ), FittedBox(
          fit: BoxFit.cover,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Style.secondColor),
          ),
        ),
      ],
    );
  }

  static Future<dynamic> color_subtitle(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              insetPadding: const EdgeInsets.only(
                  right: 40, left: 40, top: 80, bottom: 80),
              backgroundColor: const Color(0xff4C4545),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 20, bottom: 10),
                    child: const FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                        'Legenda das cores',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: Style.fontTitle,
                            fontSize: 30,
                            color: Style.secondColor),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10),
                    child: Divider(
                      color: Style.secondColor,
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  subtitle_square('Mais de 2 anos de duração',
                      const Color(0xff558459), context),
                  subtitle_square('Menos de 2 anos de duração',
                      const Color(0xffDA8130), context),
                  subtitle_square('Menos de 1 ano de duração',
                      const Color(0xffDA4430), context),
                  subtitle_square('Menos de 6 meses de duração',
                      const Color(0xffFF0000), context),
                  subtitle_square('Expirado',
                      const Color(0xff766E6E), context),
                ],
              ),
            ));
  }
}
