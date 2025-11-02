import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reading_preferences_provider.dart';

class ReadingSettingsSheet extends StatelessWidget {
  const ReadingSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Reading Settings',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),

                    // Theme Selector
                    Text(
                      'Theme',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildThemeSelector(context),
                    const SizedBox(height: 24),

                    // Font Family
                    Text(
                      'Font Family',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildFontFamilySelector(context),
                    const SizedBox(height: 24),

                    // Font Size
                    _buildFontSizeSlider(context),
                    const SizedBox(height: 24),

                    // Line Height
                    _buildLineHeightSlider(context),
                    const SizedBox(height: 24),

                    // Brightness
                    _buildBrightnessSlider(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return Consumer<ReadingPreferencesProvider>(
      builder: (context, prefs, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ReaderTheme.values.map((theme) {
              final isSelected = prefs.readerTheme == theme;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () => prefs.setReaderTheme(theme),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          prefs.getThemeIcon(theme),
                          size: 20,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          prefs.getThemeName(theme),
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildFontFamilySelector(BuildContext context) {
    return Consumer<ReadingPreferencesProvider>(
      builder: (context, prefs, _) {
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ReaderFontFamily.values.map((family) {
            final isSelected = prefs.fontFamily == family;
            final fontName = family.toString().split('.').last;
            return InkWell(
              onTap: () => prefs.setFontFamily(family),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Text(
                  fontName.substring(0, 1).toUpperCase() +
                      fontName.substring(1),
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFontSizeSlider(BuildContext context) {
    return Consumer<ReadingPreferencesProvider>(
      builder: (context, prefs, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Font Size',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '${prefs.fontSize.round()}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 10,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 20,
                ),
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                thumbColor: Theme.of(context).colorScheme.primary,
                overlayColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
              child: Slider(
                value: prefs.fontSize,
                min: 12,
                max: 32,
                divisions: 20,
                onChanged: (value) => prefs.setFontSize(value),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLineHeightSlider(BuildContext context) {
    return Consumer<ReadingPreferencesProvider>(
      builder: (context, prefs, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Line Height',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '${prefs.lineHeight.toStringAsFixed(1)}x',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 10,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 20,
                ),
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                thumbColor: Theme.of(context).colorScheme.primary,
                overlayColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
              child: Slider(
                value: prefs.lineHeight,
                min: 1.0,
                max: 2.5,
                divisions: 15,
                onChanged: (value) => prefs.setLineHeight(value),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBrightnessSlider(BuildContext context) {
    return Consumer<ReadingPreferencesProvider>(
      builder: (context, prefs, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Brightness',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '${(prefs.brightness * 100).round()}%',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 10,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 20,
                ),
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                thumbColor: Theme.of(context).colorScheme.primary,
                overlayColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
              child: Slider(
                value: prefs.brightness,
                min: 0.3,
                max: 1.0,
                divisions: 14,
                onChanged: (value) => prefs.setBrightness(value),
              ),
            ),
          ],
        );
      },
    );
  }
}
