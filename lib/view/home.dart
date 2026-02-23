import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:valid_doc/controller/nav_controller.dart';
import 'package:valid_doc/model/data.dart';
import 'package:valid_doc/model/model.dart';
import 'package:valid_doc/prefabs/document_tile.dart';
import 'package:valid_doc/prefabs/style.dart';
import 'package:valid_doc/services/notification_service.dart';
import '../prefabs/widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  Home_State createState() => Home_State();
}

class Home_State extends State<Home> {
  final _storage = Hive.box('storage');
  DocumentDataBase db = DocumentDataBase();
  final _searchController = TextEditingController();
  bool _searching = false;
  List<int> _searchResults = [];

  @override
  void initState() {
    super.initState();
    if (_storage.get("DOCUMENTS") != null || _storage.get("PEOPLE") != null) {
      db.loadData();
      NotificationService.rescheduleAll(db.DocumentsList);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    setState(() {
      _searchResults = db.search(q);
    });
  }

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

  // Conta documentos com vencimento crítico (< 6 meses) para uma pessoa
  int _alertCount(String personId) {
    int count = 0;
    for (final d in db.DocumentsList) {
      if ((d.length > 6 ? d[6] : '') != personId) continue;
      try {
        DateTime date;
        try {
          date = DateFormat('dd/MM/yyyy').parse(d[3]);
        } catch (_) {
          date = DateFormat('d/M/yyyy').parse(d[3]);
        }
        final diff = date.difference(DateTime.now()).inDays;
        if (diff < 183) count++;
      } catch (_) {}
    }
    return count;
  }

  int _docCount(String personId) =>
      db.DocumentsList.where((d) => (d.length > 6 ? d[6] : '') == personId).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.firstColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Widgets.color_subtitle(context),
                    icon: const Icon(Icons.info_outline,
                        color: Style.secondColor, size: 22),
                    tooltip: 'Legenda',
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _searching = !_searching;
                        if (!_searching) {
                          _searchController.clear();
                          _searchResults = [];
                        }
                      });
                    },
                    icon: Icon(
                      _searching ? Icons.close : Icons.search,
                      color: Style.secondColor,
                      size: 22,
                    ),
                    tooltip: 'Buscar',
                  ),
                ],
              ),
            ),

            // ── Barra de busca ───────────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: _searching ? 52 : 0,
              curve: Curves.easeInOut,
              child: _searching
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: _onSearch,
                        style: const TextStyle(
                            color: Style.secondColor, fontSize: 15),
                        decoration: InputDecoration(
                          hintText:
                              'Buscar por nome, pessoa, tipo, país...',
                          hintStyle: const TextStyle(
                              color: Colors.white38, fontSize: 14),
                          prefixIcon: const Icon(Icons.search,
                              color: Colors.white38, size: 18),
                          filled: true,
                          fillColor: const Color(0xff383434),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // ── Título ou resultados de busca ────────────────────────
            if (!_searching || _searchController.text.isEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Família',
                      style: TextStyle(
                        fontFamily: Style.fontTitle,
                        fontSize: 36,
                        color: Style.secondColor,
                      ),
                    ),
                    const Spacer(),
                    if (db.PeopleList.isNotEmpty)
                      Text(
                        '${db.PeopleList.length} pessoa${db.PeopleList.length != 1 ? 's' : ''}',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 13,
                          fontFamily: Style.fontSubButton,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── Conteúdo principal ───────────────────────────────────
            Expanded(
              child: _searching && _searchController.text.isNotEmpty
                  ? _buildSearchResults()
                  : _buildPeopleList(),
            ),
          ],
        ),
      ),

      // ── FAB: adicionar pessoa ──────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _showAddPersonDialog();
        },
        backgroundColor: const Color(0xff383434),
        icon: const Icon(Icons.person_add_outlined,
            color: Style.secondColor, size: 20),
        label: const Text(
          'Adicionar pessoa',
          style: TextStyle(
            color: Style.secondColor,
            fontFamily: Style.fontSubButton,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPeopleList() {
    if (db.PeopleList.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline, color: Colors.white12, size: 80),
          const SizedBox(height: 16),
          const Text(
            'Nenhum familiar cadastrado',
            style: TextStyle(
              color: Colors.white38,
              fontFamily: Style.fontSubButton,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Toque em "Adicionar pessoa" para começar',
            style: TextStyle(
              color: Colors.white24,
              fontFamily: Style.fontSubButton,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 80),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: db.PeopleList.length,
      itemBuilder: (context, i) {
        final p = db.PeopleList[i];
        final person = Person(id: p[0], name: p[1]);
        final docCount = _docCount(person.id);
        final alerts = _alertCount(person.id);

        return _PersonCard(
          person: person,
          docCount: docCount,
          alertCount: alerts,
          onTap: () {
            Model.SelectedPerson = person;
            Navigation.person_docs(context);
          },
        );
      },
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum resultado encontrado',
          style: TextStyle(
            color: Colors.white38,
            fontFamily: Style.fontSubButton,
            fontSize: 15,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 24),
      itemCount: _searchResults.length,
      itemBuilder: (context, i) {
        final idx = _searchResults[i];
        final d = db.DocumentsList[idx];
        // nome da pessoa
        final personId = d.length > 6 ? d[6] as String : '';
        String personName = '';
        for (final p in db.PeopleList) {
          if (p[0] == personId) {
            personName = p[1];
            break;
          }
        }

        return DocumentTile(
          onPressed: () => _openDoc(idx),
          name: d[0],
          type: d[1],
          country: d[2],
          val: d[3],
          personName: personName,
        );
      },
    );
  }

  Future<void> _showAddPersonDialog() async {
    final ctrl = TextEditingController();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Novo familiar',
                style: TextStyle(
                  fontFamily: Style.fontTitle,
                  fontSize: 22,
                  color: Style.secondColor,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff383434),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: ctrl,
                  autofocus: true,
                  style: const TextStyle(
                      color: Style.secondColor, fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Nome (ex: Maria)',
                    hintStyle: TextStyle(color: Colors.white24),
                    prefixIcon: Icon(Icons.person_outline,
                        color: Colors.white38, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancelar',
                        style: TextStyle(color: Colors.white38)),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      if (ctrl.text.trim().isEmpty) return;
                      final id = DateTime.now()
                          .millisecondsSinceEpoch
                          .toString();
                      db.loadData();
                      db.PeopleList.add([id, ctrl.text.trim()]);
                      db.updatePeople();
                      setState(() {});
                      Navigator.pop(ctx);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xff558459),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text(
                      'Adicionar',
                      style: TextStyle(
                          color: Style.secondColor,
                          fontFamily: Style.fontButton),
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
}

// ── Person Card ────────────────────────────────────────────────────────────
class _PersonCard extends StatelessWidget {
  final Person person;
  final int docCount;
  final int alertCount;
  final VoidCallback onTap;

  const _PersonCard({
    required this.person,
    required this.docCount,
    required this.alertCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = person.avatarColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xff2A2626),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white10, width: 1),
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: color.withOpacity(0.5), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      person.name.isNotEmpty
                          ? person.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: color,
                        fontSize: 22,
                        fontFamily: Style.fontTitle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.name,
                        style: const TextStyle(
                          color: Style.secondColor,
                          fontFamily: Style.fontButton,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        docCount == 0
                            ? 'Sem documentos'
                            : '$docCount documento${docCount != 1 ? 's' : ''}',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontFamily: Style.fontSubButton,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge de alerta
                if (alertCount > 0)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xffDA4430).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xffDA4430).withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Color(0xffDA4430), size: 13),
                        const SizedBox(width: 4),
                        Text(
                          '$alertCount',
                          style: const TextStyle(
                            color: Color(0xffDA4430),
                            fontSize: 12,
                            fontFamily: Style.fontButton,
                          ),
                        ),
                      ],
                    ),
                  ),

                const Icon(Icons.chevron_right,
                    color: Colors.white24, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
