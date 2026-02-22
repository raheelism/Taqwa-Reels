import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/constants/reciters.dart';
import '../../data/constants/translations.dart';
import '../../data/models/surah.dart';
import '../../data/services/audio_service.dart';
import '../../data/services/quran_api_service.dart';
import '../../state/reel_provider.dart';

class AyahSelectionScreen extends ConsumerStatefulWidget {
  const AyahSelectionScreen({super.key});

  @override
  ConsumerState<AyahSelectionScreen> createState() =>
      _AyahSelectionScreenState();
}

class _AyahSelectionScreenState extends ConsumerState<AyahSelectionScreen> {
  // ── State ──
  List<Surah> _allSurahs = [];
  List<Surah> _filteredSurahs = [];
  bool _loadingSurahs = true;
  String? _surahError;

  Surah? _selectedSurah;
  final _fromCtrl = TextEditingController(text: '1');
  final _toCtrl = TextEditingController(text: '3');

  bool _loadingAyahs = false;
  String? _ayahError;

  final _searchCtrl = TextEditingController();
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int? _playingAyah;

  @override
  void initState() {
    super.initState();
    _fetchSurahs();
    _searchCtrl.addListener(_filterSurahs);
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _searchCtrl.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _fetchSurahs() async {
    try {
      final surahs = await ref.read(quranApiProvider).fetchSurahs();
      if (!mounted) return;
      setState(() {
        _allSurahs = surahs;
        _filteredSurahs = surahs;
        _loadingSurahs = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _surahError = e.toString();
        _loadingSurahs = false;
      });
    }
  }

  void _filterSurahs() {
    final q = _searchCtrl.text.toLowerCase().trim();
    setState(() {
      _filteredSurahs = q.isEmpty
          ? _allSurahs
          : _allSurahs
                .where(
                  (s) =>
                      s.englishName.toLowerCase().contains(q) ||
                      s.name.contains(q) ||
                      s.number.toString() == q,
                )
                .toList();
    });
  }

  void _selectSurah(Surah surah) {
    setState(() {
      _selectedSurah = surah;
      _fromCtrl.text = '1';
      _toCtrl.text = surah.numberOfAyahs > 5
          ? '5'
          : surah.numberOfAyahs.toString();
    });
    ref.read(reelProvider.notifier).setSurah(surah.number, surah.englishName);
  }

  void _incrementFrom() {
    final v = (int.tryParse(_fromCtrl.text) ?? 0) + 1;
    if (_selectedSurah != null && v <= _selectedSurah!.numberOfAyahs) {
      _fromCtrl.text = v.toString();
    }
  }

  void _decrementFrom() {
    final v = (int.tryParse(_fromCtrl.text) ?? 2) - 1;
    if (v >= 1) _fromCtrl.text = v.toString();
  }

  void _incrementTo() {
    final v = (int.tryParse(_toCtrl.text) ?? 0) + 1;
    if (_selectedSurah != null && v <= _selectedSurah!.numberOfAyahs) {
      _toCtrl.text = v.toString();
    }
  }

  void _decrementTo() {
    final v = (int.tryParse(_toCtrl.text) ?? 2) - 1;
    if (v >= 1) _toCtrl.text = v.toString();
  }

  Future<void> _generateSegments() async {
    if (_selectedSurah == null) return;
    final from = int.tryParse(_fromCtrl.text) ?? 1;
    final to = int.tryParse(_toCtrl.text) ?? from;

    if (from < 1 || to > _selectedSurah!.numberOfAyahs || from > to) {
      setState(
        () =>
            _ayahError = 'Invalid range (1 – ${_selectedSurah!.numberOfAyahs})',
      );
      return;
    }
    if (to - from + 1 > 10) {
      setState(() => _ayahError = 'Max 10 ayahs per video');
      return;
    }

    setState(() {
      _loadingAyahs = true;
      _ayahError = null;
    });

    try {
      final state = ref.read(reelProvider);
      final ayahs = await ref
          .read(quranApiProvider)
          .fetchRange(
            _selectedSurah!.number,
            from,
            to,
            state.translation.edition,
          );
      if (!mounted) return;
      final slides = buildSlides(ayahs, _selectedSurah!.englishName);
      ref.read(reelProvider.notifier).setAyahRange(from, to, slides);
      setState(() => _loadingAyahs = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _ayahError = 'Failed to load ayahs. Check connection.';
        _loadingAyahs = false;
      });
    }
  }

  Future<void> _toggleAudioPreview(int ayahNumber) async {
    if (_isPlaying && _playingAyah == ayahNumber) {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
        _playingAyah = null;
      });
      return;
    }

    final state = ref.read(reelProvider);
    final url = getAudioUrl(
      state.reciter.folder,
      state.surahNumber!,
      ayahNumber,
    );
    try {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
      setState(() {
        _isPlaying = true;
        _playingAyah = ayahNumber;
      });
      _audioPlayer.playerStateStream.listen((ps) {
        if (ps.processingState == ProcessingState.completed) {
          if (mounted) {
            setState(() {
              _isPlaying = false;
              _playingAyah = null;
            });
          }
        }
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not load audio')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reelProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Reels'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: _buildStepIndicator(1),
            ),

            // Scrollable content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  // ── Section: Surah Selection ──
                  _sectionHeader('Select Surah'),
                  const SizedBox(height: AppSpacing.sm),
                  _buildSearchBar(),
                  const SizedBox(height: AppSpacing.sm),

                  // Responsive surah list — uses ~40% of screen height
                  SizedBox(
                    height: (screenHeight * 0.35).clamp(180, 400),
                    child: _buildSurahList(),
                  ),

                  if (_selectedSurah != null) ...[
                    const SizedBox(height: AppSpacing.lg),

                    // ── Section: Ayah Range with ± buttons ──
                    _sectionHeader(
                      'Ayah Range (${_selectedSurah!.englishName} · ${_selectedSurah!.numberOfAyahs} ayahs)',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildAyahRangePicker(),
                    if (_ayahError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          _ayahError!,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 13,
                          ),
                        ),
                      ),

                    const SizedBox(height: AppSpacing.lg),

                    // ── Section: Reciter ──
                    _sectionHeader('Reciter'),
                    const SizedBox(height: AppSpacing.sm),
                    _buildReciterChips(),

                    const SizedBox(height: AppSpacing.lg),

                    // ── Section: Translation ──
                    _sectionHeader('Translation'),
                    const SizedBox(height: AppSpacing.sm),
                    _buildTranslationTiles(),

                    const SizedBox(height: AppSpacing.lg),

                    // ── Generate button (AFTER translation) ──
                    _buildGenerateButton(),

                    // ── Segment summary + preview ──
                    if (state.slides.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      _buildSegmentSummary(state.slides.length),
                      const SizedBox(height: AppSpacing.sm),
                      _buildAyahPreview(),
                    ],
                  ],
                ],
              ),
            ),

            // ── Next button ──
            if (state.slides.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/background'),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Next: Choose Background'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Widgets ──

  Widget _sectionHeader(String text) => Text(
    text,
    style: GoogleFonts.outfit(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
  );

  Widget _buildSearchBar() => TextField(
    controller: _searchCtrl,
    style: const TextStyle(color: AppColors.textPrimary),
    decoration: InputDecoration(
      hintText: 'Search surah by name or number...',
      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
      prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
      filled: true,
      fillColor: AppColors.bgCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );

  Widget _buildSurahList() {
    if (_loadingSurahs) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (_surahError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, color: AppColors.textMuted, size: 40),
            const SizedBox(height: 8),
            Text(
              _surahError!,
              style: const TextStyle(color: AppColors.error),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _loadingSurahs = true;
                  _surahError = null;
                });
                _fetchSurahs();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: _filteredSurahs.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: AppColors.bgCardLight),
        itemBuilder: (context, i) {
          final surah = _filteredSurahs[i];
          final isSelected = _selectedSurah?.number == surah.number;
          return ListTile(
            dense: true,
            selected: isSelected,
            selectedTileColor: AppColors.primaryDim,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            leading: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.bgCardLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${surah.number}',
                  style: TextStyle(
                    color: isSelected ? AppColors.bg : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            title: Text(
              surah.englishName,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${surah.numberOfAyahs} ayahs',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
            trailing: Text(
              surah.name,
              style: GoogleFonts.amiri(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontSize: 15,
              ),
              textDirection: TextDirection.rtl,
            ),
            onTap: () => _selectSurah(surah),
          );
        },
      ),
    );
  }

  Widget _buildAyahRangePicker() {
    return Row(
      children: [
        // From field with ± buttons
        Expanded(
          child: _buildNumberField(
            'From',
            _fromCtrl,
            _decrementFrom,
            _incrementFrom,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '—',
            style: TextStyle(color: AppColors.textMuted, fontSize: 20),
          ),
        ),
        // To field with ± buttons
        Expanded(
          child: _buildNumberField('To', _toCtrl, _decrementTo, _incrementTo),
        ),
      ],
    );
  }

  Widget _buildNumberField(
    String label,
    TextEditingController ctrl,
    VoidCallback onMinus,
    VoidCallback onPlus,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        children: [
          // Minus button
          GestureDetector(
            onTap: onMinus,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.bgCardLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.remove,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ),
          ),
          // Text field
          Expanded(
            child: TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          // Plus button
          GestureDetector(
            onTap: onPlus,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.bgCardLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.add,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _loadingAyahs ? null : _generateSegments,
        icon: _loadingAyahs
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.bg,
                ),
              )
            : const Icon(Icons.auto_awesome_rounded),
        label: Text(_loadingAyahs ? 'Loading...' : 'Generate Video Segments'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSegmentSummary(int count) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withAlpha(25),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.success.withAlpha(80)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.success,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$count segment${count > 1 ? 's' : ''} ready for video',
              style: GoogleFonts.outfit(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyahPreview() {
    final state = ref.watch(reelProvider);
    final slides = state.slides;
    if (slides.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 180,
      child: PageView.builder(
        itemCount: slides.length,
        controller: PageController(viewportFraction: 0.92),
        onPageChanged: (i) =>
            ref.read(reelProvider.notifier).setCurrentSlide(i),
        itemBuilder: (context, i) {
          final slide = slides[i];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: i == state.currentSlideIndex
                    ? AppColors.primary.withAlpha(120)
                    : AppColors.bgCardLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Slide label + audio preview
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        slide.slideLabel,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _toggleAudioPreview(slide.ayahNumber),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color:
                              (_isPlaying && _playingAyah == slide.ayahNumber)
                              ? AppColors.primary
                              : AppColors.bgCardLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          (_isPlaying && _playingAyah == slide.ayahNumber)
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 16,
                          color:
                              (_isPlaying && _playingAyah == slide.ayahNumber)
                              ? AppColors.bg
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Arabic text
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      slide.arabicText,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amiri(
                        fontSize: 17,
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                // Translation
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      slide.translationText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReciterChips() {
    final state = ref.watch(reelProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: kReciters.map((r) {
          final isSelected = state.reciter.id == r.id;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(r.name),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.bgCard,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.bg : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.bgCardLight,
              ),
              onSelected: (_) {
                ref.read(reelProvider.notifier).setReciter(r);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTranslationTiles() {
    final state = ref.watch(reelProvider);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: kTranslations.map((t) {
          final isSelected = state.translation.id == t.id;
          return ListTile(
            dense: true,
            selected: isSelected,
            selectedTileColor: AppColors.primaryDim,
            leading: Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 20,
            ),
            title: Text(
              t.displayName,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              t.language,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            onTap: () {
              ref.read(reelProvider.notifier).setTranslation(t);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStepIndicator(int current) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final isActive = i < current;
        final isCurrent = i == current - 1;
        return Row(
          children: [
            Container(
              width: isCurrent ? 28 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.bgCardLight,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            if (i < 3) const SizedBox(width: 6),
          ],
        );
      }),
    );
  }
}
