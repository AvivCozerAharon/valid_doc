import 'package:flutter/material.dart';
import 'package:valid_doc/model/countries.dart';
import 'package:valid_doc/model/model.dart';
import 'package:valid_doc/prefabs/style.dart';
import '../../controller/nav_controller.dart';

class Doc_country extends StatefulWidget {
  @override
  Doc_country_State createState() => Doc_country_State();
}

class Doc_country_State extends State<Doc_country> {
  final _searchCtrl = TextEditingController();
  String _selected = 'br';
  List<String> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = List.from(availableCountryCodes);
    _searchCtrl.addListener(() {
      final q = _searchCtrl.text.toLowerCase();
      setState(() {
        _filtered = availableCountryCodes.where((code) {
          final name = (countryNames[code] ?? '').toLowerCase();
          return name.contains(q) || code.contains(q);
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _flagAsset(String code) => 'files/flags/w80/$code.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.firstColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
              child: IconButton(
                onPressed: () => Navigation.back(context),
                icon: const Icon(Icons.arrow_back,
                    color: Style.secondColor, size: 24),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                'País do documento',
                style: TextStyle(
                  fontFamily: Style.fontTitle,
                  fontSize: 34,
                  color: Style.secondColor,
                ),
              ),
            ),

            // ── País selecionado em destaque ────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xff383434),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        _flagAsset(_selected),
                        width: 32,
                        height: 22,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.flag, color: Colors.white38),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      countryNames[_selected] ?? _selected.toUpperCase(),
                      style: const TextStyle(
                        color: Style.secondColor,
                        fontFamily: Style.fontButton,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.check_circle_rounded,
                        color: Color(0xff558459), size: 20),
                  ],
                ),
              ),
            ),

            // ── Busca ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff2A2626),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  style: const TextStyle(
                      color: Style.secondColor, fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: 'Buscar país...',
                    hintStyle:
                        TextStyle(color: Colors.white24, fontSize: 14),
                    prefixIcon: Icon(Icons.search,
                        color: Colors.white38, size: 18),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // ── Lista de países ─────────────────────────────────────
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: _filtered.length,
                itemBuilder: (context, i) {
                  final code = _filtered[i];
                  final name =
                      countryNames[code] ?? code.toUpperCase();
                  final isSelected = code == _selected;

                  return GestureDetector(
                    onTap: () => setState(() => _selected = code),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xff3A3636)
                            : const Color(0xff2A2626),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.white38
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: Image.asset(
                              _flagAsset(code),
                              width: 30,
                              height: 20,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                  Icons.flag,
                                  color: Colors.white24,
                                  size: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(
                                color: isSelected
                                    ? Style.secondColor
                                    : Colors.white70,
                                fontFamily: Style.fontSubButton,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check,
                                color: Color(0xff558459), size: 18),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ── Botão continuar ─────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 10, 40, 16),
          child: SizedBox(
            height: 54,
            child: TextButton(
              onPressed: () {
                Model.Doc_country = _selected;
                Navigation.doc_date(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Continuar',
                style: TextStyle(
                  color: Style.secondColor,
                  fontFamily: Style.fontNextButton,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
