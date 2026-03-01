import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/dua.dart';

/// Full-screen bottom sheet showing a single dua with all translations,
/// transliteration, source, and actions.
class DuaDetailSheet extends StatelessWidget {
  final Dua dua;
  final VoidCallback? onCreateReel;

  const DuaDetailSheet({super.key, required this.dua, this.onCreateReel});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
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
                    AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.sm),
                child: Row(
                  children: [
                    // Source badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: dua.source == DuaSource.quran
                            ? const Color(0xFF1A3A5C)
                            : const Color(0xFF2D1B4E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        dua.source == DuaSource.quran
                            ? '📖 Quran'
                            : '📜 Hadith',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: dua.source == DuaSource.quran
                              ? const Color(0xFF4A9EE0)
                              : const Color(0xFFB388FF),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        dua.reference,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded,
                          color: AppColors.textMuted, size: 22),
                    ),
                  ],
                ),
              ),

              const Divider(color: AppColors.bgCard, height: 1),

              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    // Arabic text
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1A2040), Color(0xFF131832)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.primary.withAlpha(30)),
                      ),
                      child: Text(
                        dua.arabic,
                        style: GoogleFonts.amiri(
                          fontSize: 24,
                          height: 2.2,
                          color: AppColors.primary,
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Transliteration
                    _buildSection(
                      icon: Icons.record_voice_over_rounded,
                      label: 'Transliteration',
                      child: Text(
                        dua.transliteration,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // English
                    _buildSection(
                      icon: Icons.translate_rounded,
                      label: 'English',
                      child: Text(
                        dua.english,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                          height: 1.6,
                        ),
                      ),
                    ),

                    // Urdu
                    if (dua.urdu.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSection(
                        icon: Icons.language_rounded,
                        label: 'اردو',
                        child: Text(
                          dua.urdu,
                          style: GoogleFonts.amiri(
                            fontSize: 17,
                            color: AppColors.textPrimary,
                            height: 1.8,
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],

                    // French
                    if (dua.french.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSection(
                        icon: Icons.language_rounded,
                        label: 'Français',
                        child: Text(
                          dua.french,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            color: AppColors.textPrimary,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],

                    // Occasion
                    if (dua.occasion != null) ...[
                      const SizedBox(height: 16),
                      _buildSection(
                        icon: Icons.access_time_rounded,
                        label: 'When to recite',
                        child: Text(
                          dua.occasion!,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],

                    // Tags
                    if (dua.tags.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: dua.tags
                            .map((t) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.bgCardLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '#$t',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.copy_rounded,
                            label: 'Copy',
                            onTap: () => _copy(context),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.share_rounded,
                            label: 'Share',
                            onTap: () => _share(),
                          ),
                        ),
                      ],
                    ),

                    if (onCreateReel != null) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: _ActionButton(
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

  String get _fullText =>
      '${dua.arabic}\n\n'
      '${dua.transliteration}\n\n'
      '${dua.english}\n\n'
      '— ${dua.reference}';

  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _fullText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dua copied!', style: GoogleFonts.outfit()),
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

// ═══════════════════════════════════════════════════════════════════════════════

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlighted;

  const _ActionButton({
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
              Icon(icon, size: 18, color: highlighted ? AppColors.bg : AppColors.primary),
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
