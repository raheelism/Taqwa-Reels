import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/hadith.dart';
import '../../data/models/reel_slide.dart';
import '../../data/models/background_item.dart';
import '../../data/services/hadith_api_service.dart';
import '../../state/reel_provider.dart';
import 'widgets/hadith_detail_sheet.dart';
import 'widgets/download_dialog.dart';

// ── Helper: Convert a Hadith into ReelSlide(s) ──

const _kMaxWords = 12;

List<ReelSlide> hadithToSlides(Hadith hadith) {
  final arWords = hadith.arabicText.trim().split(RegExp(r'\s+'));
  final trWords = hadith.translationText.trim().split(RegExp(r'\s+'));
  final label = hadith.reference;

  if (arWords.length <= _kMaxWords) {
    return [
      ReelSlide(
        arabicText: hadith.arabicText,
        translationText: hadith.translationText,
        ayahNumber: hadith.hadithNumber,
        slideLabel: label,
        isPartial: false,
      ),
    ];
  }

  int parts = (arWords.length / _kMaxWords).ceil();
  final lastPartWords = arWords.length % _kMaxWords;
  final halfLimit = _kMaxWords / 2;

  bool mergeLast = false;
  if (parts > 1 && lastPartWords > 0 && lastPartWords <= halfLimit) {
    parts -= 1;
    mergeLast = true;
  }

  return List.generate(parts, (p) {
    final s = p * _kMaxWords;
    final e = (p == parts - 1 && mergeLast)
        ? arWords.length
        : (s + _kMaxWords).clamp(0, arWords.length);

    final ts = ((s / arWords.length) * trWords.length).round().clamp(
      0,
      trWords.length,
    );
    final te = ((e / arWords.length) * trWords.length).round().clamp(
      0,
      trWords.length,
    );

    return ReelSlide(
      arabicText: arWords.sublist(s, e).join(' '),
      translationText: trWords.sublist(ts, te).join(' '),
      ayahNumber: hadith.hadithNumber,
      slideLabel: parts > 1 ? '$label (${p + 1}/$parts)' : label,
      isPartial: parts > 1,
    );
  });
}

// ═══════════════════════════════════════════════════════════════════════════
//  SCREEN — 3 levels: Library → Chapters → Hadiths
// ═══════════════════════════════════════════════════════════════════════════

enum _ScreenLevel { library, chapters, hadiths }

class HadithScreen extends ConsumerStatefulWidget {
  const HadithScreen({super.key});

  @override
  ConsumerState<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends ConsumerState<HadithScreen> {
  _ScreenLevel _level = _ScreenLevel.library;
  String _activeLanguage = 'English';

  // Download state
  Map<String, DownloadedBookInfo> _downloaded = {};

  // Chapter/hadith browsing
  HadithBook? _currentBook;
  List<HadithSection>? _sections;
  HadithSection? _currentSection;
  List<Hadith>? _hadiths;
  bool _loading = false;

  // Search
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  List<Hadith>? _searchResults;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _loadDownloadState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  HadithApiService get _api => ref.read(hadithApiProvider);

  Future<void> _loadDownloadState() async {
    final d = await _api.getDownloadedBooks();
    if (mounted) setState(() => _downloaded = d);
  }

  // ── NAVIGATION ──

  void _goToChapters(HadithBook book, {String? preselectedLang}) async {
    final info = _downloaded[book.id];
    final initialLang =
        preselectedLang ??
        (info != null && info.languages.isNotEmpty
            ? info.languages.first
            : 'English');

    setState(() {
      _currentBook = book;
      _activeLanguage = initialLang;
      _level = _ScreenLevel.chapters;
      _loading = true;
      _searchQuery = '';
      _searchCtrl.clear();
      _searchResults = null;
    });
    final sections = await _api.getSections(book.id, _activeLanguage);
    if (mounted) {
      setState(() {
        _sections = sections;
        _loading = false;
      });
    }
  }

  void _goToHadiths(HadithSection section, {String? preselectedLang}) async {
    if (preselectedLang != null) {
      _activeLanguage = preselectedLang;
    }
    setState(() {
      _currentSection = section;
      _level = _ScreenLevel.hadiths;
      _loading = true;
      _searchQuery = '';
      _searchCtrl.clear();
    });
    final hadiths = await _api.getSectionHadiths(
      _currentBook!.id,
      section.sectionNumber,
      _activeLanguage,
    );
    if (mounted) {
      setState(() {
        _hadiths = hadiths;
        _loading = false;
      });
    }
  }

  void _goBack() {
    setState(() {
      _searchQuery = '';
      _searchCtrl.clear();
      _searchResults = null;
      if (_level == _ScreenLevel.hadiths) {
        _level = _ScreenLevel.chapters;
        _currentSection = null;
        _hadiths = null;
      } else if (_level == _ScreenLevel.chapters) {
        _level = _ScreenLevel.library;
        _currentBook = null;
        _sections = null;
      }
    });
  }

  // ── DOWNLOAD ──

  void _showDownloadDialog(HadithBook book, {String? preselectedLang}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DownloadDialog(
        book: book,
        initialLanguage: preselectedLang,
        onDownload: (b, lang, onProgress) =>
            _api.downloadBook(b, lang, onProgress: onProgress),
        onComplete: () {
          _loadDownloadState();
          if (_currentBook?.id == book.id) {
            // refresh active view if viewing this book
            if (_level == _ScreenLevel.chapters) {
              _goToChapters(book, preselectedLang: _activeLanguage);
            } else if (_level == _ScreenLevel.hadiths &&
                _currentSection != null) {
              _goToHadiths(_currentSection!, preselectedLang: _activeLanguage);
            }
          }
        },
      ),
    );
  }

  void _confirmDelete(HadithBook book) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete ${book.name}?',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'This will remove the downloaded hadiths from your device. You can re-download anytime.',
          style: GoogleFonts.outfit(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _api.deleteBook(book.id);
              _loadDownloadState();
            },
            child: Text(
              'Delete',
              style: GoogleFonts.outfit(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  // ── SEARCH ──

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = null;
        _searching = false;
      });
      return;
    }

    setState(() => _searching = true);

    final bookId = _level == _ScreenLevel.library ? null : _currentBook?.id;
    final results = await _api.search(query, bookId: bookId);

    if (mounted) {
      setState(() {
        _searchResults = results;
        _searching = false;
      });
    }
  }

  // ── REEL ──

  void _createReel(Hadith hadith) {
    Navigator.of(context).popUntil(
      (route) => route.settings.name == '/hadith-reels' || route.isFirst,
    );

    final slides = hadithToSlides(hadith);
    final notifier = ref.read(reelProvider.notifier);
    notifier.reset();
    notifier.setSurah(0, 'Hadith');
    notifier.setAyahRange(1, slides.length, slides);
    notifier.setBackground(BackgroundItem.solidColor('#0A0E1A'));

    context.push('/background');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _level == _ScreenLevel.library,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goBack();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              Expanded(
                child: _searchResults != null
                    ? _buildSearchResults()
                    : _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  HEADER
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildHeader() {
    final subtitle = switch (_level) {
      _ScreenLevel.library => '${_downloaded.length} books downloaded',
      _ScreenLevel.chapters => _currentBook?.name ?? '',
      _ScreenLevel.hadiths => _currentSection?.sectionName ?? '',
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.md,
        0,
      ),
      child: Row(
        children: [
          if (_level != _ScreenLevel.library)
            IconButton(
              onPressed: _goBack,
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textPrimary,
              ),
            )
          else
            const SizedBox(width: 8),
          const SizedBox(width: 4),
          if (_currentBook != null && _level != _ScreenLevel.library)
            Container(
              width: 36,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                  image: AssetImage(_currentBook!.coverAsset),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B2FF7), Color(0xFF4A00E0)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hadith Library',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: const Color(0xFFB388FF),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (_level != _ScreenLevel.library && _currentBook != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: PopupMenuButton<String>(
                initialValue: _activeLanguage,
                color: AppColors.bgCardLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                icon: const Icon(
                  Icons.language_rounded,
                  color: AppColors.textPrimary,
                ),
                onSelected: (lang) {
                  if (_activeLanguage == lang) return;
                  final info = _downloaded[_currentBook!.id];
                  if (info != null && info.languages.contains(lang)) {
                    // Already downloaded, switch view
                    if (_level == _ScreenLevel.chapters) {
                      _goToChapters(_currentBook!, preselectedLang: lang);
                    } else if (_level == _ScreenLevel.hadiths &&
                        _currentSection != null) {
                      _goToHadiths(_currentSection!, preselectedLang: lang);
                    }
                  } else {
                    // Not downloaded, prompt download
                    _showDownloadDialog(_currentBook!, preselectedLang: lang);
                  }
                },
                itemBuilder: (context) {
                  return _currentBook!.availableLanguages.map((lang) {
                    final isDownloaded =
                        _downloaded[_currentBook!.id]?.languages.contains(
                          lang,
                        ) ??
                        false;
                    return PopupMenuItem(
                      value: lang,
                      child: Row(
                        children: [
                          Text(
                            lang,
                            style: GoogleFonts.outfit(
                              color: AppColors.textPrimary,
                              fontWeight: _activeLanguage == lang
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          if (isDownloaded) ...[
                            const Spacer(),
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 16,
                              color: Color(0xFF4CAF50),
                            ),
                          ] else ...[
                            const Spacer(),
                            const Icon(
                              Icons.download_rounded,
                              size: 16,
                              color: Color(0xFFB388FF),
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList();
                },
              ),
            ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  SEARCH BAR
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildSearchBar() {
    final hint = switch (_level) {
      _ScreenLevel.library => 'Search across all downloaded hadiths...',
      _ScreenLevel.chapters => 'Search in ${_currentBook?.name ?? "book"}...',
      _ScreenLevel.hadiths => 'Search in this chapter...',
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) {
          setState(() => _searchQuery = v);
          _performSearch(v);
        },
        style: GoogleFonts.outfit(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.outfit(
            color: AppColors.textMuted,
            fontSize: 13,
          ),
          prefixIcon: _searching
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFB388FF),
                    ),
                  ),
                )
              : const Icon(
                  Icons.search_rounded,
                  color: AppColors.textMuted,
                  size: 20,
                ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() {
                      _searchQuery = '';
                      _searchResults = null;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.bgCard,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  SEARCH RESULTS
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildSearchResults() {
    if (_searchResults!.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: AppColors.textMuted.withAlpha(80),
            ),
            const SizedBox(height: 12),
            Text(
              'No matching hadiths found',
              style: GoogleFonts.outfit(
                color: AppColors.textMuted,
                fontSize: 16,
              ),
            ),
            if (_downloaded.isEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Download a book first to search',
                style: GoogleFonts.outfit(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.xxl,
      ),
      itemCount: _searchResults!.length,
      itemBuilder: (context, i) => _HadithCard(
        hadith: _searchResults![i],
        showBookBadge: _level == _ScreenLevel.library,
        onTap: () => _openDetail(_searchResults![i]),
        onCreateReel: () => _createReel(_searchResults![i]),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  CONTENT (per level)
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildContent() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFB388FF)),
      );
    }
    return switch (_level) {
      _ScreenLevel.library => _buildLibrary(),
      _ScreenLevel.chapters => _buildChapterList(),
      _ScreenLevel.hadiths => _buildHadithList(),
    };
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  LEVEL 1: LIBRARY (book cards)
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildLibrary() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.xxl,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: kHadithBooks.length,
      itemBuilder: (context, i) {
        final book = kHadithBooks[i];
        final info = _downloaded[book.id];
        final isDownloaded = info != null;

        return _BookCard(
          book: book,
          isDownloaded: isDownloaded,
          downloadInfo: info,
          onTap: () {
            if (isDownloaded) {
              _goToChapters(book);
            } else {
              _showDownloadDialog(book);
            }
          },
          onLongPress: isDownloaded ? () => _confirmDelete(book) : null,
        );
      },
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  LEVEL 2: CHAPTERS
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildChapterList() {
    if (_sections == null || _sections!.isEmpty) {
      return Center(
        child: Text(
          'No chapters found',
          style: GoogleFonts.outfit(color: AppColors.textMuted, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.xxl,
      ),
      itemCount: _sections!.length,
      itemBuilder: (context, i) {
        final section = _sections![i];
        return _SectionCard(
          section: section,
          onTap: () => _goToHadiths(section),
        );
      },
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  LEVEL 3: HADITHS
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildHadithList() {
    if (_hadiths == null || _hadiths!.isEmpty) {
      return Center(
        child: Text(
          'No hadiths in this chapter',
          style: GoogleFonts.outfit(color: AppColors.textMuted, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.xxl,
      ),
      itemCount: _hadiths!.length,
      itemBuilder: (context, i) => _HadithCard(
        hadith: _hadiths![i],
        onTap: () => _openDetail(_hadiths![i]),
        onCreateReel: () => _createReel(_hadiths![i]),
      ),
    );
  }

  void _openDetail(Hadith hadith) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HadithDetailSheet(
        hadith: hadith,
        onCreateReel: () => _createReel(hadith),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  BOOK CARD (image-based grid card)
// ═══════════════════════════════════════════════════════════════════════════

class _BookCard extends StatelessWidget {
  final HadithBook book;
  final bool isDownloaded;
  final DownloadedBookInfo? downloadInfo;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _BookCard({
    required this.book,
    required this.isDownloaded,
    this.downloadInfo,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgCard,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Cover image ──
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    book.coverAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF2D1B4E), Color(0xFF0A0E1A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        size: 48,
                        color: Color(0xFF7B2FF7),
                      ),
                    ),
                  ),
                  // Status overlay badge
                  Positioned(
                    top: 6,
                    right: 6,
                    child: isDownloaded
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B3A1B).withAlpha(230),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.check_circle_rounded,
                              size: 14,
                              color: Color(0xFF4CAF50),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A0E1A).withAlpha(200),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.download_rounded,
                              size: 14,
                              color: Color(0xFFB388FF),
                            ),
                          ),
                  ),
                ],
              ),
            ),

            // ── Info section ──
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book name
                    Text(
                      book.name,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Hadith count
                    Text(
                      isDownloaded
                          ? '${downloadInfo!.hadithCount} hadiths'
                          : '~${book.estimatedHadithCount} hadiths',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    // Language badge
                    if (isDownloaded) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7B2FF7).withAlpha(20),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          downloadInfo!.languages
                              .map(
                                (l) =>
                                    l == 'Urdu' ? '🇵🇰 Urdu' : '🇬🇧 English',
                              )
                              .join(', '),
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFB388FF),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],

                    const Spacer(),

                    // Action button
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: isDownloaded
                          ? OutlinedButton(
                              onPressed: onTap,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                foregroundColor: const Color(0xFFB388FF),
                                side: const BorderSide(
                                  color: Color(0xFF7B2FF7),
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Browse',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: onTap,
                              icon: const Icon(
                                Icons.download_rounded,
                                size: 14,
                              ),
                              label: Text(
                                'Download',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: const Color(0xFF7B2FF7),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
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
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  SECTION CARD
// ═══════════════════════════════════════════════════════════════════════════

class _SectionCard extends StatelessWidget {
  final HadithSection section;
  final VoidCallback onTap;

  const _SectionCard({required this.section, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF7B2FF7).withAlpha(25),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${section.sectionNumber}',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFB388FF),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.sectionName.isNotEmpty
                            ? section.sectionName
                            : 'Section ${section.sectionNumber}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${section.hadithCount} hadiths',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  HADITH CARD
// ═══════════════════════════════════════════════════════════════════════════

class _HadithCard extends StatelessWidget {
  final Hadith hadith;
  final bool showBookBadge;
  final VoidCallback onTap;
  final VoidCallback onCreateReel;

  const _HadithCard({
    required this.hadith,
    this.showBookBadge = false,
    required this.onTap,
    required this.onCreateReel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF7B2FF7).withAlpha(25),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${hadith.hadithNumber}',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFB388FF),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (showBookBadge)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D1B4E),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          hadith.bookName,
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFB388FF),
                          ),
                        ),
                      ),
                    if (hadith.grades.isNotEmpty) ...[
                      if (showBookBadge) const SizedBox(width: 6),
                      _GradeChip(grade: hadith.grades.first.grade),
                    ],
                    const Spacer(),
                    GestureDetector(
                      onTap: onCreateReel,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.videocam_rounded,
                              size: 13,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Reel',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text:
                                '${hadith.arabicText}\n\n${hadith.translationText}\n\n— ${hadith.reference}',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Hadith copied!',
                              style: GoogleFonts.outfit(),
                            ),
                            backgroundColor: AppColors.bgCardLight,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.copy_rounded,
                        size: 16,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Arabic
                Text(
                  hadith.arabicText,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.amiri(
                    fontSize: 17,
                    height: 2.0,
                    color: const Color(0xFFD4AAFF),
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),

                const SizedBox(height: 8),

                // Translation
                Text(
                  hadith.translationText,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: hadith.translationLang == 'Urdu'
                      ? GoogleFonts.notoNastaliqUrdu(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 2.2,
                        )
                      : GoogleFonts.outfit(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                  textDirection: hadith.translationLang == 'Urdu'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                ),

                const SizedBox(height: 8),

                // Reference
                Row(
                  children: [
                    const Icon(
                      Icons.auto_stories_rounded,
                      size: 12,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      hadith.reference,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _GradeChip extends StatelessWidget {
  final String grade;
  const _GradeChip({required this.grade});

  @override
  Widget build(BuildContext context) {
    final g = grade.toLowerCase();
    Color color;
    Color bg;
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
      bg = AppColors.bgCardLight;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        grade,
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
