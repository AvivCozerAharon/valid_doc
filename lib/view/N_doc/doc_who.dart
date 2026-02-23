import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:valid_doc/model/model.dart';
import 'package:valid_doc/prefabs/buttons.dart';
import 'package:valid_doc/prefabs/style.dart';
import 'package:valid_doc/services/notification_service.dart';
import '../../controller/nav_controller.dart';
import '../../model/data.dart';

class Doc_who extends StatefulWidget {
  @override
  Doc_who_State createState() => Doc_who_State();
}

class Doc_who_State extends State<Doc_who> {
  DocumentDataBase db = DocumentDataBase();
  final _storage = Hive.box('storage');
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _buildDocName(String ownerName) {
    switch (Model.Doc_type) {
      case 'passport':
        return 'Passaporte ${Model.Doc_country} $ownerName';
      case 'id':
        return 'Identidade ${Model.Doc_country} $ownerName';
      case 'visa':
        return 'VISA $ownerName';
      case 'car_id':
        return 'CNH ${Model.Doc_country} $ownerName';
      default:
        return '${Model.Doc_type} $ownerName';
    }
  }

  void _saveAndFinish() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o nome do titular')),
      );
      return;
    }

    if (_storage.get("DOCUMENTS") != null) {
      db.loadData();
    }

    final ownerName = _nameController.text.trim();
    final number = _numberController.text.trim().isEmpty
        ? 'none'
        : _numberController.text.trim();
    final notes = _notesController.text.trim().isEmpty
        ? 'none'
        : _notesController.text.trim();

    Model.Doc_name = _buildDocName(ownerName);

    db.DocumentsList
        .add([Model.Doc_name, Model.Doc_type, Model.Doc_country, Model.Doc_val, number, notes, Model.Doc_personId, 'none']);
    db.updateDocuments();

    // Agendar notificações para o novo documento
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
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Container(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () => Navigation.back(context),
                    icon: const Icon(Icons.arrow_back,
                        color: Style.secondColor, size: 24),
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 8),
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'A quem pertence o documento?',
                    style: TextStyle(
                        fontFamily: Style.fontTitle,
                        fontSize: 36,
                        color: Style.secondColor),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Nome do titular ──────────────────────────────────
                _FieldLabel(label: 'Nome do titular *'),
                const SizedBox(height: 6),
                _StyledTextField(
                  controller: _nameController,
                  hint: 'Ex: João Silva',
                  maxLength: 20,
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 20),

                // ── Número do documento ──────────────────────────────
                _FieldLabel(label: 'Número do documento (opcional)'),
                const SizedBox(height: 6),
                _StyledTextField(
                  controller: _numberController,
                  hint: 'Ex: AB123456',
                  maxLength: 20,
                  icon: Icons.tag,
                  keyboardType: TextInputType.text,
                ),

                const SizedBox(height: 20),

                // ── Observações ──────────────────────────────────────
                _FieldLabel(label: 'Observações (opcional)'),
                const SizedBox(height: 6),
                _StyledTextField(
                  controller: _notesController,
                  hint: 'Ex: Guardado na gaveta do escritório',
                  maxLength: 120,
                  icon: Icons.notes,
                  maxLines: 3,
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              ],
            ),
          ),
        ),
      ),
      bottomSheet:
          Button.next(onPressed: _saveAndFinish, text: 'Salvar', context: context),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white60,
        fontFamily: Style.fontSubButton,
        fontSize: 13,
        letterSpacing: 0.4,
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLength;
  final IconData icon;
  final TextInputType keyboardType;
  final int maxLines;

  const _StyledTextField({
    required this.controller,
    required this.hint,
    required this.maxLength,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff383434),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Style.secondColor,
          fontFamily: Style.fontSubButton,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.white38, size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          counterStyle: const TextStyle(color: Colors.white24, fontSize: 11),
        ),
      ),
    );
  }
}
