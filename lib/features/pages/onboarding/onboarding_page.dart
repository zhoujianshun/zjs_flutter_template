import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zjs_flutter_template/config/routes/route_guards.dart';
import 'package:zjs_flutter_template/config/routes/route_paths.dart';
import 'package:zjs_flutter_template/core/utils/logger.dart';

/// Onboarding page for first-time users
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: '欢迎使用',
      description: '这是一个功能强大的Flutter企业级应用模板',
      icon: Icons.flutter_dash,
      color: Colors.blue,
    ),
    OnboardingItem(
      title: '强大功能',
      description: '包含用户认证、主题切换、国际化等企业级功能',
      icon: Icons.star,
      color: Colors.orange,
    ),
    OnboardingItem(
      title: '开始使用',
      description: '现在就开始体验这个优秀的应用模板吧！',
      icon: Icons.rocket_launch,
      color: Colors.green,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: const Text('跳过'),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingItems.length,
                itemBuilder: (context, index) {
                  final item = _onboardingItems[index];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Icon(
                            item.icon,
                            size: 60,
                            color: item.color,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingItems.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: _previousPage,
                      child: const Text('上一步'),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _currentPage == _onboardingItems.length - 1 ? _completeOnboarding : _nextPage,
                    child: Text(
                      _currentPage == _onboardingItems.length - 1 ? '开始使用' : '下一步',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _onboardingItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    AppLogger.info('Onboarding completed');
    await RouteGuards.completeOnboarding();

    if (mounted) {
      context.go(RoutePaths.login);
    }
  }
}

/// Onboarding item data model
class OnboardingItem {
  OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
  final String title;
  final String description;
  final IconData icon;
  final Color color;
}
