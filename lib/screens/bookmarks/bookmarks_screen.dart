import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/services/bookmark_service.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  Widget build(BuildContext context) {
    final bookmarks = BookmarkService.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Surahs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: bookmarks.isEmpty ? _buildEmpty() : _buildList(bookmarks),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bookmark_border_rounded,
              size: 64, color: AppColors.textMuted.withAlpha(80)),
          const SizedBox(height: 16),
          Text(
            'No bookmarked surahs yet',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bookmark surahs while selecting ayahs\nto track your reel-making progress',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> bookmarks) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: bookmarks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final bm = bookmarks[i];
        final surahNum = bm['surahNumber'] as int;
        final surahName = bm['surahName'] as String;
        final totalAyahs = bm['totalAyahs'] as int;
        final progress = BookmarkService.getProgress(surahNum);
        final covered = BookmarkService.getCoveredAyahs(surahNum);
        final ranges = (bm['completedRanges'] as List)
            .map((r) => (r as List).cast<int>())
            .toList();

        return _SurahProgressCard(
          surahNumber: surahNum,
          surahName: surahName,
          totalAyahs: totalAyahs,
          progress: progress,
          coveredAyahs: covered,
          rangesCompleted: ranges.length,
          onTap: () {
            // Navigate to ayah selection to continue working on this surah
            context.push('/quran-reels');
          },
          onRemove: () {
            BookmarkService.toggleBookmark(
              surahNumber: surahNum,
              surahName: surahName,
              totalAyahs: totalAyahs,
            );
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$surahName removed from bookmarks'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }
}

// ── Surah progress card ──

class _SurahProgressCard extends StatelessWidget {
  final int surahNumber;
  final String surahName;
  final int totalAyahs;
  final double progress;
  final int coveredAyahs;
  final int rangesCompleted;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _SurahProgressCard({
    required this.surahNumber,
    required this.surahName,
    required this.totalAyahs,
    required this.progress,
    required this.coveredAyahs,
    required this.rangesCompleted,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final percentText = '${(progress * 100).round()}%';
    final isComplete = progress >= 1.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isComplete
                ? AppColors.success.withAlpha(80)
                : AppColors.primary.withAlpha(30),
          ),
          boxShadow: isComplete
              ? [
                  BoxShadow(
                    color: AppColors.success.withAlpha(15),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Progress ring
            CircularPercentIndicator(
              radius: 32,
              lineWidth: 5,
              percent: progress,
              center: Text(
                percentText,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: isComplete ? AppColors.success : AppColors.primary,
                ),
              ),
              progressColor: isComplete ? AppColors.success : AppColors.primary,
              backgroundColor: isComplete
                  ? AppColors.success.withAlpha(25)
                  : AppColors.primary.withAlpha(25),
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 600,
            ),
            const SizedBox(width: AppSpacing.md),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$surahNumber',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          surahName,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isComplete)
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.success, size: 20),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$coveredAyahs / $totalAyahs ayahs covered · $rangesCompleted reel${rangesCompleted != 1 ? 's' : ''} made',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.bgCardLight,
                      valueColor: AlwaysStoppedAnimation(
                        isComplete ? AppColors.success : AppColors.primary,
                      ),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Remove button
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.bookmark_remove_rounded,
                color: AppColors.textMuted.withAlpha(120),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
