import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'smart_itinerary_result_page.dart';

class SmartItineraryPage extends StatefulWidget {
  const SmartItineraryPage({super.key});

  @override
  State<SmartItineraryPage> createState() => _SmartItineraryPageState();
}

class _SmartItineraryPageState extends State<SmartItineraryPage> {
  String _selectedCity = 'cairo';
  double _availableHours = 4.5;
  double _budget = 500.0;
  final Set<String> _selectedInterests = {'History', 'Museum'};

  final List<Map<String, String>> _cities = [
    {'id': 'cairo', 'name': 'Cairo'},
    {'id': 'giza', 'name': 'Giza'},
    {'id': 'luxor', 'name': 'Luxor'},
    {'id': 'aswan', 'name': 'Aswan'},
  ];

  final List<String> _interestsOptions = [
    'History', 'Museum', 'Photography', 'Nature', 'Shopping', 'Food', 'Family'
  ];

  final Color _bgColor = const Color(0xFF121212);
  final Color _cardColor = const Color(0xFF1E1E1E);
  final Color _goldColor = const Color(0xFFF3C653);
  final Color _chipBgUnselected = const Color(0xFF2C2C2C);
  final Color _chipTextUnselected = const Color(0xFFAAAAAA);

  bool _isLoadingLocation = false;

  Future<void> _navigateToResults() async {
    if (_isLoadingLocation) return;
    setState(() => _isLoadingLocation = true);

    double? userLat;
    double? userLon;

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 5),
          ),
        );
        userLat = position.latitude;
        userLon = position.longitude;
      }
    } catch (e) {
      debugPrint("Failed to get location: \$e");
    }

    if (!mounted) return;
    setState(() => _isLoadingLocation = false);

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SmartItineraryResultPage(
          cityId: _selectedCity,
          availableMinutes: (_availableHours * 60).toInt(),
          budget: _budget.toInt(),
          interests: _selectedInterests.toList(),
          userLat: userLat,
          userLon: userLon,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Slide from right
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Text(
                      'CURATION ENGINE',
                      style: GoogleFonts.inter(
                        color: _goldColor.withValues(alpha: 0.8),
                        fontSize: 12,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Smart Itinerary',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Define your parameters. Let the digital curator weave history into your journey through time and space.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade400,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // City Dropdown Card (First)
              _buildDarkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Destination',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: _chipBgUnselected,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCity,
                          dropdownColor: _cardColor,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: _goldColor),
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                          items: _cities.map((city) {
                            return DropdownMenuItem(
                              value: city['id'],
                              child: Text(city['name']!),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedCity = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Time Available Card (Second)
              _buildDarkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time Available',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${_availableHours.toStringAsFixed(1).replaceAll('.0', '')} Hours',
                          style: GoogleFonts.inter(
                            color: _goldColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: _goldColor,
                        inactiveTrackColor: Colors.grey.shade800,
                        thumbColor: _goldColor,
                        trackHeight: 4.0,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
                      ),
                      child: Slider(
                        value: _availableHours,
                        min: 1,
                        max: 12,
                        divisions: 11,
                        onChanged: (val) => setState(() => _availableHours = val),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSliderLabel('1 HOUR'),
                          _buildSliderLabel('6 HOURS'),
                          _buildSliderLabel('12 HOURS'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Interests Card
              _buildDarkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interests',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12.0,
                      runSpacing: 12.0,
                      children: _interestsOptions.map((interest) {
                        final isSelected = _selectedInterests.contains(interest);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedInterests.remove(interest);
                              } else {
                                _selectedInterests.add(interest);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? _goldColor : _chipBgUnselected,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              interest,
                              style: GoogleFonts.inter(
                                color: isSelected ? Colors.black87 : _chipTextUnselected,
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Budget Card
              _buildDarkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Budget',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${_budget.toInt()} EGP',
                          style: GoogleFonts.inter(
                            color: _goldColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: _goldColor,
                        inactiveTrackColor: Colors.grey.shade800,
                        thumbColor: _goldColor,
                        trackHeight: 4.0,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                      ),
                      child: Slider(
                        value: _budget,
                        min: 100,
                        max: 1500,
                        divisions: 14,
                        onChanged: (val) => setState(() => _budget = val),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              
              // Generate Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _goldColor,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _navigateToResults,
                  child: _isLoadingLocation
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.black87, strokeWidth: 2),
                        )
                      : Text(
                          'Generate My Itinerary',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDarkCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildSliderLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: Colors.grey.shade600,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
      ),
    );
  }
}
