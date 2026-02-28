import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Shows a daily rotating surah suggestion on the home screen.
/// Uses the day of year to pick one of the 114 surahs deterministically.
class SurahOfTheDay extends StatelessWidget {
  final void Function(Map<String, dynamic> surah) onTap;

  const SurahOfTheDay({super.key, required this.onTap});

  // Basic surah info — avoids needing an API call.
  static const _surahs = <Map<String, dynamic>>[
    {'number': 1, 'name': 'Al-Fatiha', 'arabic': 'الفاتحة', 'ayahs': 7, 'meaning': 'The Opening'},
    {'number': 2, 'name': 'Al-Baqarah', 'arabic': 'البقرة', 'ayahs': 286, 'meaning': 'The Cow'},
    {'number': 3, 'name': 'Ali \'Imran', 'arabic': 'آل عمران', 'ayahs': 200, 'meaning': 'Family of Imran'},
    {'number': 18, 'name': 'Al-Kahf', 'arabic': 'الكهف', 'ayahs': 110, 'meaning': 'The Cave'},
    {'number': 36, 'name': 'Ya-Sin', 'arabic': 'يس', 'ayahs': 83, 'meaning': 'Ya Sin'},
    {'number': 55, 'name': 'Ar-Rahman', 'arabic': 'الرحمن', 'ayahs': 78, 'meaning': 'The Most Merciful'},
    {'number': 56, 'name': 'Al-Waqi\'ah', 'arabic': 'الواقعة', 'ayahs': 96, 'meaning': 'The Event'},
    {'number': 67, 'name': 'Al-Mulk', 'arabic': 'الملك', 'ayahs': 30, 'meaning': 'The Sovereignty'},
    {'number': 73, 'name': 'Al-Muzzammil', 'arabic': 'المزمل', 'ayahs': 20, 'meaning': 'The Enshrouded One'},
    {'number': 78, 'name': 'An-Naba', 'arabic': 'النبأ', 'ayahs': 40, 'meaning': 'The Tidings'},
    {'number': 87, 'name': 'Al-A\'la', 'arabic': 'الأعلى', 'ayahs': 19, 'meaning': 'The Most High'},
    {'number': 93, 'name': 'Ad-Duhaa', 'arabic': 'الضحى', 'ayahs': 11, 'meaning': 'The Morning Hours'},
    {'number': 96, 'name': 'Al-Alaq', 'arabic': 'العلق', 'ayahs': 19, 'meaning': 'The Clot'},
    {'number': 97, 'name': 'Al-Qadr', 'arabic': 'القدر', 'ayahs': 5, 'meaning': 'The Power'},
    {'number': 99, 'name': 'Az-Zalzalah', 'arabic': 'الزلزلة', 'ayahs': 8, 'meaning': 'The Earthquake'},
    {'number': 100, 'name': 'Al-Adiyat', 'arabic': 'العاديات', 'ayahs': 11, 'meaning': 'The Courser'},
    {'number': 102, 'name': 'At-Takathur', 'arabic': 'التكاثر', 'ayahs': 8, 'meaning': 'The Rivalry'},
    {'number': 103, 'name': 'Al-Asr', 'arabic': 'العصر', 'ayahs': 3, 'meaning': 'The Declining Day'},
    {'number': 108, 'name': 'Al-Kawthar', 'arabic': 'الكوثر', 'ayahs': 3, 'meaning': 'The Abundance'},
    {'number': 112, 'name': 'Al-Ikhlas', 'arabic': 'الإخلاص', 'ayahs': 4, 'meaning': 'The Sincerity'},
    {'number': 113, 'name': 'Al-Falaq', 'arabic': 'الفلق', 'ayahs': 5, 'meaning': 'The Daybreak'},
    {'number': 114, 'name': 'An-Nas', 'arabic': 'الناس', 'ayahs': 6, 'meaning': 'Mankind'},
  ];

  Map<String, dynamic> get _todaysSurah {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return _surahs[dayOfYear % _surahs.length];
  }

  @override
  Widget build(BuildContext context) {
    final surah = _todaysSurah;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: GestureDetector(
        onTap: () => onTap(surah),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A3A5C), Color(0xFF0D253F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: AppColors.primary.withAlpha(60),
            ),
          ),
          child: Row(
            children: [
              // Left — icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Middle — text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Surah of the Day',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${surah['name']} — ${surah['meaning']}',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${surah['ayahs']} ayahs · Tap to create a reel',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Right — Arabic name
              Text(
                surah['arabic'] as String,
                style: GoogleFonts.amiri(
                  fontSize: 26,
                  color: AppColors.primary.withAlpha(180),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
