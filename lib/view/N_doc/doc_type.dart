import 'package:flutter/material.dart';
import 'package:valid_doc/model/model.dart';
import 'package:valid_doc/prefabs/style.dart';
import '../../controller/nav_controller.dart';

// Definição central de todos os tipos de documento
class DocTypeInfo {
  final String id;        // salvo no banco
  final String label;     // nome exibido
  final IconData icon;
  final bool skipCountry; // visa pula seleção de país

  const DocTypeInfo({
    required this.id,
    required this.label,
    required this.icon,
    this.skipCountry = false,
  });
}

const List<DocTypeInfo> allDocTypes = [
  DocTypeInfo(id: 'passport',  label: 'Passaporte',       icon: Icons.menu_book_rounded),
  DocTypeInfo(id: 'id',        label: 'Identidade',        icon: Icons.badge_rounded),
  DocTypeInfo(id: 'car_id',    label: 'CNH',               icon: Icons.drive_eta_rounded),
  DocTypeInfo(id: 'visa',      label: 'Visto',             icon: Icons.flight_rounded, skipCountry: true),
  DocTypeInfo(id: 'voter',     label: 'Título de Eleitor', icon: Icons.how_to_vote_rounded),
  DocTypeInfo(id: 'vaccine',   label: 'Cartão de Vacina',  icon: Icons.vaccines_rounded),
  DocTypeInfo(id: 'ctps',      label: 'Carteira de Trabalho', icon: Icons.work_rounded),
  DocTypeInfo(id: 'birth',     label: 'Certidão',          icon: Icons.article_rounded),
];

class Doc_type extends StatelessWidget {
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
                onPressed: () => Navigation.home(context),
                icon: const Icon(Icons.close,
                    color: Style.secondColor, size: 24),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Text(
                'Qual tipo de\ndocumento?',
                style: TextStyle(
                  fontFamily: Style.fontTitle,
                  fontSize: 34,
                  color: Style.secondColor,
                  height: 1.15,
                ),
              ),
            ),

            // ── Grid de tipos ───────────────────────────────────────
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.25,
                ),
                itemCount: allDocTypes.length,
                itemBuilder: (context, i) {
                  final t = allDocTypes[i];
                  return _DocTypeCard(
                    info: t,
                    onTap: () {
                      Model.Doc_type = t.id;
                      if (t.skipCountry) {
                        Model.Doc_country = 'usa';
                        Navigation.doc_date(context);
                      } else {
                        Navigation.doc_country(context);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocTypeCard extends StatelessWidget {
  final DocTypeInfo info;
  final VoidCallback onTap;

  const _DocTypeCard({required this.info, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff2A2626),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white10),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(info.icon,
                    color: Style.secondColor, size: 22),
              ),
              Text(
                info.label,
                style: const TextStyle(
                  color: Style.secondColor,
                  fontFamily: Style.fontButton,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
