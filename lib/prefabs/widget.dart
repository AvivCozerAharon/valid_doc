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
              backgroundImage: AssetImage(
                  'files/flags/${list[index].toString().toLowerCase()}.png'),
            ),
          ],
        ));
      }),
    );
  }

  static Widget date_picker(
      onDateTimeChanged, BuildContext context, bool edit, DateTime date) {
    return CupertinoTheme(
        data: const CupertinoThemeData(
          brightness: Brightness.dark,
        ),
        child: CupertinoDatePicker(
          onDateTimeChanged: onDateTimeChanged,
          initialDateTime: date,
          mode: CupertinoDatePickerMode.date,
          minimumYear: DateTime.now().year - 20,
          maximumYear: DateTime.now().year + 50,
        ));
  }

  static Future<dynamic> color_subtitle(BuildContext context) {
    final items = [
      _LegendItem(
        color: const Color(0xff558459),
        label: 'Mais de 2 anos',
        sublabel: 'Documento em dia',
        icon: Icons.check_circle_outline_rounded,
      ),
      _LegendItem(
        color: const Color(0xffDA8130),
        label: 'Menos de 2 anos',
        sublabel: 'Atenção em breve',
        icon: Icons.schedule_rounded,
      ),
      _LegendItem(
        color: const Color(0xffDA4430),
        label: 'Menos de 1 ano',
        sublabel: 'Planeje a renovação',
        icon: Icons.warning_amber_rounded,
      ),
      _LegendItem(
        color: const Color(0xffFF0000),
        label: 'Menos de 6 meses',
        sublabel: 'Renove com urgência',
        icon: Icons.error_outline_rounded,
      ),
      _LegendItem(
        color: const Color(0xff766E6E),
        label: 'Expirado',
        sublabel: 'Documento vencido',
        icon: Icons.block_rounded,
      ),
    ];

    return showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff2A2626),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ─────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                decoration: const BoxDecoration(
                  color: Color(0xff383434),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.palette_outlined,
                        color: Colors.white54, size: 20),
                    const SizedBox(width: 10),
                    const Text(
                      'Legenda das cores',
                      style: TextStyle(
                        fontFamily: Style.fontTitle,
                        fontSize: 22,
                        color: Style.secondColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close,
                          color: Colors.white38, size: 20),
                    ),
                  ],
                ),
              ),

              // ── Items ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(
                  children: items
                      .map((item) => _buildLegendRow(item))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildLegendRow(_LegendItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: item.color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: item.color.withOpacity(0.35), width: 1),
        ),
        child: Row(
          children: [
            // ícone com fundo colorido
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: item.color, size: 20),
            ),
            const SizedBox(width: 14),
            // textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: const TextStyle(
                      color: Style.secondColor,
                      fontFamily: Style.fontButton,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.sublabel,
                    style: TextStyle(
                      color: item.color.withOpacity(0.8),
                      fontFamily: Style.fontSubButton,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // bolinha colorida
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: item.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: item.color.withOpacity(0.5),
                    blurRadius: 6,
                    spreadRadius: 1,
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

class _LegendItem {
  final Color color;
  final String label;
  final String sublabel;
  final IconData icon;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.sublabel,
    required this.icon,
  });
}
