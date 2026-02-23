import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valid_doc/model/model.dart';
import 'package:valid_doc/prefabs/style.dart';
import '../../controller/nav_controller.dart';
import '../../prefabs/widget.dart';

class Doc_date extends StatefulWidget {
  @override
  Doc_date_State createState() => Doc_date_State();
}

class Doc_date_State extends State<Doc_date> {
  DateTime _val = DateTime.now().add(const Duration(days: 365 * 5));

  String get _formattedDate =>
      DateFormat('dd / MM / yyyy').format(_val);

  String get _daysFromNow {
    final diff = _val.difference(DateTime.now()).inDays;
    if (diff < 0) return 'Data no passado';
    if (diff == 0) return 'Vence hoje';
    if (diff < 30) return '$diff dias restantes';
    if (diff < 365) return '${(diff / 30).round()} meses restantes';
    final years = diff / 365;
    return '${years.toStringAsFixed(1).replaceAll('.0', '')} anos restantes';
  }

  Color get _dateColor {
    final diff = _val.difference(DateTime.now()).inDays;
    if (diff >= 365 * 2) return const Color(0xff558459);
    if (diff >= 365) return const Color(0xffDA8130);
    if (diff > 183) return const Color(0xffDA4430);
    if (diff >= 0) return const Color(0xffFF0000);
    return const Color(0xff766E6E);
  }

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
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                'Data de validade',
                style: TextStyle(
                  fontFamily: Style.fontTitle,
                  fontSize: 34,
                  color: Style.secondColor,
                ),
              ),
            ),

            // ── Data selecionada em destaque ────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: _dateColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: _dateColor.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        color: _dateColor, size: 22),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formattedDate,
                          style: TextStyle(
                            color: _dateColor,
                            fontFamily: Style.fontTitle,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _daysFromNow,
                          style: TextStyle(
                            color: _dateColor.withOpacity(0.7),
                            fontFamily: Style.fontSubButton,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ── Picker ─────────────────────────────────────────────
            Expanded(
              child: Widgets.date_picker(
                (DateTime newtime) => setState(() => _val = newtime),
                context,
                false,
                _val,
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
                Model.Doc_val =
                    '${_val.day.toString().padLeft(2, '0')}/${_val.month.toString().padLeft(2, '0')}/${_val.year}';
                Navigation.doc_who(context);
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
