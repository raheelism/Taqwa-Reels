import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/surah.dart';
import '../../data/services/audio_service.dart';
import '../../data/services/quran_api_service.dart';
import '../../state/reel_provider.dart';
import '../shared/section_header.dart';
import '../shared/step_indicator.dart';
import 'widgets/ayah_preview_cards.dart';
import 'widgets/ayah_range_picker.dart';
import 'widgets/reciter_chips.dart';
import 'widgets/surah_list_panel.dart';
import 'widgets/translation_selector.dart';

class AyahSelectionScreen extends ConsumerStatefulWidget {
  const AyahSelectionScreen({super.key});

  @override
  ConsumerState<AyahSelectionScreen> createState() =>
      _AyahSelectionScreenState();
}

class _AyahSelectionScreenState extends ConsumerState<AyahSelectionScreen> {
  List<Surah> _allSurahs = [];
  List<Surah> _filteredSurahs = [];
  bool _loadingSurahs = true;
  String? _surahError;
  Surah? _selectedSurah;

  final _fromCtrl = TextEditingController(text: '1');
  final _toCtrl = TextEditingController(text: '3');
  final _searchCtrl = TextEditingController();
  final _audioPlayer = AudioPlayer();

  bool _loadingAyahs = false;
  String? _ayahError;
  bool _isPlaying = false;
  int? _playingAyah;

  final _scrollController = ScrollController();

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
    _scrollController.dispose();
    super.dispose();
  }

  // ── Data loading ──

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

  // ── Ayah +/- helpers ──

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

  // ── Generation ──

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
      final slides = buildSlides(
        ayahs,
        _selectedSurah!.englishName,
        includeBismillah: ref.read(reelProvider).includeBismillah,
        showAyahNumber: ref.read(reelProvider).showAyahNumber,
      );
      ref.read(reelProvider.notifier).setAyahRange(from, to, slides);
      setState(() => _loadingAyahs = false);

      // Auto-scroll to the preview section
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
          );
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _ayahError = 'Failed to load ayahs. Check connection.';
        _loadingAyahs = false;
      });
    }
  }

  // ── Audio preview ──

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

      // Update UI immediately to show the "Stop" icon while buffering/playing
      setState(() {
        _isPlaying = true;
        _playingAyah = ayahNumber;
      });

      await _audioPlayer.play();

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
        setState(() {
          _isPlaying = false;
          _playingAyah = null;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not load audio')));
      }
    }
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reelProvider);
    final screenH = MediaQuery.of(context).size.height;

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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: StepIndicator(current: 1),
            ),

            // Scrollable sections
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  // ── Surah ──
                  const SectionHeader('Select Surah'),
                  const SizedBox(height: AppSpacing.sm),
                  _buildSearchBar(),
                  const SizedBox(height: AppSpacing.sm),
                  SurahListPanel(
                    surahs: _filteredSurahs,
                    loading: _loadingSurahs,
                    error: _surahError,
                    selected: _selectedSurah,
                    height: (screenH * 0.30).clamp(180, 400),
                    onRetry: () {
                      setState(() {
                        _loadingSurahs = true;
                        _surahError = null;
                      });
                      _fetchSurahs();
                    },
                    onSelect: _selectSurah,
                  ),

                  if (_selectedSurah != null) ...[
                    const SizedBox(height: AppSpacing.lg),

                    // ── Range ──
                    SectionHeader(
                      'Ayah Range (${_selectedSurah!.englishName} · ${_selectedSurah!.numberOfAyahs} ayahs)',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AyahRangePicker(
                      fromCtrl: _fromCtrl,
                      toCtrl: _toCtrl,
                      onDecrementFrom: _decrementFrom,
                      onIncrementFrom: _incrementFrom,
                      onDecrementTo: _decrementTo,
                      onIncrementTo: _incrementTo,
                    ),
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

                    // ── Reciter ──
                    const SectionHeader('Reciter'),
                    const SizedBox(height: AppSpacing.sm),
                    ReciterChips(
                      selected: state.reciter,
                      onChanged: (r) =>
                          ref.read(reelProvider.notifier).setReciter(r),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // ── Translation ──
                    const SectionHeader('Translation'),
                    const SizedBox(height: AppSpacing.sm),
                    TranslationSelector(
                      selected: state.translation,
                      onChanged: (t) =>
                          ref.read(reelProvider.notifier).setTranslation(t),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // ── Display Options ──
                    const SectionHeader('Display Options'),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: const Text(
                              'Show Bismillah Slide',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: const Text(
                              'Add Bismillah at the start of video',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                            value: state.includeBismillah,
                            activeTrackColor: AppColors.primary,
                            onChanged: (v) => ref
                                .read(reelProvider.notifier)
                                .setIncludeBismillah(v),
                          ),
                          const Divider(
                            height: 1,
                            color: AppColors.bgCardLight,
                          ),
                          SwitchListTile(
                            title: const Text(
                              'Show Ayah Numbers',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: const Text(
                              'Display ۝ symbols with numbers',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                            value: state.showAyahNumber,
                            activeTrackColor: AppColors.primary,
                            onChanged: (v) => ref
                                .read(reelProvider.notifier)
                                .setShowAyahNumber(v),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // ── Generate ──
                    _buildGenerateButton(),

                    // ── Preview ──
                    if (state.slides.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      _buildSegmentSummary(state.slides.length),
                      const SizedBox(height: AppSpacing.sm),
                      AyahPreviewCards(
                        slides: state.slides,
                        currentIndex: state.currentSlideIndex,
                        isPlaying: _isPlaying,
                        playingAyah: _playingAyah,
                        onPageChanged: (i) =>
                            ref.read(reelProvider.notifier).setCurrentSlide(i),
                        onToggleAudio: _toggleAudioPreview,
                      ),
                    ],
                  ],
                ],
              ),
            ),

            // ── Next ──
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

  // ── Small inline helpers ──

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

  Widget _buildGenerateButton() => SizedBox(
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

  Widget _buildSegmentSummary(int count) => Container(
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
