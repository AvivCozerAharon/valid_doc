import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valid_doc/model/countries.dart';
import 'package:valid_doc/prefabs/style.dart';

class DocumentTile extends StatelessWidget {
  final String name;
  final String val;
  final String type;
  final String country;
  final Function() onPressed;
  final String? personName;

  const DocumentTile({
    super.key,
    required this.name,
    required this.type,
    required this.country,
    required this.val,
    required this.onPressed,
    this.personName,
  });

  Color _statusColor() {
    try {
      DateTime checkVal;
      try {
        checkVal = DateFormat('dd/MM/yyyy').parse(val);
      } catch (_) {
        checkVal = DateFormat('d/M/yyyy').parse(val);
      }
      final int difference = checkVal.difference(DateTime.now()).inDays;
      if (difference >= 365 * 2) return const Color(0xff558459);
      if (difference >= 365) return const Color(0xffDA8130);
      if (difference > 183) return const Color(0xffDA4430);
      if (difference >= 0) return const Color(0xffFF0000);
      return const Color(0xff766E6E);
    } catch (_) {
      return const Color(0xff766E6E);
    }
  }

  String _formattedVal() {
    try {
      DateTime date;
      try {
        date = DateFormat('dd/MM/yyyy').parse(val);
      } catch (_) {
        date = DateFormat('d/M/yyyy').parse(val);
      }
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return val;
    }
  }

  String _daysLabel() {
    try {
      DateTime date;
      try {
        date = DateFormat('dd/MM/yyyy').parse(val);
      } catch (_) {
        date = DateFormat('d/M/yyyy').parse(val);
      }
      final diff = date.difference(DateTime.now()).inDays;
      if (diff < 0) return 'Expirado';
      if (diff == 0) return 'Expira hoje!';
      if (diff < 30) return '$diff dias restantes';
      if (diff < 365) return '${(diff / 30).round()} meses restantes';
      return '${(diff / 365 * 10).round() / 10} anos restantes';
    } catch (_) {
      return '';
    }
  }

  static const _typesWithAsset = {'passport', 'id', 'car_id', 'visa'};

  bool _hasAsset(String t) => _typesWithAsset.contains(t);

  String _assetForType(String t) {
    if (t == 'id') return 'files/ident.png';
    return 'files/$t.png';
  }

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

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.45),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // ── Ícone do documento ──────────────────────────────
                Hero(
                  tag: 'doc_icon_${name.hashCode}',
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: _hasAsset(type)
                        ? Image.asset(_assetForType(type), fit: BoxFit.contain)
                        : Icon(_iconForType(type),
                              color: Colors.white70, size: 36),
                  ),
                ),
                const SizedBox(width: 14),

                // ── Textos ──────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: Style.fontButton,
                          fontSize: 15,
                          color: Style.secondColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formattedVal(),
                        style: const TextStyle(
                          fontFamily: Style.fontSubButton,
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _daysLabel(),
                        style: const TextStyle(
                          fontFamily: Style.fontSubButton,
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                      if (personName != null && personName!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.person_outline,
                                  color: Colors.white30, size: 11),
                              const SizedBox(width: 3),
                              Text(
                                personName!,
                                style: const TextStyle(
                                  color: Colors.white30,
                                  fontSize: 11,
                                  fontFamily: Style.fontSubButton,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // ── Bandeira + chevron ──────────────────────────────
                Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        _flagAsset(country),
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.flag, color: Colors.white38, size: 24),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Icon(Icons.chevron_right,
                        color: Colors.white38, size: 18),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
