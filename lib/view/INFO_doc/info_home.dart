import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:valid_doc/model/countries.dart';
import 'package:valid_doc/model/model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:valid_doc/services/haptic.dart';
import 'package:valid_doc/prefabs/style.dart';
import '../../../controller/nav_controller.dart';
import '../../../model/data.dart';

class Info_home extends StatefulWidget {
  @override
  Info_home_State createState() => Info_home_State();
}

class Info_home_State extends State<Info_home> {
  final _storage = Hive.box('storage');
  DocumentDataBase db = DocumentDataBase();

  bool _editingNumber = false;
  bool _editingNotes = false;
  late TextEditingController _numberCtrl;
  late TextEditingController _notesCtrl;
  final _screenshotCtrl = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _numberCtrl = TextEditingController(
        text: Model.SelectedDoc.number == 'none' ? '' : Model.SelectedDoc.number);
    _notesCtrl = TextEditingController(
        text: Model.SelectedDoc.notes == 'none' ? '' : Model.SelectedDoc.notes);
  }

  @override
  void dispose() {
    _numberCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Color _statusColor() {
    try {
      final date = _parseDate(Model.SelectedDoc.val);
      final diff = date.difference(DateTime.now()).inDays;
      if (diff >= 365 * 2) return const Color(0xff558459);
      if (diff >= 365) return const Color(0xffDA8130);
      if (diff > 183) return const Color(0xffDA4430);
      if (diff >= 0) return const Color(0xffFF0000);
      return const Color(0xff766E6E);
    } catch (_) {
      return const Color(0xff766E6E);
    }
  }

  String _statusText() {
    try {
      final diff =
          _parseDate(Model.SelectedDoc.val).difference(DateTime.now()).inDays;
      if (diff >= 365 * 2) return 'Expira em mais de 2 anos';
      if (diff >= 365) return 'Expira em menos de 2 anos';
      if (diff > 183) return 'Expira em menos de 1 ano';
      if (diff >= 0) return 'Expira em menos de 6 meses';
      return 'Documento expirado';
    } catch (_) {
      return '';
    }
  }

  DateTime _parseDate(String v) {
    try {
      return DateFormat('dd/MM/yyyy').parse(v);
    } catch (_) {
      return DateFormat('d/M/yyyy').parse(v);
    }
  }

  String _formattedVal() {
    try {
      return DateFormat('dd/MM/yyyy').format(_parseDate(Model.SelectedDoc.val));
    } catch (_) {
      return Model.SelectedDoc.val;
    }
  }

  static const _typesWithAsset = {'passport', 'id', 'car_id', 'visa'};

  String _assetForType(String t) =>
      t == 'id' ? 'files/ident.png' : 'files/$t.png';

  IconData _iconForType(String t) {
    switch (t) {
      case 'voter':   return Icons.how_to_vote_rounded;
      case 'vaccine': return Icons.vaccines_rounded;
      case 'ctps':    return Icons.work_rounded;
      case 'birth':   return Icons.article_rounded;
      default:        return Icons.description_rounded;
    }
  }

  String _flagAsset(String c) => flagAsset(c);

  Future<void> _shareDocument() async {
    Haptic.light();
    final doc = Model.SelectedDoc;
    final countryName = countryNames[doc.country.toLowerCase()] ?? doc.country;
    final number = doc.number == 'none' ? '-' : doc.number;

    // Captura o card como imagem
    final image = await _screenshotCtrl.captureFromLongWidget(
      _ShareCard(
        name: doc.name,
        type: doc.type,
        country: countryName,
        date: _formattedVal(),
        number: number,
        color: _statusColor(),
        flagAsset: _flagAsset(doc.country),
        hasAsset: _typesWithAsset.contains(doc.type),
        assetPath: _assetForType(doc.type),
        iconData: _iconForType(doc.type),
      ),
      pixelRatio: 3.0,
    );

    final text = '📄 ${doc.name}\n🗓 Validade: ${_formattedVal()}\n🌍 País: $countryName\n🔢 Número: $number';

    await Share.shareXFiles(
      [XFile.fromData(image, mimeType: 'image/png', name: 'documento.png')],
      text: text,
    );
  }

  void _saveField({required String field, required String value}) {
    Haptic.light();
    db.loadData();
    final v = value.trim().isEmpty ? 'none' : value.trim();
    if (field == 'number') {
      db.DocumentsList[Model.SelectedDoc.index][4] = v;
      Model.SelectedDoc = Document(
        index: Model.SelectedDoc.index,
        name: Model.SelectedDoc.name,
        type: Model.SelectedDoc.type,
        country: Model.SelectedDoc.country,
        val: Model.SelectedDoc.val,
        number: v,
        notes: Model.SelectedDoc.notes,
        personId: Model.SelectedDoc.personId,
        photoPath: Model.SelectedDoc.photoPath,
      );
    } else {
      db.DocumentsList[Model.SelectedDoc.index][5] = v;
      Model.SelectedDoc = Document(
        index: Model.SelectedDoc.index,
        name: Model.SelectedDoc.name,
        type: Model.SelectedDoc.type,
        country: Model.SelectedDoc.country,
        val: Model.SelectedDoc.val,
        number: Model.SelectedDoc.number,
        notes: v,
        personId: Model.SelectedDoc.personId,
        photoPath: Model.SelectedDoc.photoPath,
      );
    }
    db.updateDocuments();
  }

  Future<void> _pickPhoto() async {
    if (kIsWeb) return;
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;

    db.loadData();
    // Garante que o índice 7 existe
    while (db.DocumentsList[Model.SelectedDoc.index].length < 8) {
      db.DocumentsList[Model.SelectedDoc.index].add('none');
    }
    db.DocumentsList[Model.SelectedDoc.index][7] = picked.path;
    db.updateDocuments();
    setState(() {
      Model.SelectedDoc = Document(
        index: Model.SelectedDoc.index,
        name: Model.SelectedDoc.name,
        type: Model.SelectedDoc.type,
        country: Model.SelectedDoc.country,
        val: Model.SelectedDoc.val,
        number: Model.SelectedDoc.number,
        notes: Model.SelectedDoc.notes,
        personId: Model.SelectedDoc.personId,
        photoPath: picked.path,
      );
    });
  }

  void _viewPhoto() {
    final path = Model.SelectedDoc.photoPath;
    if (path == 'none' || path.isEmpty) return;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            InteractiveViewer(
              child: kIsWeb
                  ? Image.network(path, fit: BoxFit.contain)
                  : Image.file(File(path), fit: BoxFit.contain),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();
    final hasPhoto = Model.SelectedDoc.photoPath != 'none' &&
        Model.SelectedDoc.photoPath.isNotEmpty;

    return Scaffold(
      backgroundColor: Style.firstColor,
      body: GestureDetector(
        onTap: () {
          if (_editingNumber) {
            setState(() => _editingNumber = false);
            _saveField(field: 'number', value: _numberCtrl.text);
          }
          if (_editingNotes) {
            setState(() => _editingNotes = false);
            _saveField(field: 'notes', value: _notesCtrl.text);
          }
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            // ── Banner colorido ──────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigation.back(context),
                              icon: const Icon(Icons.arrow_back,
                                  color: Style.secondColor, size: 24),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: _shareDocument,
                              icon: const Icon(Icons.share_outlined,
                                  color: Style.secondColor, size: 22),
                            ),
                            IconButton(
                              onPressed: () =>
                                  Navigation.info_delete(context),
                              icon: const Icon(Icons.delete_outline,
                                  color: Style.secondColor, size: 24),
                            ),
                          ],
                        ),
                      ),
                      Hero(
                        tag: 'doc_icon_${Model.SelectedDoc.name.hashCode}',
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: _typesWithAsset.contains(Model.SelectedDoc.type)
                              ? Image.asset(
                                  _assetForType(Model.SelectedDoc.type),
                                  fit: BoxFit.contain)
                              : Icon(
                                  _iconForType(Model.SelectedDoc.type),
                                  color: Colors.white70,
                                  size: 42),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          Model.SelectedDoc.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: Style.fontButton,
                            fontSize: 17,
                            color: Style.secondColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _statusText(),
                          style: const TextStyle(
                              fontFamily: Style.fontSubButton,
                              fontSize: 12,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              _flagAsset(Model.SelectedDoc.country),
                              width: 28,
                              height: 28,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                  Icons.flag, color: Colors.white54, size: 24),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _formattedVal(),
                            style: const TextStyle(
                                fontFamily: Style.fontSubButton,
                                fontSize: 18,
                                color: Style.secondColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Detalhes ─────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  children: [
                    // ── Foto do documento ────────────────────────────
                    _InfoCard(
                      label: 'Foto do documento',
                      icon: Icons.photo_camera_outlined,
                      trailing: TextButton.icon(
                        onPressed: kIsWeb ? null : _pickPhoto,
                        icon: Icon(
                          hasPhoto ? Icons.edit_outlined : Icons.add_photo_alternate_outlined,
                          size: 15,
                          color: Colors.white54,
                        ),
                        label: Text(
                          hasPhoto ? 'Trocar' : 'Adicionar',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 13),
                        ),
                      ),
                      child: hasPhoto
                          ? GestureDetector(
                              onTap: _viewPhoto,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: kIsWeb
                                    ? Image.network(Model.SelectedDoc.photoPath,
                                        height: 160,
                                        width: double.infinity,
                                        fit: BoxFit.cover)
                                    : Image.file(
                                        File(Model.SelectedDoc.photoPath),
                                        height: 160,
                                        width: double.infinity,
                                        fit: BoxFit.cover),
                              ),
                            )
                          : GestureDetector(
                              onTap: kIsWeb ? null : _pickPhoto,
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white12,
                                      width: 1,
                                      strokeAlign: BorderSide.strokeAlignInside),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_photo_alternate_outlined,
                                          color: Colors.white24, size: 28),
                                      SizedBox(height: 6),
                                      Text(
                                        'Toque para adicionar uma foto',
                                        style: TextStyle(
                                            color: Colors.white24,
                                            fontSize: 12,
                                            fontFamily: Style.fontSubButton),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 14),

                    // ── Número ───────────────────────────────────────
                    _InfoCard(
                      label: 'Número do documento',
                      icon: Icons.tag,
                      trailing: IconButton(
                        icon: Icon(
                          _editingNumber ? Icons.check : Icons.edit_outlined,
                          color: Colors.white54,
                          size: 18,
                        ),
                        onPressed: () {
                          if (_editingNumber) {
                            setState(() => _editingNumber = false);
                            _saveField(
                                field: 'number', value: _numberCtrl.text);
                          } else {
                            setState(() => _editingNumber = true);
                          }
                        },
                      ),
                      child: _editingNumber
                          ? TextField(
                              controller: _numberCtrl,
                              autofocus: true,
                              style: const TextStyle(
                                  color: Style.secondColor,
                                  fontFamily: Style.fontSubButton,
                                  fontSize: 16),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ex: AB123456',
                                  hintStyle:
                                      TextStyle(color: Colors.white24)),
                              onSubmitted: (v) {
                                setState(() => _editingNumber = false);
                                _saveField(field: 'number', value: v);
                              },
                            )
                          : GestureDetector(
                              onTap: () =>
                                  setState(() => _editingNumber = true),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      Model.SelectedDoc.number == 'none'
                                          ? 'Toque para adicionar'
                                          : Model.SelectedDoc.number,
                                      style: TextStyle(
                                        color: Model.SelectedDoc.number ==
                                                'none'
                                            ? Colors.white24
                                            : Style.secondColor,
                                        fontFamily:
                                            Model.SelectedDoc.number == 'none'
                                                ? Style.fontSubButton
                                                : Style.fontTitle,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  if (Model.SelectedDoc.number != 'none')
                                    IconButton(
                                      icon: const Icon(Icons.copy_outlined,
                                          color: Colors.white38, size: 16),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                            text: Model.SelectedDoc.number));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text('Copiado!')));
                                      },
                                    ),
                                ],
                              ),
                            ),
                    ),

                    const SizedBox(height: 14),

                    // ── Observações ──────────────────────────────────
                    _InfoCard(
                      label: 'Observações',
                      icon: Icons.notes,
                      trailing: IconButton(
                        icon: Icon(
                          _editingNotes ? Icons.check : Icons.edit_outlined,
                          color: Colors.white54,
                          size: 18,
                        ),
                        onPressed: () {
                          if (_editingNotes) {
                            setState(() => _editingNotes = false);
                            _saveField(
                                field: 'notes', value: _notesCtrl.text);
                          } else {
                            setState(() => _editingNotes = true);
                          }
                        },
                      ),
                      child: _editingNotes
                          ? TextField(
                              controller: _notesCtrl,
                              autofocus: true,
                              maxLines: 4,
                              style: const TextStyle(
                                  color: Style.secondColor,
                                  fontFamily: Style.fontSubButton,
                                  fontSize: 15),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Adicione uma observação...',
                                  hintStyle:
                                      TextStyle(color: Colors.white24)),
                              onSubmitted: (v) {
                                setState(() => _editingNotes = false);
                                _saveField(field: 'notes', value: v);
                              },
                            )
                          : GestureDetector(
                              onTap: () =>
                                  setState(() => _editingNotes = true),
                              child: Text(
                                Model.SelectedDoc.notes == 'none'
                                    ? 'Toque para adicionar'
                                    : Model.SelectedDoc.notes,
                                style: TextStyle(
                                  color: Model.SelectedDoc.notes == 'none'
                                      ? Colors.white24
                                      : Colors.white70,
                                  fontFamily: Style.fontSubButton,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),

                    // ── Editar validade ──────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: TextButton(
                        onPressed: () => Navigation.info_edit(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(
                                color: Colors.white24, width: 1),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit_calendar_outlined,
                                color: Style.secondColor, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Editar data de validade',
                              style: TextStyle(
                                color: Style.secondColor,
                                fontFamily: Style.fontNextButton,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const _InfoCard(
      {required this.label,
      required this.icon,
      required this.child,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 14),
      decoration: BoxDecoration(
        color: const Color(0xff2A2626),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white38, size: 14),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      fontFamily: Style.fontSubButton,
                      letterSpacing: 0.5)),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

// ── Share Card (gerado como imagem) ────────────────────────────────────────
class _ShareCard extends StatelessWidget {
  final String name;
  final String type;
  final String country;
  final String date;
  final String number;
  final Color color;
  final String flagAsset;
  final bool hasAsset;
  final String assetPath;
  final IconData iconData;

  const _ShareCard({
    required this.name,
    required this.type,
    required this.country,
    required this.date,
    required this.number,
    required this.color,
    required this.flagAsset,
    required this.hasAsset,
    required this.assetPath,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xff1E1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.4), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // header colorido
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: hasAsset
                      ? Image.asset(assetPath, fit: BoxFit.contain)
                      : Icon(iconData, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: Style.fontButton,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // infos
          _ShareRow(icon: Icons.calendar_today_outlined, label: 'Validade', value: date, color: color),
          const SizedBox(height: 10),
          _ShareRow(
            icon: Icons.flag_outlined,
            label: 'País',
            value: country,
            color: color,
            trailing: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Image.asset(flagAsset, width: 24, height: 16,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox()),
            ),
          ),
          if (number != '-') ...[
            const SizedBox(height: 10),
            _ShareRow(icon: Icons.tag, label: 'Número', value: number, color: color),
          ],

          const SizedBox(height: 16),

          // rodapé
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_rounded, color: color, size: 14),
              const SizedBox(width: 6),
              const Text(
                'Valid Doc',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontFamily: Style.fontSubButton,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShareRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Widget? trailing;

  const _ShareRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color.withOpacity(0.7), size: 16),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                color: Colors.white38, fontSize: 12,
                fontFamily: Style.fontSubButton)),
        const Spacer(),
        if (trailing != null) ...[
          trailing!,
          const SizedBox(width: 6),
        ],
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: Style.fontButton)),
      ],
    );
  }
}
