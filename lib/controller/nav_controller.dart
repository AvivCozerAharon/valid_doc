import 'package:flutter/material.dart';
import 'package:valid_doc/view/INFO_doc/info_delete.dart';
import 'package:valid_doc/view/INFO_doc/info_edit.dart';
import 'package:valid_doc/view/INFO_doc/info_home.dart';
import 'package:valid_doc/view/N_doc/doc_country.dart';
import 'package:valid_doc/view/N_doc/doc_type.dart';
import 'package:valid_doc/view/N_doc/doc_who.dart';
import 'package:valid_doc/view/home.dart';
import 'package:valid_doc/view/person_docs.dart';
import '../view/N_doc/doc_date.dart';

// ── Transições customizadas ────────────────────────────────────────────────

/// Slide da direita para a esquerda (padrão para avançar no fluxo)
PageRoute _slideRight(Widget page) => PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (_, anim, secAnim, child) {
        final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn));
        return FadeTransition(
          opacity: anim.drive(fadeTween),
          child: SlideTransition(position: anim.drive(tween), child: child),
        );
      },
    );

/// Slide para cima (para modais / detalhes)
PageRoute _slideUp(Widget page) => PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      transitionsBuilder: (_, anim, secAnim, child) {
        final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: anim.drive(tween), child: child);
      },
    );

/// Fade simples (para home e telas destrutivas)
PageRoute _fade(Widget page) => PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
    );

// ── Navegação ──────────────────────────────────────────────────────────────

class Navigation {
  static void home(context) => Navigator.pushAndRemoveUntil(
        context,
        _fade(const Home()),
        (route) => false,
      );

  static void person_docs(context) => Navigator.push(
        context,
        _slideRight(const PersonDocs()),
      );

  static void info_home(context) => Navigator.push(
        context,
        _slideUp(Info_home()),
      );

  static void info_edit(context) => Navigator.push(
        context,
        _slideRight(Info_edit()),
      );

  static void info_delete(context) => Navigator.push(
        context,
        _slideRight(Info_delete()),
      );

  static void doc_type(context) => Navigator.push(
        context,
        _slideRight(Doc_type()),
      );

  static void doc_country(context) => Navigator.push(
        context,
        _slideRight(Doc_country()),
      );

  static void doc_date(context) => Navigator.push(
        context,
        _slideRight(Doc_date()),
      );

  static void doc_who(context) => Navigator.push(
        context,
        _slideRight(Doc_who()),
      );

  static void back(context) => Navigator.pop(context);
}
