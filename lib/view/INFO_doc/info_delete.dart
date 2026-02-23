import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:valid_doc/model/model.dart';
import 'package:valid_doc/prefabs/style.dart';
import 'package:valid_doc/services/notification_service.dart';
import '../../../controller/nav_controller.dart';
import '../../../model/data.dart';

class Info_delete extends StatefulWidget {
  @override
  Info_delete_State createState() => Info_delete_State();
}

class Info_delete_State extends State<Info_delete> {
  DocumentDataBase db = DocumentDataBase();
  final _storage = Hive.box('storage');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.firstColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Cabeçalho ────────────────────────────────────────────
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigation.back(context),
                icon: const Icon(Icons.arrow_back,
                    color: Style.secondColor, size: 24),
              ),
            ),

            // ── Ícone e confirmação ──────────────────────────────────
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.delete_forever_rounded,
                    color: Color(0xffDA4430),
                    size: 90,
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Tem certeza que deseja excluir?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: Style.fontTitle,
                          fontSize: 24,
                          color: Style.secondColor),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      Model.SelectedDoc.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: Style.fontDelete,
                          fontSize: 20,
                          color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ── Botão Excluir ────────────────────────────────
                  _ActionButton(
                    label: 'Sim, excluir',
                    color: const Color(0xff792E2E),
                    icon: Icons.delete_outline,
                    onPressed: () {
                      db.loadData();
                      final deletedIndex = Model.SelectedDoc.index;
                      db.DocumentsList.removeAt(deletedIndex);
                      db.updateDocuments();

                      // Cancela notificações do documento excluído
                      NotificationService.cancelDocumentNotifications(
                          deletedIndex);
                      // Re-agendar todos (os índices mudaram)
                      NotificationService.rescheduleAll(db.DocumentsList);

                      Navigation.home(context);
                    },
                  ),

                  const SizedBox(height: 16),

                  // ── Botão Cancelar ────────────────────────────────
                  _ActionButton(
                    label: 'Cancelar',
                    color: const Color(0xff2C402E),
                    icon: Icons.close,
                    onPressed: () => Navigation.back(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Style.secondColor, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Style.secondColor,
                  fontFamily: Style.fontNextButton,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
