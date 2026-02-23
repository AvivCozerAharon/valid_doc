import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:valid_doc/prefabs/style.dart';
import 'package:valid_doc/view/home.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  final _pages = const [_Page1(), _Page2(), _Page3()];

  void _next() {
    HapticFeedback.lightImpact();
    if (_page < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isLast = _page == _pages.length - 1;

    return Scaffold(
      backgroundColor: Style.firstColor,
      body: Stack(
        children: [
          // ── Páginas ─────────────────────────────────────────────
          PageView(
            controller: _controller,
            onPageChanged: (i) {
              HapticFeedback.selectionClick();
              setState(() => _page = i);
            },
            children: _pages,
          ),

          // ── Indicadores + botão ──────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                child: Column(
                  children: [
                    // dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages.length, (i) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _page ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _page
                                ? const Color(0xff558459)
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 32),

                    // botão
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: TextButton(
                        onPressed: _next,
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xff558459),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          isLast ? l.getStarted : l.next,
                          style: const TextStyle(
                            color: Style.secondColor,
                            fontFamily: Style.fontNextButton,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),

                    if (!isLast)
                      TextButton(
                        onPressed: _finish,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white38,
                            fontFamily: Style.fontSubButton,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Páginas individuais ────────────────────────────────────────────────────

class _Page1 extends StatelessWidget {
  const _Page1();
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return _OnboardPage(
      icon: Icons.verified_rounded,
      iconColor: const Color(0xff558459),
      title: l.onboardTitle1,
      body: l.onboardBody1,
    );
  }
}

class _Page2 extends StatelessWidget {
  const _Page2();
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return _OnboardPage(
      icon: Icons.people_alt_rounded,
      iconColor: const Color(0xff4A7DB5),
      title: l.onboardTitle2,
      body: l.onboardBody2,
    );
  }
}

class _Page3 extends StatelessWidget {
  const _Page3();
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return _OnboardPage(
      icon: Icons.notifications_active_rounded,
      iconColor: const Color(0xffDA8130),
      title: l.onboardTitle3,
      body: l.onboardBody3,
    );
  }
}

class _OnboardPage extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  const _OnboardPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 80, 32, 160),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ícone grande
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: iconColor.withOpacity(0.3), width: 2),
            ),
            child: Icon(icon, color: iconColor, size: 56),
          ),
          const SizedBox(height: 48),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: Style.fontTitle,
              fontSize: 36,
              color: Style.secondColor,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            body,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: Style.fontSubButton,
              fontSize: 16,
              color: Colors.white54,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
