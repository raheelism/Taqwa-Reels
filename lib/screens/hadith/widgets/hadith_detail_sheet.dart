import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/hadith.dart';

/// Full-screen bottom sheet showing a single hadith.
class HadithDetailSheet extends StatelessWidget {
  final Hadith hadith;
  final VoidCallback? onCreateReel;

  const HadithDetailSheet({super.key, required this.hadith, this.onCreateReel});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withAlpha(80),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.xs,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D1B4E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '📜 ${hadith.bookName}',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFB388FF),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (hadith.grades.isNotEmpty)
                      _GradeBadge(grade: hadith.grades.first.grade),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textMuted,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),

              // Reference
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    const Icon(
                      Icons.bookmark_rounded,
                      size: 12,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Hadith #${hadith.hadithNumber} — ${hadith.reference}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              const Divider(color: AppColors.bgCard, height: 1),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    // Arabic
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1E1040), Color(0xFF130B2B)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(40),
                        ),
                      ),
                      child: Text(
                        hadith.arabicText,
                        style: GoogleFonts.amiri(
                          fontSize: 22,
                          height: 2.2,
                          color: AppColors.primary,
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Translation
                    _buildSection(
                      icon: Icons.translate_rounded,
                      label: hadith.translationLang,
                      child: Text(
                        hadith.translationText,
                        style: hadith.translationLang == 'Urdu'
                            ? GoogleFonts.notoNastaliqUrdu(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                                height: 2.4,
                              )
                            : GoogleFonts.outfit(
                                fontSize: 15,
                                color: AppColors.textPrimary,
                                height: 1.7,
                              ),
                        textDirection: hadith.translationLang == 'Urdu'
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                      ),
                    ),

                    // Chapter
                    if (hadith.sectionName != null &&
                        hadith.sectionName!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSection(
                        icon: Icons.bookmark_rounded,
                        label: 'Chapter',
                        child: Text(
                          hadith.sectionName!,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],

                    // Grades
                    if (hadith.grades.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSection(
                        icon: Icons.verified_rounded,
                        label: 'Grades',
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: hadith.grades.map((g) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _gradeColor(g.grade).withAlpha(20),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _gradeColor(g.grade).withAlpha(80),
                                ),
                              ),
                              child: Text(
                                '${g.name}: ${g.grade}',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _gradeColor(g.grade),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: _ActionBtn(
                            icon: Icons.copy_rounded,
                            label: 'Copy',
                            onTap: () => _copy(context),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ActionBtn(
                            icon: Icons.share_rounded,
                            label: 'Share',
                            onTap: _share,
                          ),
                        ),
                      ],
                    ),

                    if (onCreateReel != null) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: _ActionBtn(
                          icon: Icons.videocam_rounded,
                          label: 'Create Reel',
                          onTap: onCreateReel!,
                          highlighted: true,
                        ),
                      ),
                    ],

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Color _gradeColor(String grade) {
    final g = grade.toLowerCase();
    if (g.contains('sahih')) return const Color(0xFF4CAF50);
    if (g.contains('hasan')) return const Color(0xFF64B5F6);
    if (g.contains('daif') || g.contains("da'if")) {
      return const Color(0xFFFFB74D);
    }
    return AppColors.textSecondary;
  }

  String get _fullText =>
      '${hadith.arabicText}\n\n${hadith.translationText}\n\n— ${hadith.reference}';

  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _fullText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hadith copied!', style: GoogleFonts.outfit()),
        backgroundColor: AppColors.bgCardLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _share() {
    SharePlus.instance.share(ShareParams(text: _fullText));
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _GradeBadge extends StatelessWidget {
  final String grade;
  const _GradeBadge({required this.grade});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bg;
    final g = grade.toLowerCase();
    if (g.contains('sahih')) {
      color = const Color(0xFF4CAF50);
      bg = const Color(0xFF1B3A1B);
    } else if (g.contains('hasan')) {
      color = const Color(0xFF64B5F6);
      bg = const Color(0xFF0D1F3C);
    } else if (g.contains('daif') || g.contains("da'if")) {
      color = const Color(0xFFFFB74D);
      bg = const Color(0xFF3A2000);
    } else {
      color = AppColors.textSecondary;
      bg = AppColors.bgCard;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        '✦ $grade',
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlighted;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlighted ? AppColors.primary : AppColors.bgCard,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: highlighted ? AppColors.bg : AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: highlighted ? AppColors.bg : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
