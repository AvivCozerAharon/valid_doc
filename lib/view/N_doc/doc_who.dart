import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:valid_doc/model/countries.dart';
import 'package:valid_doc/model/model.dart';
import 'package:valid_doc/model/data.dart';
import 'package:valid_doc/prefabs/style.dart';
import 'package:valid_doc/services/notification_service.dart';
import 'package:valid_doc/view/N_doc/doc_type.dart';
import 'package:valid_doc/services/haptic.dart';
import '../../controller/nav_controller.dart';

class Doc_who extends StatefulWidget {
  @override
  Doc_who_State createState() => Doc_who_State();
}

class Doc_who_State extends State<Doc_who> {
  DocumentDataBase db = DocumentDataBase();
  final _storage = Hive.box('storage');
  final _numberCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _numberCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  String _buildDocName() {
    final countryName = countryNames[Model.Doc_country.toLowerCase()] ??
        Model.Doc_country.toUpperCase();

    // Busca o label do tipo de documento
    final typeInfo = allDocTypes.firstWhere(
      (t) => t.id == Model.Doc_type,
      orElse: () => DocTypeInfo(
          id: Model.Doc_type,
          label: Model.Doc_type,
          icon: Icons.article),
    );

    switch (Model.Doc_type) {
      case 'visa':
      case 'voter':
      case 'ctps':
      case 'birth':
        return typeInfo.label;
      default:
        return '${typeInfo.label} - $countryName';
    }
  }

  String get _docTypeLabel {
    final t = allDocTypes.firstWhere(
      (t) => t.id == Model.Doc_type,
      orElse: () =>
          DocTypeInfo(id: Model.Doc_type, label: Model.Doc_type, icon: Icons.article),
    );
    return t.label;
  }

  String get _countryLabel =>
      countryNames[Model.Doc_country.toLowerCase()] ??
      Model.Doc_country.toUpperCase();

  String get _formattedDate {
    try {
      return DateFormat('dd/MM/yyyy')
          .format(DateFormat('dd/MM/yyyy').parse(Model.Doc_val));
    } catch (_) {
      return Model.Doc_val;
    }
  }

  void _save() {
    Haptic.medium();
    if (_storage.get("DOCUMENTS") != null) db.loadData();

    final number =
        _numberCtrl.text.trim().isEmpty ? 'none' : _numberCtrl.text.trim();
    final notes =
        _notesCtrl.text.trim().isEmpty ? 'none' : _notesCtrl.text.trim();

    Model.Doc_name = _buildDocName();

    db.DocumentsList.add([
      Model.Doc_name,
      Model.Doc_type,
      Model.Doc_country,
      Model.Doc_val,
      number,
      notes,
      Model.Doc_personId,
      'none',
    ]);
    db.updateDocuments();

    final newIndex = db.DocumentsList.length - 1;
    NotificationService.scheduleDocumentNotifications(
      baseId: newIndex,
      docName: Model.Doc_name,
      valDate: Model.Doc_val,
    );

    Model.clear();
    Navigation.home(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.firstColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(left: 0, top: 4),
                  child: IconButton(
                    onPressed: () => Navigation.back(context),
                    icon: const Icon(Icons.arrow_back,
                        color: Style.secondColor, size: 24),
                    padding: EdgeInsets.zero,
                  ),
                ),
                const Text(
                  'Resumo do documento',
                  style: TextStyle(
                    fontFamily: Style.fontTitle,
                    fontSize: 34,
                    color: Style.secondColor,
                  ),
                ),
                const SizedBox(height: 20),

                // ── Card de resumo ────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xff2A2626),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(
                        icon: Icons.description_outlined,
                        label: 'Tipo',
                        value: _docTypeLabel,
                      ),
                      if (Model.Doc_type != 'visa' &&
                          Model.Doc_type != 'voter' &&
                          Model.Doc_type != 'ctps' &&
                          Model.Doc_type != 'birth') ...[
                        const _Divider(),
                        _SummaryRow(
                          icon: Icons.flag_outlined,
                          label: 'País',
                          value: _countryLabel,
                          trailing: Image.asset(
                            'files/flags/w80/${Model.Doc_country.toLowerCase()}.png',
                            width: 28,
                            height: 19,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const SizedBox(),
                          ),
                        ),
                      ],
                      const _Divider(),
                      _SummaryRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Validade',
                        value: _formattedDate,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Número (opcional) ────────────────────────────────
                _FieldLabel(label: 'Número do documento (opcional)'),
                const SizedBox(height: 6),
                _StyledTextField(
                  controller: _numberCtrl,
                  hint: 'Ex: AB123456',
                  maxLength: 30,
                  icon: Icons.tag,
                ),

                const SizedBox(height: 20),

                // ── Observações (opcional) ───────────────────────────
                _FieldLabel(label: 'Observações (opcional)'),
                const SizedBox(height: 6),
                _StyledTextField(
                  controller: _notesCtrl,
                  hint: 'Ex: Guardado na gaveta do escritório',
                  maxLength: 120,
                  icon: Icons.notes,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),

      // ── Botão salvar ─────────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 10, 40, 16),
          child: SizedBox(
            height: 54,
            child: TextButton(
              onPressed: _save,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xff558459),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_rounded,
                      color: Style.secondColor, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Salvar documento',
                    style: TextStyle(
                      color: Style.secondColor,
                      fontFamily: Style.fontNextButton,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 16),
          const SizedBox(width: 10),
          Text(label,
              style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 13,
                  fontFamily: Style.fontSubButton)),
          const Spacer(),
          if (trailing != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: trailing!,
            ),
            const SizedBox(width: 8),
          ],
          Text(value,
              style: const TextStyle(
                  color: Style.secondColor,
                  fontSize: 15,
                  fontFamily: Style.fontButton)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: Colors.white10, height: 1);
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: const TextStyle(
            color: Colors.white38,
            fontFamily: Style.fontSubButton,
            fontSize: 13));
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLength;
  final IconData icon;
  final int maxLines;

  const _StyledTextField({
    required this.controller,
    required this.hint,
    required this.maxLength,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff2A2626),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        maxLines: maxLines,
        style: const TextStyle(
            color: Style.secondColor,
            fontFamily: Style.fontSubButton,
            fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.white38, size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          counterStyle:
              const TextStyle(color: Colors.white24, fontSize: 11),
        ),
      ),
    );
  }
}
