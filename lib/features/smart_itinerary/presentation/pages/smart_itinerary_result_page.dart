import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../cubit/smart_itinerary_cubit.dart';
import '../cubit/smart_itinerary_state.dart';
import '../../../../core/di/injection_container.dart';

class SmartItineraryResultPage extends StatefulWidget {
  final String cityId;
  final int availableMinutes;
  final int budget;
  final List<String> interests;
  final double? userLat;
  final double? userLon;

  const SmartItineraryResultPage({
    super.key,
    required this.cityId,
    required this.availableMinutes,
    required this.budget,
    required this.interests,
    this.userLat,
    this.userLon,
  });

  @override
  State<SmartItineraryResultPage> createState() =>
      _SmartItineraryResultPageState();
}

class _SmartItineraryResultPageState extends State<SmartItineraryResultPage> {
  final Color _bgColor = const Color(0xFF121212);
  final Color _goldColor = const Color(0xFFF3C653);
  final Color _chipBgUnselected = const Color(0xFF2C2C2C);
  late SmartItineraryCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<SmartItineraryCubit>();
    _cubit.generateItinerary(
      cityId: widget.cityId,
      availableMinutes: widget.availableMinutes,
      budget: widget.budget,
      interests: widget.interests,
      userLat: widget.userLat,
      userLon: widget.userLon,
    );
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
        ),
        body: BlocBuilder<SmartItineraryCubit, SmartItineraryState>(
          builder: (context, state) {
            if (state is SmartItineraryLoading ||
                state is SmartItineraryInitial) {
              return Center(
                child: CircularProgressIndicator(color: _goldColor),
              );
            } else if (state is SmartItineraryError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (state is SmartItineraryLoaded) {
              final itinerary = state.itinerary;

              if (itinerary.places.isEmpty) {
                return Center(
                  child: Text(
                    'No places fit your time and budget.\nTry adjusting your criteria.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: Colors.grey.shade400),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Curated Journey',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Summary row
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _chipBgUnselected,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSummaryItem(
                            'Cost',
                            '${itinerary.totalCost} EGP',
                            Icons.attach_money,
                          ),
                          _buildSummaryItem(
                            'Duration',
                            '${itinerary.totalDuration} min',
                            Icons.schedule,
                          ),
                          _buildSummaryItem(
                            'Rating',
                            itinerary.averageRating.toStringAsFixed(1),
                            Icons.star_border,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
                    const SizedBox(height: 40),

                    // Timeline List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itinerary.places.length,
                      itemBuilder: (context, index) {
                        final place = itinerary.places[index];
                        final isFirst = index == 0;
                        final isLast = index == itinerary.places.length - 1;

                        return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Timeline line and dot
                                  SizedBox(
                                    width: 24,
                                    child: Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        Positioned.fill(
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 6,
                                                width: 1,
                                                color: isFirst
                                                    ? Colors.transparent
                                                    : _goldColor.withValues(
                                                        alpha: 0.3,
                                                      ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  width: 1,
                                                  color: isLast
                                                      ? Colors.transparent
                                                      : _goldColor.withValues(
                                                          alpha: 0.3,
                                                        ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isFirst
                                                  ? _goldColor
                                                  : _bgColor,
                                              border: Border.all(
                                                color: _goldColor,
                                                width: isFirst ? 0 : 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Content
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 40.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${place.openingTime} AM • ${isFirst ? 'POINT OF ORIGIN' : 'EXPLORATION'}',
                                            style: GoogleFonts.inter(
                                              color: _goldColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            place.name,
                                            style: GoogleFonts.outfit(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            place.description,
                                            style: GoogleFonts.inter(
                                              color: Colors.grey.shade400,
                                              fontSize: 15,
                                              height: 1.4,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.schedule,
                                                size: 16,
                                                color: Colors.grey.shade500,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${place.visitDuration} min',
                                                style: GoogleFonts.inter(
                                                  color: Colors.grey.shade500,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Icon(
                                                Icons.attach_money,
                                                size: 16,
                                                color: Colors.grey.shade500,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${place.ticketPrice} EGP',
                                                style: GoogleFonts.inter(
                                                  color: Colors.grey.shade500,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Icon(
                                                Icons.star,
                                                size: 16,
                                                color: _goldColor,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                place.rating.toString(),
                                                style: GoogleFonts.inter(
                                                  color: Colors.grey.shade500,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 800.ms, delay: (index * 250).ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              curve: Curves.easeOutQuart,
                            );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: _goldColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 12),
        ),
      ],
    );
  }
}
