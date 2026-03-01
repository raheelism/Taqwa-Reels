import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/hadith.dart';

/// Bottom sheet for downloading a hadith book with language selection.
class DownloadDialog extends StatefulWidget {
  final HadithBook book;
  final String? initialLanguage;
  final Future<int> Function(
    HadithBook book,
    String language,
    void Function(double progress, String status) onProgress,
  )
  onDownload;
  final VoidCallback onComplete;

  const DownloadDialog({
    super.key,
    required this.book,
    this.initialLanguage,
    required this.onDownload,
    required this.onComplete,
  });

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog>
    with SingleTickerProviderStateMixin {
  String _selectedLanguage = 'English';
  bool _downloading = false;
  double _progress = 0.0;
  String _status = '';
  String? _error;
  bool _done = false;
  int _downloadedCount = 0;

  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    // Default to initialLanguage if provided, else first available language
    _selectedLanguage =
        widget.initialLanguage ?? widget.book.availableLanguages.first;
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _startDownload() async {
    setState(() {
      _downloading = true;
      _error = null;
      _progress = 0;
      _status = 'Starting download...';
    });

    try {
      final count = await widget.onDownload(widget.book, _selectedLanguage, (
        progress,
        status,
      ) {
        if (mounted) {
          setState(() {
            _progress = progress;
            _status = status;
          });
        }
      });
      if (!mounted) return;
      setState(() {
        _done = true;
        _downloadedCount = count;
        _status = 'Download complete!';
      });
      // Auto-close after 1s
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) {
        Navigator.pop(context);
        widget.onComplete();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _downloading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textMuted.withAlpha(80),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Book cover image
          Container(
            width: 72,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(widget.book.coverAsset),
                fit: BoxFit.cover,
              ),
            ),
            child: _done
                ? Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B3A1B).withAlpha(180),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF4CAF50),
                        size: 36,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 14),
          Text(
            widget.book.name,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '~${widget.book.estimatedHadithCount} hadiths',
            style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textMuted),
          ),

          const SizedBox(height: 20),

          // ── Downloading progress ──
          if (_downloading) ...[
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _done ? 1.0 : _progress,
                minHeight: 8,
                backgroundColor: AppColors.bgCard,
                valueColor: AlwaysStoppedAnimation(
                  _done ? const Color(0xFF4CAF50) : const Color(0xFF7B2FF7),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _status,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: _done
                          ? const Color(0xFF4CAF50)
                          : AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _done
                      ? '$_downloadedCount hadiths'
                      : '${(_progress * 100).toStringAsFixed(0)}%',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            if (_done) ...[
              const SizedBox(height: 12),
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF4CAF50),
                size: 48,
              ),
            ],
          ]
          // ── Language selection + download button ──
          else ...[
            // Language chips
            Text(
              'Select Translation Language',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.book.availableLanguages.map((lang) {
                final selected = lang == _selectedLanguage;
                final emoji = lang == 'Urdu' ? '🇵🇰' : '🇬🇧';
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(
                      '$emoji $lang',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedLanguage = lang),
                    selectedColor: const Color(0xFF7B2FF7),
                    backgroundColor: AppColors.bgCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: selected
                            ? const Color(0xFF7B2FF7)
                            : Colors.transparent,
                      ),
                    ),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                );
              }).toList(),
            ),

            // Error
            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _error!,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppColors.error,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Download button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _startDownload,
                icon: const Icon(Icons.download_rounded, size: 20),
                label: Text(
                  'Download ${widget.book.availableLanguages.length > 1 ? "(Arabic + $_selectedLanguage)" : "(Arabic + English)"}',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B2FF7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
