import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_spacing.dart';

/// Horizontal scrolling row of premade sample cards with play icons.
class SamplesRow extends StatelessWidget {
  final VoidCallback onTap;
  const SamplesRow({super.key, required this.onTap});

  static const _samples = [
    _SampleData('Al-Fatiha', 'Surah 1', Color(0xFF1A3A5C)),
    _SampleData('Ayat ul-Kursi', 'Surah 2:255', Color(0xFF2D1B4E)),
    _SampleData('Al-Mulk', 'Surah 67', Color(0xFF1B4332)),
    _SampleData('Ar-Rahman', 'Surah 55', Color(0xFF4A3000)),
    _SampleData('Ya-Sin', 'Surah 36', Color(0xFF3B1A1A)),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: _samples.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final s = _samples[i];
          return GestureDetector(
            onTap: onTap,
            child: Container(
              width: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [s.color, s.color.withAlpha(60)],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(80),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white70,
                        size: 28,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(180),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(AppSpacing.radiusMd),
                          bottomRight: Radius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.name,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            s.subtitle,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SampleData {
  final String name;
  final String subtitle;
  final Color color;
  const _SampleData(this.name, this.subtitle, this.color);
}
