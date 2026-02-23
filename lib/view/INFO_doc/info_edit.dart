import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valid_doc/model/model.dart';
import 'package:valid_doc/prefabs/buttons.dart';
import 'package:valid_doc/prefabs/style.dart';
import 'package:valid_doc/services/notification_service.dart';
import '../../../controller/nav_controller.dart';
import '../../../model/data.dart';
import '../../../prefabs/widget.dart';

class Info_edit extends StatefulWidget {
  @override
  Info_edit_State createState() => Info_edit_State();
}

class Info_edit_State extends State<Info_edit> {
  late DateTime val;
  DocumentDataBase db = DocumentDataBase();

  @override
  void initState() {
    super.initState();
    try {
      val = DateFormat('dd/MM/yyyy').parse(Model.SelectedDoc.val);
    } catch (_) {
      try {
        val = DateFormat('d/M/yyyy').parse(Model.SelectedDoc.val);
      } catch (_) {
        val = DateTime.now();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.firstColor,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Container(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () => Navigation.back(context),
                    icon: const Icon(Icons.arrow_back,
                        color: Style.secondColor, size: 24)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Nova data de expiração',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: Style.fontTitle,
                      fontSize: 30,
                      color: Style.secondColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 4),
                child: Text(
                  'Atual: ${Model.SelectedDoc.val}',
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Widgets.date_picker(
                    (DateTime newtime) => setState(() => val = newtime),
                    context,
                    true,
                    val),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Button.next(
          onPressed: () {
            db.loadData();
            final newval =
                '${val.day.toString().padLeft(2, '0')}/${val.month.toString().padLeft(2, '0')}/${val.year}';
            db.DocumentsList[Model.SelectedDoc.index][3] = newval;
            db.updateDocuments();

            NotificationService.scheduleDocumentNotifications(
              baseId: Model.SelectedDoc.index,
              docName: Model.SelectedDoc.name,
              valDate: newval,
            );

            Model.SelectedDoc = Document(
              index: Model.SelectedDoc.index,
              name: Model.SelectedDoc.name,
              type: Model.SelectedDoc.type,
              country: Model.SelectedDoc.country,
              val: newval,
              number: Model.SelectedDoc.number,
              notes: Model.SelectedDoc.notes,
              personId: Model.SelectedDoc.personId,
              photoPath: Model.SelectedDoc.photoPath,
            );

            Navigation.home(context);
          },
          text: 'Salvar',
          context: context),
    );
  }
}
