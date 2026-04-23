import 'dart:ui';
import 'package:dalil/features/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:dalil/generated/l10n.dart';

class OnboardingScreen extends StatefulWidget {
  final Function(Locale) onChangeLocale; // 🔥 نتحكم في اللغة من برا

  const OnboardingScreen({super.key, required this.onChangeLocale});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController controller = PageController();
  int currentPage = 0;

  Locale currentLocale = const Locale('en'); // ✅ اللغة الحالية

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

    return Scaffold(
      body: Stack(
        children: [
          /// الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pyram.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          SafeArea(
            child: Directionality(
              textDirection:
                  currentLocale.languageCode == 'ar'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  /// Logo
                  const Text(
                    "D A L I L",
                    style: TextStyle(
                      color: Color(0xFFE5C158),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                  ),
                  const Text(
                    "THE DIGITAL CURATOR",
                    style: TextStyle(
                      color: Color(0xFFE5C158),
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
                  ),

                  const Spacer(),

                  /// PageView
                  SizedBox(
                    height: 420,
                    child: PageView.builder(
                      controller: controller,
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = index;
                        });
                      },
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return _buildPage(index, loc);
                      },
                    ),
                  ),

                  const Spacer(),

                  /// Footer
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text("DISCOVERY MODE",
                                style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 8)),
                            Text("IMMERSIVE_AR",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10)),
                          ],
                        ),

                        /// 🔥 تغيير اللغة
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              currentLocale =
                                  currentLocale.languageCode == 'en'
                                      ? const Locale('ar')
                                      : const Locale('en');
                            });

                            widget.onChangeLocale(currentLocale); // مهم
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.language,
                                  color: Color(0xFFE5C158),
                                  size: 16),
                              const SizedBox(width: 5),
                              Text(
                                loc.language,
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 شكل الصفحة
  Widget _buildPage(int index, S loc) {
    String title;
    String desc;

    if (index == 0) {
      title = loc.title1;
      desc = loc.desc1;
    } else if (index == 1) {
      title = loc.title2;
      desc = loc.desc2;
    } else {
      title = loc.title3;
      desc = loc.desc3;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: 40, horizontal: 25),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "ESTABLISHED 2024  •  CAIRO, EGYPT",
                  style: TextStyle(
                    color: Color(0xFFE5C158),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),

                /// Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),

                if (index == 2)
                  Text(
                    loc.antiquity,
                    style: const TextStyle(
                      color: Color(0xFFE5C158),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                const SizedBox(height: 20),

                /// Description
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 35),

                /// زرار
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5C158),
                    foregroundColor: Colors.black,
                    minimumSize:
                        const Size(double.infinity, 55),
                  ),
                  onPressed: () {
                    if (index < 2) {
                      controller.nextPage(
                        duration:
                            const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const HomeScreen(),
                        ),
                      );
                    }
                  },
                  child: Text(
                    index == 2 ? loc.start : loc.next,
                  ),
                ),

                const SizedBox(height: 20),

                /// Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (i) => AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 300),
                      margin:
                          const EdgeInsets.symmetric(horizontal: 4),
                      height: 2,
                      width: currentPage == i ? 20 : 15,
                      decoration: BoxDecoration(
                        color: currentPage == i
                            ? const Color(0xFFE5C158)
                            : Colors.white24,
                        borderRadius:
                            BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}