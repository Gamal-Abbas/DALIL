import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../cubit/ai_guide_cubit.dart';
import '../cubit/ai_guide_state.dart';
import '../../../../core/di/injection_container.dart';

class AiGuidePage extends StatefulWidget {
  const AiGuidePage({super.key});

  @override
  State<AiGuidePage> createState() => _AiGuidePageState();
}

class _AiGuidePageState extends State<AiGuidePage> {
  late AiGuideCubit _cubit;
  final Color _bgColor = const Color(0xFF121212);
  final Color _goldColor = const Color(0xFFF3C653);

  @override
  void initState() {
    super.initState();
    _cubit = sl<AiGuideCubit>();
    _cubit.startListening();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: _bgColor,
        appBar: AppBar(
          backgroundColor: _bgColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: _goldColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'AI Guide',
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<AiGuideCubit, AiGuideState>(
          builder: (context, state) {
            if (state is AiGuideInitial || state is AiGuideSearching) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _goldColor.withValues(alpha: 0.1),
                        ),
                        child: Icon(
                          Icons.explore_outlined,
                          size: 72,
                          color: _goldColor,
                        ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scaleXY(end: 1.1, duration: 1.seconds),
                      ).animate(onPlay: (controller) => controller.repeat()).custom(
                        duration: 2.seconds,
                        builder: (context, value, child) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _goldColor.withValues(alpha: (1 - value) * 0.3),
                                  spreadRadius: value * 30,
                                ),
                              ],
                            ),
                            child: child,
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'AI Guide is Ready',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn().slideY(),
                      const SizedBox(height: 16),
                      Text(
                        'Walk near any registered landmark and I\'ll automatically start explaining it.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade300,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(),
                      const SizedBox(height: 32),
                      Text(
                        'Listening for nearby attractions...',
                        style: GoogleFonts.inter(
                          color: _goldColor.withValues(alpha: 0.8),
                          fontSize: 13,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w500,
                        ),
                      ).animate(onPlay: (controller) => controller.repeat(reverse: true)).fade(end: 0.5, duration: 1.seconds),
                    ],
                  ),
                ),
              );
            } else if (state is AiGuideGenerating) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _goldColor,
                              shape: BoxShape.circle,
                            ),
                          ).animate(onPlay: (controller) => controller.repeat())
                           .scaleXY(end: 1.5, duration: 400.ms, delay: (index * 200).ms)
                           .then(delay: 400.ms)
                           .scaleXY(end: 1.0 / 1.5);
                        }),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Preparing your guide...',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(),
                      const SizedBox(height: 16),
                      Text(
                        'AI is creating your personalized tour for\n${state.place.name}.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade400,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                    ],
                  ),
                ),
              );
            } else if (state is AiGuideSpeaking) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Icon(
                          Icons.record_voice_over,
                          size: 56,
                          color: _goldColor,
                        ).animate(target: state.isPaused ? 0 : 1).scale(end: const Offset(1.1, 1.1), duration: 500.ms).then().shimmer(duration: 2.seconds, color: Colors.white),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        state.place.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn().slideY(begin: 0.2),
                      const SizedBox(height: 8),
                      Text(
                        state.isPaused ? 'Paused' : 'Speaking...',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: state.isPaused ? Colors.grey.shade400 : _goldColor,
                          fontSize: 14,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ).animate().fade(),
                      const SizedBox(height: 24),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _goldColor.withValues(alpha: 0.2)),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              state.guide,
                              style: GoogleFonts.inter(
                                color: Colors.grey.shade300,
                                fontSize: 16,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 300.ms),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (state.isPaused) {
                                _cubit.resume();
                              } else {
                                _cubit.pause();
                              }
                            },
                            icon: Icon(
                              state.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: _goldColor.withValues(alpha: 0.2),
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _cubit.scanAgain(),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Scan Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E1E1E),
                          foregroundColor: _goldColor,
                          side: BorderSide(color: _goldColor.withValues(alpha: 0.5)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                    ],
                  ),
                ),
              );
            } else if (state is AiGuideError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.red.shade400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
