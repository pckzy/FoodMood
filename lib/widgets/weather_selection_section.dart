import 'package:flutter/material.dart';
import 'package:foodmood/models/weather.dart';
import 'package:foodmood/services/weather_service.dart';
import 'package:foodmood/widgets/weather_button.dart';

class WeatherSelectionSection extends StatefulWidget {
  final String? selectedWeather;
  final Function(String) onWeatherSelected;
  final Color primaryColor;
  final Color cardColor;
  final Color textColor;
  final Color subtextColor;
  final Function(List<Weather>) onWeatherLoaded;

  const WeatherSelectionSection({
    super.key,
    required this.selectedWeather,
    required this.onWeatherSelected,
    required this.primaryColor,
    required this.cardColor,
    required this.textColor,
    required this.subtextColor,
    required this.onWeatherLoaded,
  });

  @override
  State<WeatherSelectionSection> createState() =>
      _WeatherSelectionSectionState();
}

class _WeatherSelectionSectionState extends State<WeatherSelectionSection> {
  final WeatherService _weatherService = WeatherService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weather outside?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'We\'ll find the perfect comfort food',
                style: TextStyle(
                  fontSize: 14,
                  color: widget.subtextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        FutureBuilder<List<Weather>>(
          future: _weatherService.fetchWeatherOptions(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Error loading weather',
                  style: TextStyle(color: widget.textColor),
                ),
              );
            }

            final weatherOptions = snapshot.data ?? [];
            if (weatherOptions.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  widget.onWeatherLoaded(weatherOptions);
                }
              });
            }

            if (weatherOptions.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'No weather options available',
                  style: TextStyle(color: widget.subtextColor),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ...weatherOptions.map((weather) {
                    return WeatherButton(
                      weather.name,
                      widget.primaryColor,
                      widget.cardColor,
                      widget.textColor,
                      isSelected: widget.selectedWeather == weather.name,
                      onTap: () {
                        widget.onWeatherSelected(weather.name);
                      },
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
