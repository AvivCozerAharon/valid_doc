import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:valid_doc/controller/nav_controller.dart';
import 'package:valid_doc/model/data.dart';
import 'package:valid_doc/model/model.dart';
import 'package:valid_doc/prefabs/document_tile.dart';
import 'package:valid_doc/prefabs/style.dart';
import 'package:valid_doc/services/notification_service.dart';

class PersonDocs extends StatefulWidget {
  const PersonDocs({super.key});

  @override
  PersonDocs_State createState() => PersonDocs_State();
}

class PersonDocs_State extends State<PersonDocs> {
  final _storage = Hive.box('storage');
  DocumentDataBase db = DocumentDataBase();

  @override
  void initState() {
    super.initState();
    db.loadData();
  }

  List get _myDocs => db.DocumentsList
      .asMap()
      .entries
      .where((e) =>
          (e.value.length > 6 ? e.value[6] : '') == Model.SelectedPerson.id)
      .map((e) => {'index': e.key, 'doc': e.value})
      .toList();

  void _openDoc(int index) {
    final d = db.DocumentsList[index];
    Model.SelectedDoc = Document(
      index: index,
      name: d[0],
      type: d[1],
      country: d[2],
      val: d[3],
      number: d.length > 4 ? (d[4] ?? 'none') : 'none',
      notes: d.length > 5 ? (d[5] ?? 'none') : 'none',
      personId: d.length > 6 ? (d[6] ?? '') : '',
      photoPath: d.length > 7 ? (d[7] ?? 'none') : 'none',
    );
    Navigation.info_home(context);
  }

  Future<void> _confirmDeletePerson() async {
    await showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xff2A2626),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_remove_outlined,
                  color: Color(0xffDA4430), size: 48),
              const SizedBox(height: 16),
              Text(
                'Remover ${Model.SelectedPerson.name}?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: Style.fontTitle,
                  fontSize: 20,
                  color: Style.secondColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Todos os documentos desta pessoa também serão excluídos.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 13,
                  fontFamily: Style.fontSubButton,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xff383434),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancelar',
                          style: TextStyle(color: Colors.white54)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        db.loadData();
                        // cancela notificações dos docs desta pessoa
                        final indices = db.indicesForPerson(
                            Model.SelectedPerson.id);
                        for (final i in indices) {
                          NotificationService.cancelDocumentNotifications(i);
                        }
                        // remove docs
                        db.DocumentsList.removeWhere((d) =>
                            (d.length > 6 ? d[6] : '') ==
                            Model.SelectedPerson.id);
                        // remove pessoa
                        db.PeopleList.removeWhere(
                            (p) => p[0] == Model.SelectedPerson.id);
                        db.updateAll();
                        NotificationService.rescheduleAll(db.DocumentsList);
                        Navigator.pop(ctx);
                        Navigation.home(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xff792E2E),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Remover',
                          style: TextStyle(
                              color: Style.secondColor,
                              fontFamily: Style.fontButton)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final person = Model.SelectedPerson;
    final color = person.avatarColor;
    final docs = _myDocs;

    return Scaffold(
      backgroundColor: Style.firstColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header da pessoa ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigation.back(context),
                    icon: const Icon(Icons.arrow_back,
                        color: Style.secondColor, size: 24),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _confirmDeletePerson,
                    icon: const Icon(Icons.person_remove_outlined,
                        color: Colors.white38, size: 22),
                    tooltip: 'Remover pessoa',
                  ),
                ],
              ),
            ),

            // Avatar + nome
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: color.withOpacity(0.5), width: 2.5),
                    ),
                    child: Center(
                      child: Text(
                        person.name.isNotEmpty
                            ? person.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: color,
                          fontSize: 26,
                          fontFamily: Style.fontTitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.name,
                        style: const TextStyle(
                          fontFamily: Style.fontTitle,
                          fontSize: 28,
                          color: Style.secondColor,
                        ),
                      ),
                      Text(
                        '${docs.length} documento${docs.length != 1 ? 's' : ''}',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontFamily: Style.fontSubButton,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Lista de documentos ──────────────────────────────────
            Expanded(
              child: docs.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.folder_open_outlined,
                            color: Colors.white12, size: 64),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum documento ainda',
                          style: TextStyle(
                            color: Colors.white38,
                            fontFamily: Style.fontSubButton,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 80),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: docs.length,
                      itemBuilder: (context, i) {
                        final idx = docs[i]['index'] as int;
                        final d = docs[i]['doc'] as List;
                        return DocumentTile(
                          onPressed: () => _openDoc(idx),
                          name: d[0],
                          type: d[1],
                          country: d[2],
                          val: d[3],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // ── FAB: adicionar documento ───────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Model.clear();
          Model.Doc_personId = person.id;
          Navigation.doc_type(context);
        },
        backgroundColor: const Color(0xff383434),
        icon: const Icon(Icons.add, color: Style.secondColor, size: 20),
        label: const Text(
          'Adicionar documento',
          style: TextStyle(
            color: Style.secondColor,
            fontFamily: Style.fontSubButton,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
