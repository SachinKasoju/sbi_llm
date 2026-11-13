import 'package:flutter/material.dart';
import '../../utils/global_colors.dart';
import '../../widgets/text_style.dart';
import '../auth/login_page.dart';


class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _ctrl = PageController();
  int _page = 0;

  static const _pages = <(IconData, String, String)>[
    (Icons.auto_stories, 'Welcome', 'Discover a world of knowledge and unlock your potential with our curated courses'),
    (Icons.play_circle_fill, 'Learn at your pace', 'Access courses anytime, anywhere, and track your progress as you grow.'),
    (Icons.workspace_premium, 'Showcase Your Skills', 'Complete courses to earn certificates and take your career to new heights.'),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _finish() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => const LoginPage()));

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final last = _page == _pages.length - 1;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _finish,
              child: Text(
                'Skip',
                style: appTextStyle(
                  font: 'lexend',
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _ctrl,
              itemCount: _pages.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.all(32),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CircleAvatar(
                    radius: 90,
                    backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                    child: Icon(_pages[i].$1, size: 90, color: AppColors.primaryColor),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    _pages[i].$2,
                    textAlign: TextAlign.center,
                    style: appTextStyle(
                      font: 'lexend',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _pages[i].$3,
                    textAlign: TextAlign.center,
                    style: appTextStyle(
                      font: 'lexend',
                      color: AppColors.primaryColor.withOpacity(0.8),
                      fontSize: 15,
                    ),
                  ),
                ]),
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (int i = 0; i < _pages.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                width: i == _page ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == _page
                      ? AppColors.primaryColor
                      : AppColors.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ]),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: last
                    ? _finish
                    : () => _ctrl.nextPage(
                        duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
                child: Text(
                  last ? 'Get Started' : 'Next',
                  style: appTextStyle(
                    font: 'lexend',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
