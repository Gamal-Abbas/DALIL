import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/smart_itinerary_cubit.dart';
import '../cubit/smart_itinerary_state.dart';
import '../../../../core/di/injection_container.dart';

class SmartItineraryPage extends StatefulWidget {
  const SmartItineraryPage({super.key});

  @override
  State<SmartItineraryPage> createState() => _SmartItineraryPageState();
}

class _SmartItineraryPageState extends State<SmartItineraryPage> {
  String _selectedCity = 'cairo';
  double _availableHours = 6.0;
  double _budget = 1000.0;
  final Set<String> _selectedInterests = {};

  final List<Map<String, String>> _cities = [
    {'id': 'cairo', 'name': 'Cairo'},
    {'id': 'giza', 'name': 'Giza'},
    {'id': 'luxor', 'name': 'Luxor'},
    {'id': 'aswan', 'name': 'Aswan'},
  ];

  final List<String> _interestsOptions = [
    'History', 'Museum', 'Photography', 'Nature', 'Shopping', 'Food', 'Family'
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SmartItineraryCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Itinerary Builder'),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: _buildInputForm(),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              flex: 6,
              child: _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _selectedCity,
            decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
            items: _cities.map((city) {
              return DropdownMenuItem(
                value: city['id'],
                child: Text(city['name']!),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedCity = val);
            },
          ),
          const SizedBox(height: 16),
          Text('Available Time: ${_availableHours.toInt()} hours', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: _availableHours,
            min: 2,
            max: 12,
            divisions: 10,
            label: '${_availableHours.toInt()}h',
            onChanged: (val) => setState(() => _availableHours = val),
          ),
          Text('Budget: ${_budget.toInt()} EGP', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: _budget,
            min: 100,
            max: 3000,
            divisions: 29,
            label: '${_budget.toInt()} EGP',
            onChanged: (val) => setState(() => _budget = val),
          ),
          const SizedBox(height: 16),
          Text('Interests:', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: _interestsOptions.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedInterests.add(interest);
                    } else {
                      _selectedInterests.remove(interest);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Builder(
            builder: (context) {
              return FilledButton.icon(
                icon: const Icon(Icons.auto_awesome),
                onPressed: () {
                  context.read<SmartItineraryCubit>().generateItinerary(
                    cityId: _selectedCity,
                    availableMinutes: (_availableHours * 60).toInt(),
                    budget: _budget.toInt(),
                    interests: _selectedInterests.toList(),
                  );
                },
                label: const Text('Generate Itinerary'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return BlocBuilder<SmartItineraryCubit, SmartItineraryState>(
      builder: (context, state) {
        if (state is SmartItineraryInitial) {
          return const Center(
            child: Text('Select options and generate an itinerary.', textAlign: TextAlign.center),
          );
        } else if (state is SmartItineraryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SmartItineraryError) {
          return Center(
            child: Text(
              state.message, 
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            )
          );
        } else if (state is SmartItineraryLoaded) {
          final itinerary = state.itinerary;
          
          if (itinerary.places.isEmpty) {
            return const Center(
              child: Text('No places fit your time and budget.\nTry adjusting your criteria.', textAlign: TextAlign.center),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryItem('Cost', '${itinerary.totalCost} EGP', Icons.attach_money),
                        _buildSummaryItem('Duration', '${itinerary.totalDuration} min', Icons.timer),
                        _buildSummaryItem('Avg Rating', itinerary.averageRating.toStringAsFixed(1), Icons.star),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: itinerary.places.length,
                  itemBuilder: (context, index) {
                    final place = itinerary.places[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(place.name, style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 4),
                            Text(place.description, style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                Chip(
                                  avatar: const Icon(Icons.star, size: 16),
                                  label: Text(place.rating.toString()),
                                  padding: EdgeInsets.zero,
                                ),
                                Chip(
                                  avatar: const Icon(Icons.money, size: 16),
                                  label: Text('${place.ticketPrice} EGP'),
                                  padding: EdgeInsets.zero,
                                ),
                                Chip(
                                  avatar: const Icon(Icons.schedule, size: 16),
                                  label: Text('${place.visitDuration} min'),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Categories: ${place.categories.join(", ")}', 
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
