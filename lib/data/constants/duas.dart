import '../models/dua.dart';

/// ──────────────────────────────────────────────────────────────────────────────
/// Comprehensive Dua Collection
/// Contains authentic duas from the Holy Quran and Sahih Hadith collections
/// with Arabic text, transliteration, and translations in English, Urdu & French.
/// ──────────────────────────────────────────────────────────────────────────────

const kDuas = <Dua>[
  // ═══════════════════════════════════════════════════════════════════════════
  //  QURANIC DUAS (1–30)
  // ═══════════════════════════════════════════════════════════════════════════

  // ── 1. Surah Al-Fatiha 1:5-6 ──────────────────────────────────────────────
  Dua(
    id: 1,
    arabic:
        'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ ﴿٥﴾ اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ ﴿٦﴾',
    transliteration:
        'Iyyaaka na\'budu wa iyyaaka nasta\'een. Ihdinas-siraatal-mustaqeem.',
    translations: {
      'en':
          'You alone we worship, and You alone we ask for help. Guide us along the Straight Path.',
      'ur':
          'ہم صرف تیری ہی عبادت کرتے ہیں اور تجھ ہی سے مدد مانگتے ہیں۔ ہمیں سیدھا راستہ دکھا۔',
      'fr':
          'C\'est Toi seul que nous adorons, et c\'est Toi seul dont nous implorons secours. Guide-nous dans le droit chemin.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Fatiha 1:5-6',
    category: 'Guidance',
    occasion: 'Every prayer (Salah)',
    tags: ['guidance', 'worship', 'daily', 'salah'],
  ),

  // ── 2. Surah Al-Baqarah 2:127 ─────────────────────────────────────────────
  Dua(
    id: 2,
    arabic:
        'رَبَّنَا تَقَبَّلْ مِنَّا ۖ إِنَّكَ أَنتَ السَّمِيعُ الْعَلِيمُ',
    transliteration:
        'Rabbanaa taqabbal minnaa innaka antas-samee\'ul-\'aleem.',
    translations: {
      'en':
          'Our Lord, accept [this] from us. Indeed, You are the All-Hearing, the All-Knowing.',
      'ur':
          'اے ہمارے رب! ہم سے قبول فرما۔ بے شک تو ہی سننے والا، جاننے والا ہے۔',
      'fr':
          'Ô notre Seigneur, accepte ceci de notre part. Tu es, en vérité, Celui qui entend tout, l\'Omniscient.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Baqarah 2:127',
    category: 'Acceptance',
    occasion: 'After good deeds & acts of worship',
    tags: ['acceptance', 'worship', 'ibraheem'],
  ),

  // ── 3. Surah Al-Baqarah 2:128 ─────────────────────────────────────────────
  Dua(
    id: 3,
    arabic:
        'رَبَّنَا وَاجْعَلْنَا مُسْلِمَيْنِ لَكَ وَمِن ذُرِّيَّتِنَا أُمَّةً مُّسْلِمَةً لَّكَ وَأَرِنَا مَنَاسِكَنَا وَتُبْ عَلَيْنَا ۖ إِنَّكَ أَنتَ التَّوَّابُ الرَّحِيمُ',
    transliteration:
        'Rabbanaa waj\'alnaa muslimaini laka wa min dhurriyyatinaa ummatan muslimatan laka wa arinaa manaasikanaa wa tub \'alainaa innaka antat-tawwaabur-raheem.',
    translations: {
      'en':
          'Our Lord, make us both submissive to You, and from our offspring a nation submissive to You. Show us our rites of worship and turn to us in mercy. You are the Accepter of Repentance, the Most Merciful.',
      'ur':
          'اے ہمارے رب! ہم دونوں کو اپنا فرمانبردار بنا اور ہماری نسل سے ایک فرمانبردار امّت پیدا کر اور ہمیں ہماری عبادت کے طریقے سکھا اور ہماری توبہ قبول کر۔ بے شک تو ہی توبہ قبول کرنے والا مہربان ہے۔',
      'fr':
          'Ô notre Seigneur, fais de nous Tes soumis, et de notre descendance une communauté soumise à Toi. Montre-nous nos rites et accepte notre repentir. Tu es le Très Accueillant au repentir, le Miséricordieux.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Baqarah 2:128',
    category: 'Submission & Repentance',
    occasion: 'Seeking guidance for family and offspring',
    tags: ['repentance', 'family', 'offspring', 'submission'],
  ),

  // ── 4. Surah Al-Baqarah 2:201 ─────────────────────────────────────────────
  Dua(
    id: 4,
    arabic:
        'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
    transliteration:
        'Rabbanaa aatinaa fid-dunyaa hasanatan wa fil-aakhirati hasanatan wa qinaa \'adhaaban-naar.',
    translations: {
      'en':
          'Our Lord, give us good in this world and good in the Hereafter, and protect us from the torment of the Fire.',
      'ur':
          'اے ہمارے رب! ہمیں دنیا میں بھی بھلائی دے اور آخرت میں بھی بھلائی دے اور ہمیں آگ کے عذاب سے بچا۔',
      'fr':
          'Ô notre Seigneur, donne-nous du bien dans ce monde et du bien dans l\'au-delà, et protège-nous du châtiment du Feu.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Baqarah 2:201',
    category: 'Comprehensive',
    occasion: 'Anytime — one of the most beloved duas',
    tags: ['comprehensive', 'daily', 'protection', 'dunya', 'akhirah'],
  ),

  // ── 5. Surah Al-Baqarah 2:250 ─────────────────────────────────────────────
  Dua(
    id: 5,
    arabic:
        'رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَثَبِّتْ أَقْدَامَنَا وَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ',
    transliteration:
        'Rabbanaa afrigh \'alainaa sabran wa thabbit aqdaamanaa wansurnaa \'alal-qawmil-kaafireen.',
    translations: {
      'en':
          'Our Lord, pour upon us patience and plant firmly our feet and give us victory over the disbelieving people.',
      'ur':
          'اے ہمارے رب! ہم پر صبر انڈیل دے اور ہمارے قدم جما دے اور ہمیں کافروں پر غلبہ عطا فرما۔',
      'fr':
          'Ô notre Seigneur, déverse sur nous la patience, affermis nos pas et donne-nous la victoire sur les mécréants.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Baqarah 2:250',
    category: 'Patience & Victory',
    occasion: 'During hardship and trials',
    tags: ['patience', 'steadfastness', 'victory', 'hardship'],
  ),

  // ── 6. Surah Al-Baqarah 2:286 ─────────────────────────────────────────────
  Dua(
    id: 6,
    arabic:
        'رَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا ۚ رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا ۚ رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ ۖ وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا ۚ أَنتَ مَوْلَانَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ',
    transliteration:
        'Rabbanaa laa tu\'aakhidhnaa in naseenaa aw akhtaanaa. Rabbanaa wa laa tahmil \'alainaa isran kamaa hamaltahoo \'alal-ladheena min qablinaa. Rabbanaa wa laa tuhammilnaa maa laa taaqata lanaa bih. Wa\'fu \'annaa waghfir lanaa warhamnaa. Anta mawlaanaa fansurnaa \'alal-qawmil-kaafireen.',
    translations: {
      'en':
          'Our Lord, do not impose blame upon us if we forget or make a mistake. Our Lord, do not lay upon us a burden like that which You laid upon those before us. Our Lord, do not burden us with that which we have no ability to bear. Pardon us, forgive us, and have mercy upon us. You are our Protector, so give us victory over the disbelieving people.',
      'ur':
          'اے ہمارے رب! اگر ہم بھول جائیں یا خطا کریں تو ہماری پکڑ نہ کر۔ اے ہمارے رب! ہم پر بوجھ نہ ڈال جیسا تو نے ہم سے پہلے لوگوں پر ڈالا تھا۔ اے ہمارے رب! جتنا بوجھ اٹھانے کی ہم میں طاقت نہیں اتنا ہم پر نہ ڈال۔ ہمیں معاف فرما، ہمیں بخش دے اور ہم پر رحم فرما۔ تو ہمارا مولا ہے، پس ہمیں کافروں پر غلبہ عطا فرما۔',
      'fr':
          'Seigneur, ne nous châtie pas si nous oublions ou nous trompons. Seigneur, ne nous charge pas d\'un fardeau comme celui que Tu as imposé à ceux qui nous ont précédés. Seigneur, ne nous impose pas ce que nous n\'avons pas la force de supporter. Pardonne-nous, absous-nous et fais-nous miséricorde. Tu es notre Maître, accorde-nous la victoire sur les mécréants.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Baqarah 2:286',
    category: 'Forgiveness & Mercy',
    occasion: 'Daily — after reciting Surah Al-Baqarah',
    tags: ['forgiveness', 'mercy', 'daily', 'protection', 'burden'],
  ),

  // ── 7. Surah Aal-Imran 3:8 ────────────────────────────────────────────────
  Dua(
    id: 7,
    arabic:
        'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِن لَّدُنكَ رَحْمَةً ۚ إِنَّكَ أَنتَ الْوَهَّابُ',
    transliteration:
        'Rabbanaa laa tuzigh quloobanaa ba\'da idh hadaitanaa wa hab lanaa min ladunka rahmah. Innaka antal-wahhaab.',
    translations: {
      'en':
          'Our Lord, let not our hearts deviate after You have guided us, and grant us from Yourself mercy. Indeed, You are the Bestower.',
      'ur':
          'اے ہمارے رب! ہمارے دلوں کو ٹیڑھا نہ کر جب تو نے ہمیں ہدایت دے دی ہے اور ہمیں اپنے پاس سے رحمت عطا فرما۔ بے شک تو ہی بڑا عطا کرنے والا ہے۔',
      'fr':
          'Seigneur, ne fais pas dévier nos cœurs après nous avoir guidés, et accorde-nous de Ta part une miséricorde. C\'est Toi, certes, le Grand Donateur.',
    },
    source: DuaSource.quran,
    reference: 'Surah Aal-Imran 3:8',
    category: 'Guidance & Steadfastness',
    occasion: 'To remain firm upon guidance',
    tags: ['guidance', 'steadfastness', 'heart', 'mercy'],
  ),

  // ── 8. Surah Aal-Imran 3:16 ───────────────────────────────────────────────
  Dua(
    id: 8,
    arabic:
        'رَبَّنَا إِنَّنَا آمَنَّا فَاغْفِرْ لَنَا ذُنُوبَنَا وَقِنَا عَذَابَ النَّارِ',
    transliteration:
        'Rabbanaa innanaa aamannaa faghfir lanaa dhunoobanaa wa qinaa \'adhaaban-naar.',
    translations: {
      'en':
          'Our Lord, indeed we have believed, so forgive us our sins and protect us from the punishment of the Fire.',
      'ur':
          'اے ہمارے رب! بے شک ہم ایمان لائے ہیں پس ہمارے گناہ معاف فرما اور ہمیں آگ کے عذاب سے بچا۔',
      'fr':
          'Ô notre Seigneur, nous avons cru; pardonne-nous nos péchés et préserve-nous du châtiment du Feu.',
    },
    source: DuaSource.quran,
    reference: 'Surah Aal-Imran 3:16',
    category: 'Forgiveness',
    occasion: 'Seeking forgiveness',
    tags: ['forgiveness', 'faith', 'protection', 'fire'],
  ),

  // ── 9. Surah Aal-Imran 3:53 ───────────────────────────────────────────────
  Dua(
    id: 9,
    arabic:
        'رَبَّنَا آمَنَّا بِمَا أَنزَلْتَ وَاتَّبَعْنَا الرَّسُولَ فَاكْتُبْنَا مَعَ الشَّاهِدِينَ',
    transliteration:
        'Rabbanaa aamannaa bimaa anzalta wattaba\'nar-rasoola faktubnaa ma\'ash-shaahideen.',
    translations: {
      'en':
          'Our Lord, we have believed in what You revealed and have followed the messenger, so register us among the witnesses.',
      'ur':
          'اے ہمارے رب! جو تو نے نازل کیا ہم اس پر ایمان لائے اور ہم نے رسول کی اتباع کی پس ہمیں گواہی دینے والوں میں لکھ لے۔',
      'fr':
          'Ô notre Seigneur, nous croyons en ce que Tu as révélé et nous suivons le messager. Inscris-nous parmi les témoins.',
    },
    source: DuaSource.quran,
    reference: 'Surah Aal-Imran 3:53',
    category: 'Faith',
    occasion: 'Affirming faith in revelation',
    tags: ['faith', 'belief', 'messenger', 'witness'],
  ),

  // ── 10. Surah Aal-Imran 3:147 ──────────────────────────────────────────────
  Dua(
    id: 10,
    arabic:
        'رَبَّنَا اغْفِرْ لَنَا ذُنُوبَنَا وَإِسْرَافَنَا فِي أَمْرِنَا وَثَبِّتْ أَقْدَامَنَا وَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ',
    transliteration:
        'Rabbanaghfir lanaa dhunoobanaa wa israafanaa fee amrinaa wa thabbit aqdaamanaa wansurnaa \'alal-qawmil-kaafireen.',
    translations: {
      'en':
          'Our Lord, forgive us our sins and the excess in our affairs and plant firmly our feet and give us victory over the disbelieving people.',
      'ur':
          'اے ہمارے رب! ہمارے گناہ معاف فرما اور ہمارے کاموں میں ہماری زیادتی معاف فرما اور ہمارے قدم جما دے اور ہمیں کافروں پر فتح عطا فرما۔',
      'fr':
          'Seigneur, pardonne-nous nos péchés et nos excès, affermis nos pas et accorde-nous la victoire sur les mécréants.',
    },
    source: DuaSource.quran,
    reference: 'Surah Aal-Imran 3:147',
    category: 'Forgiveness & Victory',
    occasion: 'Times of struggle and difficulty',
    tags: ['forgiveness', 'victory', 'steadfastness'],
  ),

  // ── 11. Surah Aal-Imran 3:191-194 ─────────────────────────────────────────
  Dua(
    id: 11,
    arabic:
        'رَبَّنَا مَا خَلَقْتَ هَٰذَا بَاطِلًا سُبْحَانَكَ فَقِنَا عَذَابَ النَّارِ',
    transliteration:
        'Rabbanaa maa khalaqta haadhaa baatilan subhaanaka faqinaa \'adhaaban-naar.',
    translations: {
      'en':
          'Our Lord, You did not create this aimlessly; exalted are You. Then protect us from the punishment of the Fire.',
      'ur':
          'اے ہمارے رب! تو نے یہ (سب) بے مقصد نہیں بنایا، تو پاک ہے پس ہمیں آگ کے عذاب سے بچا لے۔',
      'fr':
          'Ô notre Seigneur, Tu n\'as pas créé cela en vain. Gloire à Toi ! Préserve-nous du châtiment du Feu.',
    },
    source: DuaSource.quran,
    reference: 'Surah Aal-Imran 3:191',
    category: 'Reflection & Protection',
    occasion: 'While contemplating creation',
    tags: ['reflection', 'creation', 'protection', 'fire'],
  ),

  // ── 12. Surah Al-A'raf 7:23 ───────────────────────────────────────────────
  Dua(
    id: 12,
    arabic:
        'رَبَّنَا ظَلَمْنَا أَنفُسَنَا وَإِن لَّمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ',
    transliteration:
        'Rabbanaa dhalamnaa anfusanaa wa in lam taghfir lanaa wa tarhamnaa lanakoonanna minal-khaasireen.',
    translations: {
      'en':
          'Our Lord, we have wronged ourselves, and if You do not forgive us and have mercy upon us, we will surely be among the losers.',
      'ur':
          'اے ہمارے رب! ہم نے اپنی جانوں پر ظلم کیا اور اگر تو نے ہمیں معاف نہ کیا اور ہم پر رحم نہ کیا تو ہم ضرور نقصان اٹھانے والوں میں سے ہو جائیں گے۔',
      'fr':
          'Ô notre Seigneur, nous nous sommes fait du tort à nous-mêmes. Et si Tu ne nous pardonnes pas et ne nous fais pas miséricorde, nous serons certainement du nombre des perdants.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-A\'raf 7:23',
    category: 'Repentance',
    occasion: 'The dua of Adam (AS) — after committing a mistake',
    tags: ['repentance', 'adam', 'forgiveness', 'mercy'],
  ),

  // ── 13. Surah Al-A'raf 7:126 ──────────────────────────────────────────────
  Dua(
    id: 13,
    arabic:
        'رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَتَوَفَّنَا مُسْلِمِينَ',
    transliteration:
        'Rabbanaa afrigh \'alainaa sabran wa tawaffanaa muslimeen.',
    translations: {
      'en':
          'Our Lord, pour upon us patience and let us die as Muslims [in submission to You].',
      'ur':
          'اے ہمارے رب! ہم پر صبر انڈیل دے اور ہمیں مسلمان ہونے کی حالت میں وفات دے۔',
      'fr':
          'Ô notre Seigneur, déverse sur nous la patience et fais-nous mourir en soumis (musulmans).',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-A\'raf 7:126',
    category: 'Patience & Good End',
    occasion: 'During extreme hardship',
    tags: ['patience', 'death', 'islam', 'submission'],
  ),

  // ── 14. Surah Yunus 10:85-86 ──────────────────────────────────────────────
  Dua(
    id: 14,
    arabic:
        'رَبَّنَا لَا تَجْعَلْنَا فِتْنَةً لِّلْقَوْمِ الظَّالِمِينَ ﴿٨٥﴾ وَنَجِّنَا بِرَحْمَتِكَ مِنَ الْقَوْمِ الْكَافِرِينَ ﴿٨٦﴾',
    transliteration:
        'Rabbanaa laa taj\'alnaa fitnatan lil-qawmidh-dhaalimeen. Wa najjinaa birahmatika minal-qawmil-kaafireen.',
    translations: {
      'en':
          'Our Lord, make us not [objects of] trial for the wrongdoing people. And save us by Your mercy from the disbelieving people.',
      'ur':
          'اے ہمارے رب! ہمیں ظالم قوم کے فتنے میں نہ ڈال۔ اور ہمیں اپنی رحمت سے کافر لوگوں سے نجات دے۔',
      'fr':
          'Ô notre Seigneur, ne fais pas de nous une épreuve pour les injustes. Et sauve-nous par Ta miséricorde du peuple mécréant.',
    },
    source: DuaSource.quran,
    reference: 'Surah Yunus 10:85-86',
    category: 'Protection',
    occasion: 'Seeking protection from oppression',
    tags: ['protection', 'oppression', 'musa', 'mercy'],
  ),

  // ── 15. Surah Ibrahim 14:40 ───────────────────────────────────────────────
  Dua(
    id: 15,
    arabic:
        'رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ وَمِن ذُرِّيَّتِي ۚ رَبَّنَا وَتَقَبَّلْ دُعَاءِ',
    transliteration:
        'Rabbij\'alnee muqeemas-salaati wa min dhurriyyatee. Rabbanaa wa taqabbal du\'aa\'.',
    translations: {
      'en':
          'My Lord, make me an establisher of prayer, and [many] from my descendants. Our Lord, accept my supplication.',
      'ur':
          'اے میرے رب! مجھے نماز قائم کرنے والا بنا اور میری اولاد میں سے بھی۔ اے ہمارے رب! میری دعا قبول فرما۔',
      'fr':
          'Ô mon Seigneur, fais que j\'accomplisse assidûment la prière, ainsi qu\'une partie de ma descendance. Ô notre Seigneur, accepte mon invocation.',
    },
    source: DuaSource.quran,
    reference: 'Surah Ibrahim 14:40',
    category: 'Prayer & Family',
    occasion: 'Dua for oneself and children — Dua of Ibrahim (AS)',
    tags: ['prayer', 'salah', 'family', 'children', 'ibraheem'],
  ),

  // ── 16. Surah Ibrahim 14:41 ───────────────────────────────────────────────
  Dua(
    id: 16,
    arabic:
        'رَبَّنَا اغْفِرْ لِي وَلِوَالِدَيَّ وَلِلْمُؤْمِنِينَ يَوْمَ يَقُومُ الْحِسَابُ',
    transliteration:
        'Rabbanaghfir lee wa liwaalidayya wa lil-mu\'mineena yawma yaqoomul-hisaab.',
    translations: {
      'en':
          'Our Lord, forgive me and my parents and the believers the Day the account is established.',
      'ur':
          'اے ہمارے رب! مجھے اور میرے والدین کو اور تمام مومنوں کو اس دن بخش دے جب حساب قائم ہوگا۔',
      'fr':
          'Ô notre Seigneur, pardonne-moi, ainsi qu\'à mes parents et aux croyants, le Jour où se dressera le compte.',
    },
    source: DuaSource.quran,
    reference: 'Surah Ibrahim 14:41',
    category: 'Forgiveness',
    occasion: 'For parents and all believers',
    tags: ['forgiveness', 'parents', 'believers', 'judgment-day', 'ibraheem'],
  ),

  // ── 17. Surah Al-Isra 17:24 ───────────────────────────────────────────────
  Dua(
    id: 17,
    arabic:
        'رَّبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
    transliteration: 'Rabbir-hamhumaa kamaa rabbayaanee sagheera.',
    translations: {
      'en':
          'My Lord, have mercy upon them (my parents) as they brought me up when I was small.',
      'ur':
          'اے میرے رب! ان دونوں پر رحم فرما جیسا کہ انہوں نے مجھے بچپن میں پالا۔',
      'fr':
          'Ô mon Seigneur, fais-leur miséricorde comme ils m\'ont élevé quand j\'étais petit.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Isra 17:24',
    category: 'Parents',
    occasion: 'Daily — dua for parents',
    tags: ['parents', 'mercy', 'daily', 'family'],
  ),

  // ── 18. Surah Al-Isra 17:80 ───────────────────────────────────────────────
  Dua(
    id: 18,
    arabic:
        'رَّبِّ أَدْخِلْنِي مُدْخَلَ صِدْقٍ وَأَخْرِجْنِي مُخْرَجَ صِدْقٍ وَاجْعَل لِّي مِن لَّدُنكَ سُلْطَانًا نَّصِيرًا',
    transliteration:
        'Rabbi adkhilnee mudkhala sidqin wa akhrijnee mukhraja sidqin waj\'al lee min ladunka sultaanan naseeraa.',
    translations: {
      'en':
          'My Lord, cause me to enter a sound entrance and to exit a sound exit and grant me from Yourself a supporting authority.',
      'ur':
          'اے میرے رب! مجھے سچائی کے ساتھ داخل کر اور سچائی کے ساتھ نکال اور اپنی طرف سے میرے لیے مددگار طاقت بنا دے۔',
      'fr':
          'Ô mon Seigneur, fais-moi entrer par une entrée de vérité et sortir par une sortie de vérité, et accorde-moi de Ta part une autorité secourable.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Isra 17:80',
    category: 'Guidance & Support',
    occasion: 'Before undertaking a task or journey',
    tags: ['guidance', 'truth', 'authority', 'support'],
  ),

  // ── 19. Surah Al-Kahf 18:10 ───────────────────────────────────────────────
  Dua(
    id: 19,
    arabic:
        'رَبَّنَا آتِنَا مِن لَّدُنكَ رَحْمَةً وَهَيِّئْ لَنَا مِنْ أَمْرِنَا رَشَدًا',
    transliteration:
        'Rabbanaa aatinaa min ladunka rahmatan wa hayyi\' lanaa min amrinaa rashadaa.',
    translations: {
      'en':
          'Our Lord, grant us from Yourself mercy and prepare for us from our affair right guidance.',
      'ur':
          'اے ہمارے رب! ہمیں اپنے پاس سے رحمت عطا فرما اور ہمارے معاملے میں ہمارے لیے رشد و ہدایت مہیا کر۔',
      'fr':
          'Ô notre Seigneur, accorde-nous de Ta part une miséricorde et facilite-nous une bonne direction dans notre affaire.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Kahf 18:10',
    category: 'Mercy & Guidance',
    occasion: 'Dua of the People of the Cave — in difficult decisions',
    tags: ['mercy', 'guidance', 'cave', 'decision'],
  ),

  // ── 20. Surah Ta-Ha 20:25-28 ──────────────────────────────────────────────
  Dua(
    id: 20,
    arabic:
        'رَبِّ اشْرَحْ لِي صَدْرِي ﴿٢٥﴾ وَيَسِّرْ لِي أَمْرِي ﴿٢٦﴾ وَاحْلُلْ عُقْدَةً مِّن لِّسَانِي ﴿٢٧﴾ يَفْقَهُوا قَوْلِي ﴿٢٨﴾',
    transliteration:
        'Rabbish-rahlee sadree. Wa yassir lee amree. Wahlul \'uqdatan min lisaanee. Yafqahoo qawlee.',
    translations: {
      'en':
          'My Lord, expand for me my breast. And ease for me my task. And untie the knot from my tongue. That they may understand my speech.',
      'ur':
          'اے میرے رب! میرا سینہ کھول دے۔ اور میرا کام آسان کر دے۔ اور میری زبان کی گرہ کھول دے۔ تاکہ لوگ میری بات سمجھ سکیں۔',
      'fr':
          'Ô mon Seigneur, ouvre-moi ma poitrine. Et facilite-moi ma tâche. Et dénoue un nœud de ma langue. Afin qu\'ils comprennent mes paroles.',
    },
    source: DuaSource.quran,
    reference: 'Surah Ta-Ha 20:25-28',
    category: 'Ease & Eloquence',
    occasion: 'Before presentations, speeches, or important tasks — Dua of Musa (AS)',
    tags: ['ease', 'speech', 'confidence', 'musa', 'task'],
  ),

  // ── 21. Surah Al-Anbiya 21:87 ─────────────────────────────────────────────
  Dua(
    id: 21,
    arabic:
        'لَّا إِلَٰهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ',
    transliteration:
        'Laa ilaaha illaa anta subhaanaka innee kuntu minadh-dhaalimeen.',
    translations: {
      'en':
          'There is no deity except You; exalted are You. Indeed, I have been of the wrongdoers.',
      'ur':
          'تیرے سوا کوئی معبود نہیں، تو پاک ہے، بے شک میں ظالموں میں سے تھا۔',
      'fr':
          'Il n\'y a de divinité que Toi. Gloire à Toi ! J\'ai été du nombre des injustes.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Anbiya 21:87',
    category: 'Distress & Repentance',
    occasion: 'Dua of Yunus (AS) — in times of extreme distress',
    tags: ['distress', 'repentance', 'yunus', 'tasbih', 'powerful'],
  ),

  // ── 22. Surah Al-Mu'minun 23:97-98 ────────────────────────────────────────
  Dua(
    id: 22,
    arabic:
        'رَّبِّ أَعُوذُ بِكَ مِنْ هَمَزَاتِ الشَّيَاطِينِ ﴿٩٧﴾ وَأَعُوذُ بِكَ رَبِّ أَن يَحْضُرُونِ ﴿٩٨﴾',
    transliteration:
        'Rabbi a\'oodhu bika min hamazaatish-shayaateen. Wa a\'oodhu bika rabbi an yahdhuroon.',
    translations: {
      'en':
          'My Lord, I seek refuge in You from the incitements of the devils. And I seek refuge in You, my Lord, lest they be present with me.',
      'ur':
          'اے میرے رب! میں شیطانوں کے وسوسوں سے تیری پناہ مانگتا ہوں۔ اور اے میرے رب! میں اس بات سے بھی تیری پناہ چاہتا ہوں کہ وہ میرے پاس آئیں۔',
      'fr':
          'Ô mon Seigneur, je cherche refuge auprès de Toi contre les incitations des diables. Et je cherche refuge auprès de Toi, mon Seigneur, contre leur présence.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Mu\'minun 23:97-98',
    category: 'Protection from Evil',
    occasion: 'Protection from Shaytan',
    tags: ['protection', 'shaytan', 'evil', 'refuge'],
  ),

  // ── 23. Surah Al-Mu'minun 23:109 ──────────────────────────────────────────
  Dua(
    id: 23,
    arabic:
        'رَبَّنَا آمَنَّا فَاغْفِرْ لَنَا وَارْحَمْنَا وَأَنتَ خَيْرُ الرَّاحِمِينَ',
    transliteration:
        'Rabbanaa aamannaa faghfir lanaa warhamnaa wa anta khairur-raahimeen.',
    translations: {
      'en':
          'Our Lord, we have believed, so forgive us and have mercy upon us, and You are the best of the merciful.',
      'ur':
          'اے ہمارے رب! ہم ایمان لائے ہیں پس ہمیں بخش دے اور ہم پر رحم فرما اور تو سب سے بہتر رحم کرنے والا ہے۔',
      'fr':
          'Ô notre Seigneur, nous avons cru; pardonne-nous et fais-nous miséricorde. Tu es le Meilleur des miséricordieux.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Mu\'minun 23:109',
    category: 'Forgiveness & Mercy',
    occasion: 'Seeking forgiveness after affirming faith',
    tags: ['forgiveness', 'mercy', 'faith'],
  ),

  // ── 24. Surah Al-Furqan 25:74 ─────────────────────────────────────────────
  Dua(
    id: 24,
    arabic:
        'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
    transliteration:
        'Rabbanaa hab lanaa min azwaajinaa wa dhurriyyaatinaa qurrata a\'yunin waj\'alnaa lil-muttaqeena imaamaa.',
    translations: {
      'en':
          'Our Lord, grant us from among our wives and offspring comfort to our eyes and make us a leader [i.e., example] for the righteous.',
      'ur':
          'اے ہمارے رب! ہمیں ہماری بیویوں اور اولاد سے آنکھوں کی ٹھنڈک عطا فرما اور ہمیں متقیوں کا امام بنا دے۔',
      'fr':
          'Ô notre Seigneur, fais de nos épouses et de nos enfants la joie de nos yeux, et fais de nous un guide pour les pieux.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Furqan 25:74',
    category: 'Family',
    occasion: 'Dua for spouse and children',
    tags: ['family', 'spouse', 'children', 'piety', 'leadership'],
  ),

  // ── 25. Surah Al-Qasas 28:24 ──────────────────────────────────────────────
  Dua(
    id: 25,
    arabic: 'رَبِّ إِنِّي لِمَا أَنزَلْتَ إِلَيَّ مِنْ خَيْرٍ فَقِيرٌ',
    transliteration:
        'Rabbi innee limaa anzalta ilayya min khairin faqeer.',
    translations: {
      'en':
          'My Lord, indeed I am, for whatever good You would send down to me, in need.',
      'ur':
          'اے میرے رب! بے شک میں تیری طرف سے نازل ہونے والی ہر خیر کا محتاج ہوں۔',
      'fr':
          'Ô mon Seigneur, j\'ai grand besoin de tout bien que Tu voudras bien me faire descendre.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Qasas 28:24',
    category: 'Need & Provision',
    occasion: 'Dua of Musa (AS) — when in need of provision or help',
    tags: ['provision', 'need', 'musa', 'sustenance', 'humility'],
  ),

  // ── 26. Surah Al-Ahqaf 46:15 ──────────────────────────────────────────────
  Dua(
    id: 26,
    arabic:
        'رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ الَّتِي أَنْعَمْتَ عَلَيَّ وَعَلَىٰ وَالِدَيَّ وَأَنْ أَعْمَلَ صَالِحًا تَرْضَاهُ وَأَصْلِحْ لِي فِي ذُرِّيَّتِي ۖ إِنِّي تُبْتُ إِلَيْكَ وَإِنِّي مِنَ الْمُسْلِمِينَ',
    transliteration:
        'Rabbi awzi\'nee an ashkura ni\'matakal-latee an\'amta \'alayya wa \'alaa waalidayya wa an a\'mala saalihan tardaahu wa aslih lee fee dhurriyyatee. Innee tubtu ilaika wa innee minal-muslimeen.',
    translations: {
      'en':
          'My Lord, enable me to be grateful for Your favour which You have bestowed upon me and upon my parents and to work righteousness of which You will approve and make righteous for me my offspring. Indeed, I have repented to You, and indeed, I am of the Muslims.',
      'ur':
          'اے میرے رب! مجھے توفیق دے کہ میں تیری اس نعمت کا شکر ادا کروں جو تو نے مجھ پر اور میرے والدین پر کی ہے اور یہ کہ میں نیک عمل کروں جو تجھے پسند ہو اور میری اولاد کو میرے لیے نیک بنا دے۔ بے شک میں نے تیری طرف رجوع کیا اور میں مسلمانوں میں سے ہوں۔',
      'fr':
          'Ô mon Seigneur, inspire-moi de rendre grâce pour le bienfait dont Tu m\'as comblé, ainsi que mes parents, et de faire une bonne œuvre que Tu agrées. Rends-moi vertueux dans ma descendance. Je me repens à Toi et je suis du nombre des soumis.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Ahqaf 46:15',
    category: 'Gratitude & Family',
    occasion: 'Thanking Allah for blessings; dua for parents and children',
    tags: ['gratitude', 'parents', 'children', 'repentance', 'good-deeds'],
  ),

  // ── 27. Surah Al-Hashr 59:10 ──────────────────────────────────────────────
  Dua(
    id: 27,
    arabic:
        'رَبَّنَا اغْفِرْ لَنَا وَلِإِخْوَانِنَا الَّذِينَ سَبَقُونَا بِالْإِيمَانِ وَلَا تَجْعَلْ فِي قُلُوبِنَا غِلًّا لِّلَّذِينَ آمَنُوا رَبَّنَا إِنَّكَ رَءُوفٌ رَّحِيمٌ',
    transliteration:
        'Rabbanaghfir lanaa wa li-ikhwaaninal-ladheena sabaqoonaa bil-eemaani wa laa taj\'al fee quloobanaa ghillan lil-ladheena aamanoo. Rabbanaa innaka ra\'oofun raheem.',
    translations: {
      'en':
          'Our Lord, forgive us and our brothers who preceded us in faith and put not in our hearts any resentment toward those who have believed. Our Lord, indeed You are Kind and Merciful.',
      'ur':
          'اے ہمارے رب! ہمیں بخش دے اور ہمارے ان بھائیوں کو بھی جو ہم سے پہلے ایمان لا چکے ہیں اور ہمارے دلوں میں ایمان والوں کے لیے کوئی کینہ نہ رکھ۔ اے ہمارے رب! بے شک تو بہت مہربان اور رحم والا ہے۔',
      'fr':
          'Seigneur, pardonne-nous, ainsi qu\'à nos frères qui nous ont précédés dans la foi. Ne mets dans nos cœurs aucune rancœur envers ceux qui ont cru. Seigneur, Tu es, certes, Compatissant et Miséricordieux.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Hashr 59:10',
    category: 'Brotherhood & Forgiveness',
    occasion: 'Dua for the Muslim Ummah',
    tags: ['forgiveness', 'ummah', 'brotherhood', 'heart', 'resentment'],
  ),

  // ── 28. Surah At-Tahrim 66:8 ──────────────────────────────────────────────
  Dua(
    id: 28,
    arabic:
        'رَبَّنَا أَتْمِمْ لَنَا نُورَنَا وَاغْفِرْ لَنَا ۖ إِنَّكَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
    transliteration:
        'Rabbanaa atmim lanaa nooranaa waghfir lanaa innaka \'alaa kulli shai\'in qadeer.',
    translations: {
      'en':
          'Our Lord, perfect for us our light and forgive us. Indeed, You are over all things competent.',
      'ur':
          'اے ہمارے رب! ہم پر ہمارا نور پورا کر دے اور ہمیں بخش دے۔ بے شک تو ہر چیز پر قادر ہے۔',
      'fr':
          'Seigneur, parachève-nous notre lumière et pardonne-nous. Tu es Omnipotent.',
    },
    source: DuaSource.quran,
    reference: 'Surah At-Tahrim 66:8',
    category: 'Light & Forgiveness',
    occasion: 'Seeking spiritual light and forgiveness',
    tags: ['light', 'forgiveness', 'power', 'day-of-judgment'],
  ),

  // ── 29. Surah Nuh 71:28 ───────────────────────────────────────────────────
  Dua(
    id: 29,
    arabic:
        'رَّبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَلِمَن دَخَلَ بَيْتِيَ مُؤْمِنًا وَلِلْمُؤْمِنِينَ وَالْمُؤْمِنَاتِ',
    transliteration:
        'Rabbighfir lee wa liwaalidayya wa liman dakhala baitiya mu\'minan wa lil-mu\'mineena wal-mu\'minaat.',
    translations: {
      'en':
          'My Lord, forgive me and my parents and whoever enters my house as a believer and the believing men and believing women.',
      'ur':
          'اے میرے رب! مجھے بخش دے اور میرے والدین کو اور جو بھی میرے گھر میں مومن ہو کر داخل ہو اور تمام مومن مردوں اور مومن عورتوں کو۔',
      'fr':
          'Ô mon Seigneur, pardonne-moi, à mes parents et à quiconque entre dans ma maison en croyant, ainsi qu\'aux croyants et croyantes.',
    },
    source: DuaSource.quran,
    reference: 'Surah Nuh 71:28',
    category: 'Forgiveness',
    occasion: 'Dua of Nuh (AS) — comprehensive forgiveness',
    tags: ['forgiveness', 'parents', 'believers', 'nuh', 'home'],
  ),

  // ── 30. Surah Al-Falaq 113:1-5 ────────────────────────────────────────────
  Dua(
    id: 30,
    arabic:
        'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ﴿١﴾ مِن شَرِّ مَا خَلَقَ ﴿٢﴾ وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ ﴿٣﴾ وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ﴿٤﴾ وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ ﴿٥﴾',
    transliteration:
        'Qul a\'oodhu birabbil-falaq. Min sharri maa khalaq. Wa min sharri ghaasiqin idhaa waqab. Wa min sharrin-naffaathaati fil-\'uqad. Wa min sharri haasidin idhaa hasad.',
    translations: {
      'en':
          'Say, "I seek refuge in the Lord of daybreak. From the evil of that which He created. And from the evil of darkness when it settles. And from the evil of the blowers in knots. And from the evil of an envier when he envies."',
      'ur':
          'کہو کہ میں صبح کے رب کی پناہ مانگتا ہوں۔ ہر اس چیز کے شر سے جو اس نے بنائی۔ اور اندھیری رات کے شر سے جب وہ چھا جائے۔ اور گرہوں میں پھونکنے والیوں کے شر سے۔ اور حسد کرنے والے کے شر سے جب وہ حسد کرے۔',
      'fr':
          'Dis : "Je cherche refuge auprès du Seigneur de l\'aube naissante. Contre le mal de ce qu\'Il a créé. Contre le mal de l\'obscurité quand elle s\'approfondit. Contre le mal de celles qui soufflent sur les nœuds. Et contre le mal de l\'envieux quand il envie."',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Falaq 113:1-5',
    category: 'Protection',
    occasion: 'Morning & evening adhkar — protection from evil',
    tags: ['protection', 'evil', 'morning', 'evening', 'muawwidhaat'],
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  //  HADITH DUAS (31–60)
  // ═══════════════════════════════════════════════════════════════════════════

  // ── 31. Morning & Evening Remembrance ─────────────────────────────────────
  Dua(
    id: 31,
    arabic:
        'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
    transliteration:
        'Bismillaahil-ladhee laa yadhurru ma\'asmihi shai\'un fil-ardhi wa laa fis-samaa\'i wa huwas-samee\'ul-\'aleem.',
    translations: {
      'en':
          'In the Name of Allah, with Whose Name nothing on earth or in heaven can cause harm, and He is the All-Hearing, the All-Knowing.',
      'ur':
          'اللہ کے نام سے جس کے نام (کی برکت) سے زمین و آسمان میں کوئی چیز نقصان نہیں دے سکتی اور وہ سننے والا جاننے والا ہے۔',
      'fr':
          'Au nom d\'Allah, dont le Nom protège de tout mal sur terre et dans le ciel, et Il est l\'Audient, l\'Omniscient.',
    },
    source: DuaSource.hadith,
    reference: 'Sunan Abu Dawud 5088, Sunan At-Tirmidhi 3388',
    category: 'Morning & Evening',
    occasion: 'Recite 3 times morning and evening',
    tags: ['morning', 'evening', 'protection', 'daily', 'adhkar'],
  ),

  // ── 32. Sayyid al-Istighfar ──────────────────────────────────────────────
  Dua(
    id: 32,
    arabic:
        'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
    transliteration:
        'Allaahumma anta rabbee laa ilaaha illaa anta khalaqtanee wa anaa \'abduka wa anaa \'alaa \'ahdika wa wa\'dika mastata\'tu a\'oodhu bika min sharri maa sana\'tu aboo\'u laka bini\'matika \'alayya wa aboo\'u bidhanbee faghfir lee fa innahu laa yaghfirudh-dhunuuba illaa anta.',
    translations: {
      'en':
          'O Allah, You are my Lord, there is no god but You. You created me and I am Your servant, and I abide by Your covenant and promise as best I can. I seek refuge in You from the evil of what I have done. I acknowledge Your favours upon me and I acknowledge my sin, so forgive me, for indeed none forgives sins except You.',
      'ur':
          'اے اللہ! تو میرا رب ہے، تیرے سوا کوئی معبود نہیں۔ تو نے مجھے پیدا کیا اور میں تیرا بندہ ہوں اور میں تیرے عہد اور وعدے پر قائم ہوں جتنا میرے بس میں ہے۔ میں نے جو کچھ کیا اس کے شر سے تیری پناہ مانگتا ہوں۔ میں تیری نعمتوں کا اقرار کرتا ہوں اور اپنے گناہوں کا بھی اعتراف کرتا ہوں، پس مجھے معاف فرما کیونکہ تیرے سوا کوئی گناہ معاف نہیں کرتا۔',
      'fr':
          'Ô Allah, Tu es mon Seigneur, il n\'y a de divinité que Toi. Tu m\'as créé et je suis Ton serviteur. Je m\'en tiens à Ton pacte et à Ta promesse autant que je le peux. Je cherche refuge auprès de Toi contre le mal que j\'ai commis. Je reconnais Tes bienfaits sur moi et je reconnais mon péché. Pardonne-moi, car nul ne pardonne les péchés sauf Toi.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Al-Bukhari 6306',
    category: 'Repentance & Forgiveness',
    occasion: 'The master of seeking forgiveness — morning and evening',
    tags: ['istighfar', 'forgiveness', 'morning', 'evening', 'powerful', 'daily'],
  ),

  // ── 33. Before Sleeping ───────────────────────────────────────────────────
  Dua(
    id: 33,
    arabic:
        'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
    transliteration: 'Bismikallaahumma amootu wa ahyaa.',
    translations: {
      'en': 'In Your name, O Allah, I die and I live.',
      'ur': 'اے اللہ! تیرے نام سے مرتا اور جیتا ہوں۔',
      'fr': 'En Ton nom, ô Allah, je meurs et je vis.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Al-Bukhari 6324',
    category: 'Sleep',
    occasion: 'Before going to sleep',
    tags: ['sleep', 'night', 'daily'],
  ),

  // ── 34. Waking Up ─────────────────────────────────────────────────────────
  Dua(
    id: 34,
    arabic:
        'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
    transliteration:
        'Alhamdu lillaahil-ladhee ahyaanaa ba\'da maa amaatanaa wa ilaihin-nushoor.',
    translations: {
      'en':
          'All praise is for Allah who gave us life after having taken it from us and unto Him is the resurrection.',
      'ur':
          'تمام تعریفیں اللہ کے لیے ہیں جس نے ہمیں مارنے کے بعد زندہ کیا اور اسی کی طرف اٹھ کر جانا ہے۔',
      'fr':
          'Louange à Allah qui nous a redonné la vie après nous avoir fait mourir et c\'est vers Lui la résurrection.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Al-Bukhari 6312',
    category: 'Morning',
    occasion: 'Upon waking up from sleep',
    tags: ['morning', 'waking', 'daily', 'gratitude'],
  ),

  // ── 35. Entering the Mosque ───────────────────────────────────────────────
  Dua(
    id: 35,
    arabic:
        'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
    transliteration: 'Allaahummaf-tah lee abwaaba rahmatika.',
    translations: {
      'en': 'O Allah, open the gates of Your mercy for me.',
      'ur': 'اے اللہ! میرے لیے اپنی رحمت کے دروازے کھول دے۔',
      'fr': 'Ô Allah, ouvre-moi les portes de Ta miséricorde.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Muslim 713',
    category: 'Mosque',
    occasion: 'When entering a mosque',
    tags: ['mosque', 'mercy', 'entry'],
  ),

  // ── 36. Leaving the Mosque ────────────────────────────────────────────────
  Dua(
    id: 36,
    arabic:
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
    transliteration: 'Allaahumma innee as\'aluka min fadhlika.',
    translations: {
      'en': 'O Allah, I ask You of Your bounty.',
      'ur': 'اے اللہ! میں تجھ سے تیرے فضل کا سوال کرتا ہوں۔',
      'fr': 'Ô Allah, je Te demande de Ta grâce.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Muslim 713',
    category: 'Mosque',
    occasion: 'When leaving a mosque',
    tags: ['mosque', 'bounty', 'exit'],
  ),

  // ── 37. Before Eating ─────────────────────────────────────────────────────
  Dua(
    id: 37,
    arabic: 'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ',
    transliteration: 'Bismillaahi wa \'alaa barakatillaah.',
    translations: {
      'en': 'In the name of Allah and with the blessings of Allah.',
      'ur': 'اللہ کے نام سے اور اللہ کی برکت پر۔',
      'fr': 'Au nom d\'Allah et avec la bénédiction d\'Allah.',
    },
    source: DuaSource.hadith,
    reference: 'Sunan Abu Dawud 3767',
    category: 'Food',
    occasion: 'Before eating',
    tags: ['food', 'eating', 'bismillah', 'daily'],
  ),

  // ── 38. After Eating ──────────────────────────────────────────────────────
  Dua(
    id: 38,
    arabic:
        'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَٰذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
    transliteration:
        'Alhamdu lillaahil-ladhee at\'amanee haadhaa wa razaqaneehi min ghairi hawlin minnee wa laa quwwah.',
    translations: {
      'en':
          'All praise is for Allah who has fed me this and provided it for me without any might or power from myself.',
      'ur':
          'تمام تعریفیں اللہ کے لیے ہیں جس نے مجھے یہ کھلایا اور بغیر میری طاقت اور قوت کے مجھے یہ رزق عطا فرمایا۔',
      'fr':
          'Louange à Allah qui m\'a nourri de ceci et me l\'a accordé sans aucune force ni puissance de ma part.',
    },
    source: DuaSource.hadith,
    reference: 'Sunan At-Tirmidhi 3458, Sunan Abu Dawud 4023',
    category: 'Food',
    occasion: 'After finishing a meal',
    tags: ['food', 'eating', 'gratitude', 'daily'],
  ),

  // ── 39. Entering the Home ─────────────────────────────────────────────────
  Dua(
    id: 39,
    arabic:
        'بِسْمِ اللَّهِ وَلَجْنَا وَبِسْمِ اللَّهِ خَرَجْنَا وَعَلَى رَبِّنَا تَوَكَّلْنَا',
    transliteration:
        'Bismillaahi walajnaa wa bismillaahi kharajnaa wa \'alaa rabbinaa tawakkalnaa.',
    translations: {
      'en':
          'In the name of Allah we enter, and in the name of Allah we leave, and upon our Lord we place our trust.',
      'ur':
          'اللہ کے نام سے ہم داخل ہوئے اور اللہ کے نام سے ہم نکلے اور اپنے رب پر ہم نے بھروسہ کیا۔',
      'fr':
          'Au nom d\'Allah nous entrons, au nom d\'Allah nous sortons, et en notre Seigneur nous plaçons notre confiance.',
    },
    source: DuaSource.hadith,
    reference: 'Sunan Abu Dawud 5096',
    category: 'Home',
    occasion: 'When entering the home',
    tags: ['home', 'entry', 'trust', 'daily'],
  ),

  // ── 40. Leaving the Home ──────────────────────────────────────────────────
  Dua(
    id: 40,
    arabic:
        'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    transliteration:
        'Bismillaahi tawakkaltu \'alallaahi wa laa hawla wa laa quwwata illaa billaah.',
    translations: {
      'en':
          'In the name of Allah, I place my trust in Allah, and there is no might nor power except with Allah.',
      'ur':
          'اللہ کے نام سے، میں نے اللہ پر بھروسہ کیا، اور اللہ کے بغیر نہ کوئی طاقت ہے نہ قوت۔',
      'fr':
          'Au nom d\'Allah, je m\'en remets à Allah. Il n\'y a de force ni de puissance qu\'en Allah.',
    },
    source: DuaSource.hadith,
    reference: 'Sunan Abu Dawud 5095, Sunan At-Tirmidhi 3426',
    category: 'Home',
    occasion: 'When leaving the home',
    tags: ['home', 'exit', 'trust', 'tawakkul', 'daily'],
  ),

  // ── 41. Before Starting Any Task ──────────────────────────────────────────
  Dua(
    id: 41,
    arabic:
        'اللَّهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلًا وَأَنْتَ تَجْعَلُ الْحَزْنَ إِذَا شِئْتَ سَهْلًا',
    transliteration:
        'Allaahumma laa sahla illaa maa ja\'altahu sahlan wa anta taj\'alul-hazna idhaa shi\'ta sahlaa.',
    translations: {
      'en':
          'O Allah, there is no ease except in that which You have made easy, and You make the difficulty, if You wish, easy.',
      'ur':
          'اے اللہ! آسان صرف وہی ہے جسے تو آسان کر دے اور تو مشکل کو بھی جب چاہے آسان کر دے۔',
      'fr':
          'Ô Allah, rien n\'est facile sauf ce que Tu rends facile, et Tu rends la difficulté, si Tu le veux, facile.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Ibn Hibban 2427',
    category: 'Ease & Difficulty',
    occasion: 'Before any difficult task',
    tags: ['ease', 'difficulty', 'task', 'daily'],
  ),

  // ── 42. For Anxiety & Sorrow ──────────────────────────────────────────────
  Dua(
    id: 42,
    arabic:
        'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ وَأَعُوذُ بِكَ مِنَ الْعَجْزِ وَالْكَسَلِ وَأَعُوذُ بِكَ مِنَ الْجُبْنِ وَالْبُخْلِ وَأَعُوذُ بِكَ مِنْ غَلَبَةِ الدَّيْنِ وَقَهْرِ الرِّجَالِ',
    transliteration:
        'Allaahumma innee a\'oodhu bika minal-hammi wal-hazani wa a\'oodhu bika minal-\'ajzi wal-kasali wa a\'oodhu bika minal-jubni wal-bukhli wa a\'oodhu bika min ghalabatid-daini wa qahrir-rijaal.',
    translations: {
      'en':
          'O Allah, I seek refuge in You from anxiety and sorrow, weakness and laziness, miserliness and cowardice, the burden of debts and from being overpowered by men.',
      'ur':
          'اے اللہ! میں فکر اور غم سے تیری پناہ مانگتا ہوں، عاجزی اور سستی سے تیری پناہ مانگتا ہوں، بزدلی اور بخل سے تیری پناہ مانگتا ہوں، اور قرض کے بوجھ اور لوگوں کے غلبے سے تیری پناہ مانگتا ہوں۔',
      'fr':
          'Ô Allah, je cherche refuge auprès de Toi contre l\'inquiétude et la tristesse, contre l\'incapacité et la paresse, contre l\'avarice et la lâcheté, contre le poids des dettes et la domination des hommes.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Al-Bukhari 6369',
    category: 'Anxiety & Distress',
    occasion: 'When feeling anxious, sad, or overwhelmed',
    tags: ['anxiety', 'sorrow', 'laziness', 'debt', 'protection', 'daily'],
  ),

  // ── 43. Dua for Knowledge ─────────────────────────────────────────────────
  Dua(
    id: 43,
    arabic:
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا وَرِزْقًا طَيِّبًا وَعَمَلًا مُتَقَبَّلًا',
    transliteration:
        'Allaahumma innee as\'aluka \'ilman naafi\'an wa rizqan tayyiban wa \'amalan mutaqabbala.',
    translations: {
      'en':
          'O Allah, I ask You for beneficial knowledge, good provision, and accepted deeds.',
      'ur':
          'اے اللہ! میں تجھ سے نفع بخش علم، پاکیزہ رزق اور قبول ہونے والے عمل کا سوال کرتا ہوں۔',
      'fr':
          'Ô Allah, je Te demande une science utile, une subsistance pure et des œuvres agréées.',
    },
    source: DuaSource.hadith,
    reference: 'Sunan Ibn Majah 925',
    category: 'Knowledge',
    occasion: 'After Fajr prayer',
    tags: ['knowledge', 'provision', 'deeds', 'morning', 'fajr'],
  ),

  // ── 44. Istikhara (Seeking Guidance) ──────────────────────────────────────
  Dua(
    id: 44,
    arabic:
        'اللَّهُمَّ إِنِّي أَسْتَخِيرُكَ بِعِلْمِكَ وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ وَأَسْأَلُكَ مِنْ فَضْلِكَ الْعَظِيمِ فَإِنَّكَ تَقْدِرُ وَلَا أَقْدِرُ وَتَعْلَمُ وَلَا أَعْلَمُ وَأَنْتَ عَلَّامُ الْغُيُوبِ اللَّهُمَّ إِنْ كُنْتَ تَعْلَمُ أَنَّ هَٰذَا الْأَمْرَ خَيْرٌ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي فَاقْدُرْهُ لِي وَيَسِّرْهُ لِي ثُمَّ بَارِكْ لِي فِيهِ وَإِنْ كُنْتَ تَعْلَمُ أَنَّ هَٰذَا الْأَمْرَ شَرٌّ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي فَاصْرِفْهُ عَنِّي وَاصْرِفْنِي عَنْهُ وَاقْدُرْ لِيَ الْخَيْرَ حَيْثُ كَانَ ثُمَّ أَرْضِنِي بِهِ',
    transliteration:
        'Allaahumma innee astakheeruka bi\'ilmika wa astaqdiruka biqudratika wa as\'aluka min fadlikal-\'azeem fa innaka taqdiru wa laa aqdiru wa ta\'lamu wa laa a\'lamu wa anta \'allaamul-ghuyoob. Allaahumma in kunta ta\'lamu anna haadhal-amra khairun lee fee deenee wa ma\'aashee wa \'aaqibati amree faqdurhu lee wa yassirhu lee thumma baarik lee feehi wa in kunta ta\'lamu anna haadhal-amra sharrun lee fee deenee wa ma\'aashee wa \'aaqibati amree fasrifhu \'annee wasrifnee \'anhu waqdur liyal-khaira haithu kaana thumma ardhinee bih.',
    translations: {
      'en':
          'O Allah, I seek Your guidance by virtue of Your knowledge, and I seek ability by virtue of Your power, and I ask You of Your great bounty. You have power; I have none. And You know; I know not. You are the Knower of hidden things. O Allah, if in Your knowledge this matter is good for my religion, my livelihood and my affairs, then ordain it for me, make it easy for me, and bless it for me. And if in Your knowledge this matter is bad for my religion, my livelihood and my affairs, then turn it away from me, and turn me away from it, and ordain for me the good wherever it may be, and make me content with it.',
      'ur':
          'اے اللہ! میں تیرے علم کے واسطے سے تجھ سے خیر طلب کرتا ہوں اور تیری قدرت کے واسطے سے تجھ سے طاقت مانگتا ہوں اور تیرے عظیم فضل کا سوال کرتا ہوں۔ تو قدرت رکھتا ہے اور میں نہیں رکھتا۔ تو جانتا ہے اور میں نہیں جانتا۔ تو غیب کا جاننے والا ہے۔ اے اللہ! اگر تیرے علم میں یہ کام میرے دین، میری زندگی اور میرے انجام کے لیے بہتر ہے تو اسے میرے لیے مقدر فرما اور آسان کر دے اور اس میں برکت دے۔ اور اگر تیرے علم میں یہ کام میرے دین، میری زندگی اور میرے انجام کے لیے برا ہے تو اسے مجھ سے پھیر دے اور مجھے اس سے پھیر دے اور خیر جہاں بھی ہو میرے لیے مقدر فرما پھر مجھے اس پر راضی کر دے۔',
      'fr':
          'Ô Allah, je Te consulte par Ta science et je Te demande la capacité par Ta puissance, et je Te demande de Ton immense faveur. Car Tu es capable et je ne le suis pas, Tu sais et je ne sais pas, et Tu es le Connaisseur des choses cachées. Ô Allah, si Tu sais que cette affaire est un bien pour ma religion, ma vie et mon devenir, alors décrète-la pour moi, facilite-la moi, puis bénis-la moi. Et si Tu sais que cette affaire est un mal pour ma religion, ma vie et mon devenir, alors détourne-la de moi et détourne-moi d\'elle, et décrète pour moi le bien où qu\'il soit, puis fais-m\'en satisfait.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Al-Bukhari 1166, 6382',
    category: 'Guidance & Decision',
    occasion: 'Before making an important decision — Salat al-Istikhara',
    tags: ['istikhara', 'decision', 'guidance', 'important'],
  ),

  // ── 45. Dua When in Distress ──────────────────────────────────────────────
  Dua(
    id: 45,
    arabic:
        'لَا إِلَٰهَ إِلَّا اللَّهُ الْعَظِيمُ الْحَلِيمُ لَا إِلَٰهَ إِلَّا اللَّهُ رَبُّ الْعَرْشِ الْعَظِيمِ لَا إِلَٰهَ إِلَّا اللَّهُ رَبُّ السَّمَاوَاتِ وَرَبُّ الْأَرْضِ وَرَبُّ الْعَرْشِ الْكَرِيمِ',
    transliteration:
        'Laa ilaaha illallaahul-\'azeemul-haleem. Laa ilaaha illallaahu rabbul-\'arshil-\'azeem. Laa ilaaha illallaahu rabbus-samaawaati wa rabbul-ardhi wa rabbul-\'arshil-kareem.',
    translations: {
      'en':
          'There is no god but Allah, the Great, the Forbearing. There is no god but Allah, Lord of the Mighty Throne. There is no god but Allah, Lord of the heavens and Lord of the earth and Lord of the Noble Throne.',
      'ur':
          'اللہ کے سوا کوئی معبود نہیں، جو عظیم اور بردبار ہے۔ اللہ کے سوا کوئی معبود نہیں، عرش عظیم کا رب۔ اللہ کے سوا کوئی معبود نہیں، آسمانوں کا رب، زمین کا رب اور عرش کریم کا رب۔',
      'fr':
          'Il n\'y a de divinité qu\'Allah, le Grandiose, le Clément. Il n\'y a de divinité qu\'Allah, Seigneur du Trône immense. Il n\'y a de divinité qu\'Allah, Seigneur des cieux, Seigneur de la terre et Seigneur du Trône noble.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Al-Bukhari 6345, Sahih Muslim 2730',
    category: 'Distress',
    occasion: 'During moments of great distress',
    tags: ['distress', 'difficulty', 'powerful', 'tawheed'],
  ),

  // ── 46. After Completing Wudu ─────────────────────────────────────────────
  Dua(
    id: 46,
    arabic:
        'أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ',
    transliteration:
        'Ashhadu an laa ilaaha illallaahu wahdahu laa shareeka lahu wa ashhadu anna Muhammadan \'abduhu wa rasooluh. Allaahummaj\'alnee minat-tawwaabeena waj\'alnee minal-mutatahhireen.',
    translations: {
      'en':
          'I bear witness that there is no god but Allah alone with no partner, and I bear witness that Muhammad is His servant and Messenger. O Allah, make me of those who repent and make me of those who purify themselves.',
      'ur':
          'میں گواہی دیتا ہوں کہ اللہ کے سوا کوئی معبود نہیں وہ اکیلا ہے اس کا کوئی شریک نہیں اور میں گواہی دیتا ہوں کہ محمد ﷺ اس کے بندے اور رسول ہیں۔ اے اللہ! مجھے توبہ کرنے والوں میں سے بنا اور پاکیزگی اختیار کرنے والوں میں سے بنا۔',
      'fr':
          'J\'atteste qu\'il n\'y a de divinité qu\'Allah seul, sans associé, et j\'atteste que Muhammad est Son serviteur et Son messager. Ô Allah, fais-moi parmi ceux qui se repentent et parmi ceux qui se purifient.',
    },
    source: DuaSource.hadith,
    reference: 'Sunan At-Tirmidhi 55, Sahih Muslim 234',
    category: 'Purification',
    occasion: 'After completing ablution (wudu)',
    tags: ['wudu', 'purification', 'shahada', 'daily'],
  ),

  // ── 47. Between Adhan and Iqamah ──────────────────────────────────────────
  Dua(
    id: 47,
    arabic:
        'اللَّهُمَّ رَبَّ هَٰذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلَاةِ الْقَائِمَةِ آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ',
    transliteration:
        'Allaahumma rabba haadhihid-da\'watit-taammati was-salaatil-qaa\'imati aati Muhammadanil-waseelata wal-fadeelata wab\'athhu maqaamam mahmoodanil-ladhee wa\'adtah.',
    translations: {
      'en':
          'O Allah, Lord of this perfect call and established prayer, grant Muhammad the intercession and favour, and raise him to the honoured station You have promised him.',
      'ur':
          'اے اللہ! اس کامل پکار اور قائم ہونے والی نماز کے رب! محمد (ﷺ) کو وسیلہ اور فضیلت عطا فرما اور انہیں مقام محمود پر فائز فرما جس کا تو نے ان سے وعدہ کیا ہے۔',
      'fr':
          'Ô Allah, Seigneur de cet appel parfait et de cette prière imminente, accorde à Muhammad le moyen d\'intercession et la prééminence, et élève-le au rang louable que Tu lui as promis.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Al-Bukhari 614',
    category: 'Prayer',
    occasion: 'After hearing the Adhan',
    tags: ['adhan', 'prayer', 'prophet', 'intercession'],
  ),

  // ── 48. Dua in Sujood (Prostration) ───────────────────────────────────────
  Dua(
    id: 48,
    arabic:
        'سُبْحَانَكَ اللَّهُمَّ رَبَّنَا وَبِحَمْدِكَ اللَّهُمَّ اغْفِرْ لِي',
    transliteration:
        'Subhaanakallaahumma rabbanaa wa bihamdika allaahummagh-fir lee.',
    translations: {
      'en':
          'Glory be to You, O Allah our Lord, and praised be You. O Allah, forgive me.',
      'ur':
          'اے اللہ! ہمارے رب! تو پاک ہے اور تیری تعریف ہے۔ اے اللہ! مجھے بخش دے۔',
      'fr':
          'Gloire à Toi, ô Allah notre Seigneur, et louange à Toi. Ô Allah, pardonne-moi.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Al-Bukhari 794, Sahih Muslim 484',
    category: 'Prayer',
    occasion: 'During prostration in prayer',
    tags: ['sujood', 'prayer', 'glory', 'forgiveness'],
  ),

  // ── 49. Dua for Travelling ────────────────────────────────────────────────
  Dua(
    id: 49,
    arabic:
        'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَىٰ رَبِّنَا لَمُنقَلِبُونَ',
    transliteration:
        'Subhaanal-ladhee sakhkhara lanaa haadhaa wa maa kunnaa lahu muqrineen. Wa innaa ilaa rabbinaa lamunqaliboon.',
    translations: {
      'en':
          'Glory to Him who has subjected this to us, and we could not have [otherwise] subdued it. And indeed, to our Lord we will surely return.',
      'ur':
          'پاک ہے وہ ذات جس نے اسے ہمارے لیے مسخر کر دیا اور ہم اسے قابو میں نہیں لا سکتے تھے۔ اور بے شک ہم اپنے رب کی طرف لوٹ کر جانے والے ہیں۔',
      'fr':
          'Gloire à Celui qui a mis ceci à notre service alors que nous n\'étions pas capables de le dominer. Et c\'est vers notre Seigneur que nous retournerons.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Muslim 1342, Sunan At-Tirmidhi 3446',
    category: 'Travel',
    occasion: 'When beginning a journey / boarding transport',
    tags: ['travel', 'journey', 'vehicle', 'transport'],
  ),

  // ── 50. When it Rains ─────────────────────────────────────────────────────
  Dua(
    id: 50,
    arabic: 'اللَّهُمَّ صَيِّبًا نَافِعًا',
    transliteration: 'Allaahumma sayyiban naafi\'aa.',
    translations: {
      'en': 'O Allah, let it be a beneficial rain.',
      'ur': 'اے اللہ! اسے فائدہ مند بارش بنا دے۔',
      'fr': 'Ô Allah, fais qu\'elle soit une pluie bénéfique.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Al-Bukhari 1032',
    category: 'Weather',
    occasion: 'When it starts to rain',
    tags: ['rain', 'weather', 'blessing'],
  ),

  // ── 51. When Looking in the Mirror ────────────────────────────────────────
  Dua(
    id: 51,
    arabic:
        'اللَّهُمَّ أَنْتَ حَسَّنْتَ خَلْقِي فَحَسِّنْ خُلُقِي',
    transliteration:
        'Allaahumma anta hassanta khalqee fahassin khuluqee.',
    translations: {
      'en':
          'O Allah, just as You have made my outward appearance beautiful, make my character beautiful.',
      'ur':
          'اے اللہ! جیسے تو نے میری صورت اچھی بنائی ہے ویسے ہی میرے اخلاق بھی اچھے بنا دے۔',
      'fr':
          'Ô Allah, comme Tu as embelli mon apparence, embellis aussi mon caractère.',
    },
    source: DuaSource.hadith,
    reference: 'Musnad Ahmad 3823',
    category: 'Character',
    occasion: 'When looking in the mirror',
    tags: ['mirror', 'character', 'beauty', 'daily'],
  ),

  // ── 52. Dua for Parents (Deceased) ────────────────────────────────────────
  Dua(
    id: 52,
    arabic:
        'اللَّهُمَّ اغْفِرْ لَهُ وَارْحَمْهُ وَعَافِهِ وَاعْفُ عَنْهُ وَأَكْرِمْ نُزُلَهُ وَوَسِّعْ مُدْخَلَهُ وَاغْسِلْهُ بِالْمَاءِ وَالثَّلْجِ وَالْبَرَدِ',
    transliteration:
        'Allaahummagh-fir lahu warhamhu wa \'aafihi wa\'fu \'anhu wa akrim nuzulahu wa wassi\' mudkhalahu waghsilhu bil-maa\'i wath-thalji wal-barad.',
    translations: {
      'en':
          'O Allah, forgive him, have mercy on him, keep him safe and sound, pardon him, honour his arrival, make his entrance wide, and wash him with water, snow and hail.',
      'ur':
          'اے اللہ! اسے بخش دے، اس پر رحم فرما، اسے عافیت دے، اسے معاف فرما، اس کی ضیافت کو عزت دے، اس کے مدخل کو وسیع کر دے اور اسے پانی، برف اور اولوں سے دھو دے۔',
      'fr':
          'Ô Allah, pardonne-lui, fais-lui miséricorde, préserve-le, absous-le, honore son accueil, élargis son entrée, et lave-le avec l\'eau, la neige et la grêle.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Muslim 963',
    category: 'Deceased',
    occasion: 'Funeral prayer (Janazah) & for deceased loved ones',
    tags: ['deceased', 'parents', 'funeral', 'janazah', 'mercy'],
  ),

  // ── 53. Dua for Protection from Hellfire ──────────────────────────────────
  Dua(
    id: 53,
    arabic:
        'اللَّهُمَّ أَجِرْنِي مِنَ النَّارِ',
    transliteration: 'Allaahumma ajirnee minan-naar.',
    translations: {
      'en': 'O Allah, save me from the Fire.',
      'ur': 'اے اللہ! مجھے جہنّم کی آگ سے بچا لے۔',
      'fr': 'Ô Allah, protège-moi du Feu.',
    },
    source: DuaSource.hadith,
    reference: 'Sunan Abu Dawud 5079, Sunan An-Nasa\'i 5525',
    category: 'Protection',
    occasion: 'Recite 3 times morning and 3 times evening',
    tags: ['protection', 'hellfire', 'morning', 'evening', 'daily'],
  ),

  // ── 54. Seeking Refuge in Allah's Perfect Words ───────────────────────────
  Dua(
    id: 54,
    arabic:
        'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
    transliteration:
        'A\'oodhu bikalimaatil-laahit-taammaati min sharri maa khalaq.',
    translations: {
      'en':
          'I seek refuge in the perfect words of Allah from the evil of what He has created.',
      'ur':
          'میں اللہ کے مکمل کلمات کی پناہ مانگتا ہوں اس کی مخلوق کے شر سے۔',
      'fr':
          'Je cherche refuge dans les paroles parfaites d\'Allah contre le mal de ce qu\'Il a créé.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Muslim 2708',
    category: 'Protection',
    occasion: 'Evening adhkar — also when stopping at a place during travel',
    tags: ['protection', 'evening', 'travel', 'evil', 'daily'],
  ),

  // ── 55. Dua for Good Health ───────────────────────────────────────────────
  Dua(
    id: 55,
    arabic:
        'اللَّهُمَّ عَافِنِي فِي بَدَنِي اللَّهُمَّ عَافِنِي فِي سَمْعِي اللَّهُمَّ عَافِنِي فِي بَصَرِي لَا إِلَٰهَ إِلَّا أَنْتَ',
    transliteration:
        'Allaahumma \'aafinee fee badanee. Allaahumma \'aafinee fee sam\'ee. Allaahumma \'aafinee fee basaree. Laa ilaaha illaa anta.',
    translations: {
      'en':
          'O Allah, grant me health in my body. O Allah, grant me health in my hearing. O Allah, grant me health in my sight. There is no god but You.',
      'ur':
          'اے اللہ! میرے جسم میں عافیت دے۔ اے اللہ! میری سماعت میں عافیت دے۔ اے اللہ! میری بصارت میں عافیت دے۔ تیرے سوا کوئی معبود نہیں۔',
      'fr':
          'Ô Allah, accorde-moi la santé dans mon corps. Ô Allah, accorde-moi la santé dans mon ouïe. Ô Allah, accorde-moi la santé dans ma vue. Il n\'y a de divinité que Toi.',
    },
    source: DuaSource.hadith,
    reference: 'Sunan Abu Dawud 5090',
    category: 'Health',
    occasion: 'Morning adhkar — 3 times',
    tags: ['health', 'body', 'morning', 'daily', 'adhkar'],
  ),

  // ── 56. Dua When Wearing New Clothes ──────────────────────────────────────
  Dua(
    id: 56,
    arabic:
        'اللَّهُمَّ لَكَ الْحَمْدُ أَنْتَ كَسَوْتَنِيهِ أَسْأَلُكَ مِنْ خَيْرِهِ وَخَيْرِ مَا صُنِعَ لَهُ وَأَعُوذُ بِكَ مِنْ شَرِّهِ وَشَرِّ مَا صُنِعَ لَهُ',
    transliteration:
        'Allaahumma lakal-hamdu anta kasawtaneehi as\'aluka min khairihi wa khairi maa suni\'a lahu wa a\'oodhu bika min sharrihi wa sharri maa suni\'a lah.',
    translations: {
      'en':
          'O Allah, for You is all praise. You have clothed me with it. I ask You for the good of it and the good for which it was made, and I seek Your protection from the evil of it and the evil for which it was made.',
      'ur':
          'اے اللہ! تیرے لیے ہی تمام تعریف ہے، تو نے مجھے یہ پہنایا ہے۔ میں تجھ سے اس کی بھلائی اور اس مقصد کی بھلائی کا سوال کرتا ہوں جس کے لیے یہ بنایا گیا ہے اور اس کے شر اور اس مقصد کے شر سے تیری پناہ مانگتا ہوں جس کے لیے یہ بنایا گیا ہے۔',
      'fr':
          'Ô Allah, à Toi la louange. C\'est Toi qui m\'en as vêtu. Je Te demande son bien et le bien pour lequel il a été fait, et je cherche refuge auprès de Toi contre son mal et le mal pour lequel il a été fait.',
    },
    source: DuaSource.hadith,
    reference: 'Sunan Abu Dawud 4020, Sunan At-Tirmidhi 1767',
    category: 'Clothing',
    occasion: 'When putting on new clothes',
    tags: ['clothing', 'new', 'gratitude'],
  ),

  // ── 57. Dua for Increase in Knowledge ─────────────────────────────────────
  Dua(
    id: 57,
    arabic: 'رَبِّ زِدْنِي عِلْمًا',
    transliteration: 'Rabbi zidnee \'ilmaa.',
    translations: {
      'en': 'My Lord, increase me in knowledge.',
      'ur': 'اے میرے رب! میرے علم میں اضافہ فرما۔',
      'fr': 'Ô mon Seigneur, augmente-moi en science.',
    },
    source: DuaSource.quran,
    reference: 'Surah Ta-Ha 20:114',
    category: 'Knowledge',
    occasion: 'When studying or seeking knowledge',
    tags: ['knowledge', 'study', 'learning'],
  ),

  // ── 58. Dua After Tashahhud Before Salam ──────────────────────────────────
  Dua(
    id: 58,
    arabic:
        'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عَذَابِ جَهَنَّمَ وَمِنْ عَذَابِ الْقَبْرِ وَمِنْ فِتْنَةِ الْمَحْيَا وَالْمَمَاتِ وَمِنْ شَرِّ فِتْنَةِ الْمَسِيحِ الدَّجَّالِ',
    transliteration:
        'Allaahumma innee a\'oodhu bika min \'adhaabi jahannama wa min \'adhaabil-qabri wa min fitnatil-mahyaa wal-mamaati wa min sharri fitnatil-maseehid-dajjaal.',
    translations: {
      'en':
          'O Allah, I seek refuge in You from the punishment of Hellfire, from the punishment of the grave, from the trials of life and death, and from the evil of the trial of the False Messiah.',
      'ur':
          'اے اللہ! میں جہنم کے عذاب سے، قبر کے عذاب سے، زندگی اور موت کے فتنوں سے اور مسیح دجال کے فتنے کے شر سے تیری پناہ مانگتا ہوں۔',
      'fr':
          'Ô Allah, je cherche refuge auprès de Toi contre le châtiment de l\'Enfer, le châtiment de la tombe, les épreuves de la vie et de la mort, et le mal de l\'épreuve du Faux Messie.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Muslim 588',
    category: 'Prayer',
    occasion: 'In the final sitting of every prayer before Salam',
    tags: ['prayer', 'protection', 'hellfire', 'grave', 'dajjal', 'daily'],
  ),

  // ── 59. Dua for Entering the Restroom ─────────────────────────────────────
  Dua(
    id: 59,
    arabic:
        'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
    transliteration:
        'Allaahumma innee a\'oodhu bika minal-khubthi wal-khabaa\'ith.',
    translations: {
      'en':
          'O Allah, I seek refuge in You from the male and female evil beings (devils).',
      'ur':
          'اے اللہ! میں ناپاک جنّوں (نر اور مادہ شیاطین) سے تیری پناہ مانگتا ہوں۔',
      'fr':
          'Ô Allah, je cherche refuge auprès de Toi contre les démons mâles et femelles.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Al-Bukhari 142, Sahih Muslim 375',
    category: 'Daily Routine',
    occasion: 'Before entering the restroom/toilet',
    tags: ['restroom', 'protection', 'daily', 'shaytan'],
  ),

  // ── 60. Dua at the End of a Gathering ─────────────────────────────────────
  Dua(
    id: 60,
    arabic:
        'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا أَنْتَ أَسْتَغْفِرُكَ وَأَتُوبُ إِلَيْكَ',
    transliteration:
        'Subhaanakallaahumma wa bihamdika ashhadu an laa ilaaha illaa anta astaghfiruka wa atoobu ilaik.',
    translations: {
      'en':
          'Glory be to You, O Allah, and praised be You. I bear witness that there is no god but You. I seek Your forgiveness and I repent to You.',
      'ur':
          'اے اللہ! تو پاک ہے اور تیری حمد ہے۔ میں گواہی دیتا ہوں کہ تیرے سوا کوئی معبود نہیں۔ میں تجھ سے مغفرت مانگتا ہوں اور تیری طرف رجوع کرتا ہوں۔',
      'fr':
          'Gloire à Toi, ô Allah, et louange à Toi. J\'atteste qu\'il n\'y a de divinité que Toi. Je Te demande pardon et je me repens à Toi.',
    },
    source: DuaSource.hadith,
    reference: 'Sunan At-Tirmidhi 3433, Sunan Abu Dawud 4859',
    category: 'Gathering',
    occasion: 'Kaffaratul-Majlis — at the end of any gathering/meeting',
    tags: ['gathering', 'meeting', 'kaffarah', 'forgiveness', 'daily'],
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  //  ADDITIONAL QURANIC & HADITH DUAS (61–75)
  // ═══════════════════════════════════════════════════════════════════════════

  // ── 61. Ayatul Kursi — Surah Al-Baqarah 2:255 ────────────────────────────
  Dua(
    id: 61,
    arabic:
        'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
    transliteration:
        'Allaahu laa ilaaha illaa huwal-hayyul-qayyoom. Laa ta\'khudhuhoo sinatun wa laa nawm. Lahoo maa fis-samaawaati wa maa fil-ardh. Man dhal-ladhee yashfa\'u \'indahoo illaa bi-idhnih. Ya\'lamu maa baina aideehim wa maa khalfahum. Wa laa yuheetoona bishai\'in min \'ilmihee illaa bimaa shaa\'. Wasi\'a kursiyyuhus-samaawaati wal-ardh. Wa laa ya\'ooduhoo hifzhuhumaa. Wa huwal-\'aliyyul-\'azeem.',
    translations: {
      'en':
          'Allah — there is no deity except Him, the Ever-Living, the Sustainer of existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.',
      'ur':
          'اللّٰہ — اس کے سوا کوئی معبود نہیں، وہ زندہ ہے، سب کا قائم رکھنے والا ہے۔ نہ اسے اونگھ آتی ہے نہ نیند۔ آسمانوں اور زمین میں جو کچھ ہے سب اسی کا ہے۔ کون ہے جو اس کی اجازت کے بغیر اس کے سامنے سفارش کر سکے؟ جو کچھ ان کے سامنے ہے اور جو کچھ ان کے پیچھے ہے وہ سب جانتا ہے۔ اور وہ اس کے علم میں سے کسی چیز کا احاطہ نہیں کر سکتے مگر جتنا وہ چاہے۔ اس کی کرسی آسمانوں اور زمین کو محیط ہے۔ اور ان دونوں کی حفاظت اس پر بوجھ نہیں ڈالتی۔ اور وہ بلند و عظیم ہے۔',
      'fr':
          'Allah ! Point de divinité à part Lui, le Vivant, Celui qui subsiste par lui-même. Ni somnolence ni sommeil ne Le saisissent. À Lui appartient tout ce qui est dans les cieux et sur la terre. Qui peut intercéder auprès de Lui sans Sa permission ? Il connaît leur passé et leur futur. Et ils n\'embrassent de Sa science que ce qu\'Il veut. Son Trône déborde les cieux et la terre, dont la garde ne Lui coûte aucune peine. Et Il est le Très Haut, le Très Grand.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Baqarah 2:255',
    category: 'Protection & Tawheed',
    occasion: 'After every obligatory prayer & before sleeping — greatest verse of the Quran',
    tags: ['protection', 'tawheed', 'daily', 'morning', 'evening', 'sleep', 'powerful', 'ayatul-kursi'],
  ),

  // ── 62. Surah An-Nas 114:1-6 ──────────────────────────────────────────────
  Dua(
    id: 62,
    arabic:
        'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ﴿١﴾ مَلِكِ النَّاسِ ﴿٢﴾ إِلَٰهِ النَّاسِ ﴿٣﴾ مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ﴿٤﴾ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ﴿٥﴾ مِنَ الْجِنَّةِ وَالنَّاسِ ﴿٦﴾',
    transliteration:
        'Qul a\'oodhu birabbin-naas. Malikin-naas. Ilaahin-naas. Min sharril-waswaasil-khannaas. Alladhee yuwaswisu fee sudoorin-naas. Minal-jinnati wan-naas.',
    translations: {
      'en':
          'Say, "I seek refuge in the Lord of mankind. The Sovereign of mankind. The God of mankind. From the evil of the retreating whisperer — Who whispers in the breasts of mankind — From among the jinn and mankind."',
      'ur':
          'کہو کہ میں لوگوں کے رب کی پناہ مانگتا ہوں۔ لوگوں کے بادشاہ کی۔ لوگوں کے معبود کی۔ پیچھے ہٹ جانے والے وسوسہ ڈالنے والے کے شر سے۔ جو لوگوں کے سینوں میں وسوسہ ڈالتا ہے۔ جنّوں میں سے ہو یا انسانوں میں سے۔',
      'fr':
          'Dis : "Je cherche refuge auprès du Seigneur des hommes. Le Souverain des hommes. Le Dieu des hommes. Contre le mal du tentateur furtif — Qui souffle le mal dans les poitrines des hommes — Qu\'il soit des djinns ou des hommes."',
    },
    source: DuaSource.quran,
    reference: 'Surah An-Nas 114:1-6',
    category: 'Protection',
    occasion: 'Morning & evening adhkar — protection from evil whispers',
    tags: ['protection', 'evil', 'morning', 'evening', 'muawwidhaat', 'waswas'],
  ),

  // ── 63. Surah Al-Ikhlas 112:1-4 ───────────────────────────────────────────
  Dua(
    id: 63,
    arabic:
        'قُلْ هُوَ اللَّهُ أَحَدٌ ﴿١﴾ اللَّهُ الصَّمَدُ ﴿٢﴾ لَمْ يَلِدْ وَلَمْ يُولَدْ ﴿٣﴾ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ ﴿٤﴾',
    transliteration:
        'Qul huwallaahu ahad. Allaahus-samad. Lam yalid wa lam yoolad. Wa lam yakun lahu kufuwan ahad.',
    translations: {
      'en':
          'Say, "He is Allah, the One. Allah, the Eternal Refuge. He neither begets nor is born. Nor is there to Him any equivalent."',
      'ur':
          'کہو کہ وہ اللہ ایک ہے۔ اللہ بے نیاز ہے۔ نہ اس سے کوئی پیدا ہوا نہ وہ کسی سے پیدا ہوا۔ اور نہ کوئی اس کا ہمسر ہے۔',
      'fr':
          'Dis : "Il est Allah, Unique. Allah, le Seul à être imploré pour ce que nous désirons. Il n\'a jamais engendré, n\'a pas été engendré non plus. Et nul n\'est égal à Lui."',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Ikhlas 112:1-4',
    category: 'Tawheed & Protection',
    occasion: 'Morning & evening adhkar — equals one-third of the Quran',
    tags: ['tawheed', 'morning', 'evening', 'daily', 'protection', 'powerful'],
  ),

  // ── 64. Dua of Zakariyya (AS) ─────────────────────────────────────────────
  Dua(
    id: 64,
    arabic: 'رَبِّ لَا تَذَرْنِي فَرْدًا وَأَنتَ خَيْرُ الْوَارِثِينَ',
    transliteration:
        'Rabbi laa tadharnee fardan wa anta khairul-waaritheen.',
    translations: {
      'en':
          'My Lord, do not leave me alone [with no heir], while You are the best of inheritors.',
      'ur':
          'اے میرے رب! مجھے اکیلا نہ چھوڑ اور تو بہترین وارث ہے۔',
      'fr':
          'Ô mon Seigneur, ne me laisse pas seul, et Tu es le meilleur des héritiers.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Anbiya 21:89',
    category: 'Family & Offspring',
    occasion: 'Dua of Zakariyya (AS) — for children and not being left alone',
    tags: ['family', 'children', 'offspring', 'zakariyya', 'loneliness'],
  ),

  // ── 65. Dua of Ibrahim (AS) for Righteous Offspring ───────────────────────
  Dua(
    id: 65,
    arabic: 'رَبِّ هَبْ لِي مِنَ الصَّالِحِينَ',
    transliteration: 'Rabbi hab lee minas-saaliheen.',
    translations: {
      'en': 'My Lord, grant me [a child] from among the righteous.',
      'ur': 'اے میرے رب! مجھے نیک اولاد عطا فرما۔',
      'fr':
          'Ô mon Seigneur, fais-moi don d\'une progéniture vertueuse.',
    },
    source: DuaSource.quran,
    reference: 'Surah As-Saffat 37:100',
    category: 'Family & Offspring',
    occasion: 'Dua of Ibrahim (AS) — for righteous children',
    tags: ['family', 'children', 'righteous', 'ibraheem'],
  ),

  // ── 66. Morning Remembrance ───────────────────────────────────────────────
  Dua(
    id: 66,
    arabic:
        'اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ',
    transliteration:
        'Allaahumma bika asbahnaa wa bika amsainaa wa bika nahyaa wa bika namootu wa ilaikan-nushoor.',
    translations: {
      'en':
          'O Allah, by You we enter the morning, and by You we enter the evening, and by You we live, and by You we die, and to You is the resurrection.',
      'ur':
          'اے اللہ! تیرے (نام) سے ہم نے صبح کی اور تیرے (نام) سے ہم نے شام کی اور تیرے (نام) سے ہم جیتے ہیں اور تیرے (نام) سے ہم مرتے ہیں اور تیری طرف اٹھ کر جانا ہے۔',
      'fr':
          'Ô Allah, c\'est par Toi que nous atteignons le matin, c\'est par Toi que nous atteignons le soir, c\'est par Toi que nous vivons, c\'est par Toi que nous mourons, et c\'est vers Toi la résurrection.',
    },
    source: DuaSource.hadith,
    reference: 'Jami\' At-Tirmidhi 3391, Sunan Abu Dawud 5068',
    category: 'Morning & Evening',
    occasion: 'Morning adhkar',
    tags: ['morning', 'adhkar', 'daily', 'remembrance'],
  ),

  // ── 67. Evening Remembrance ───────────────────────────────────────────────
  Dua(
    id: 67,
    arabic:
        'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَٰذِهِ اللَّيْلَةِ وَخَيْرَ مَا بَعْدَهَا وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَٰذِهِ اللَّيْلَةِ وَشَرِّ مَا بَعْدَهَا رَبِّ أَعُوذُ بِكَ مِنَ الْكَسَلِ وَسُوءِ الْكِبَرِ رَبِّ أَعُوذُ بِكَ مِنْ عَذَابٍ فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ',
    transliteration:
        'Amsainaa wa amsal-mulku lillaah. Wal-hamdu lillaah. Laa ilaaha illallaahu wahdahu laa shareeka lah. Lahul-mulku wa lahul-hamdu wa huwa \'alaa kulli shai\'in qadeer. Rabbi as\'aluka khaira maa fee haadhihil-lailati wa khaira maa ba\'dahaa. Wa a\'oodhu bika min sharri maa fee haadhihil-lailati wa sharri maa ba\'dahaa. Rabbi a\'oodhu bika minal-kasali wa soo\'il-kibar. Rabbi a\'oodhu bika min \'adhaabin fin-naari wa \'adhaabin fil-qabr.',
    translations: {
      'en':
          'We have reached the evening and at this very time the whole kingdom belongs to Allah. All praise is for Allah. There is no god but Allah alone, without any partner. To Him belongs the kingdom and all praise, and He is over all things capable. My Lord, I ask You for the good of this night and the good of what follows it, and I seek refuge in You from the evil of this night and the evil of what follows it. My Lord, I seek refuge in You from laziness and the misery of old age. My Lord, I seek refuge in You from a punishment in the Fire and a punishment in the grave.',
      'ur':
          'ہم نے شام کی اور تمام بادشاہی اللہ کی ہوگئی اور تمام تعریف اللہ کے لیے ہے۔ اللہ کے سوا کوئی معبود نہیں وہ اکیلا ہے اس کا کوئی شریک نہیں، اسی کی بادشاہی ہے اسی کی تعریف ہے اور وہ ہر چیز پر قادر ہے۔ اے میرے رب! میں تجھ سے اس رات کی بھلائی اور اس کے بعد کی بھلائی مانگتا ہوں اور اس رات کے شر اور اس کے بعد کے شر سے تیری پناہ مانگتا ہوں۔ اے میرے رب! میں سستی اور بڑھاپے کی برائی سے تیری پناہ مانگتا ہوں۔ اے میرے رب! میں آگ کے عذاب اور قبر کے عذاب سے تیری پناہ مانگتا ہوں۔',
      'fr':
          'Nous voilà au soir et le royaume appartient à Allah. Louange à Allah. Il n\'y a de divinité qu\'Allah seul, sans associé. À Lui le royaume, à Lui la louange, et Il est capable de toute chose. Seigneur, je Te demande le bien de cette nuit et le bien de ce qui suit. Je cherche refuge auprès de Toi contre le mal de cette nuit et le mal de ce qui suit. Seigneur, je cherche refuge auprès de Toi contre la paresse et les maux de la vieillesse. Seigneur, je cherche refuge auprès de Toi contre un châtiment dans le Feu et un châtiment dans la tombe.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Muslim 2723',
    category: 'Morning & Evening',
    occasion: 'Evening adhkar — in morning replace amsaina with asbahnaa',
    tags: ['evening', 'adhkar', 'daily', 'protection', 'remembrance'],
  ),

  // ── 68. Safety & Wellbeing ────────────────────────────────────────────────
  Dua(
    id: 68,
    arabic:
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي اللَّهُمَّ اسْتُرْ عَوْرَاتِي وَآمِنْ رَوْعَاتِي اللَّهُمَّ احْفَظْنِي مِنْ بَيْنِ يَدَيَّ وَمِنْ خَلْفِي وَعَنْ يَمِينِي وَعَنْ شِمَالِي وَمِنْ فَوْقِي وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ تَحْتِي',
    transliteration:
        'Allaahumma innee as\'alukal-\'afwa wal-\'aafiyata fid-dunyaa wal-aakhirah. Allaahumma innee as\'alukal-\'afwa wal-\'aafiyata fee deenee wa dunyaaya wa ahlee wa maalee. Allaahummast-tur \'awraatee wa aamin raw\'aatee. Allaahummahfazhnee min baini yadayya wa min khalfee wa \'an yameenee wa \'an shimaalee wa min fawqee wa a\'oodhu bi\'azamatika an ughtaala min tahtee.',
    translations: {
      'en':
          'O Allah, I ask You for pardon and well-being in this world and the Hereafter. O Allah, I ask You for pardon and well-being in my religion, worldly affairs, family and wealth. O Allah, cover my faults and calm my fears. O Allah, protect me from in front of me, behind me, on my right, on my left, and from above me, and I seek refuge in Your Greatness from being swallowed up from beneath me.',
      'ur':
          'اے اللہ! میں تجھ سے دنیا اور آخرت میں معافی اور عافیت مانگتا ہوں۔ اے اللہ! میں تجھ سے اپنے دین، دنیا، گھر والوں اور مال میں معافی اور عافیت مانگتا ہوں۔ اے اللہ! میرے عیبوں کو ڈھانپ دے اور میری گھبراہٹوں کو امن میں بدل دے۔ اے اللہ! میری حفاظت فرما میرے آگے سے، پیچھے سے، دائیں سے، بائیں سے، اوپر سے اور میں تیری عظمت کی پناہ لیتا ہوں کہ مجھے نیچے سے ہلاک کیا جائے۔',
      'fr':
          'Ô Allah, je Te demande le pardon et la santé dans ce monde et dans l\'au-delà. Ô Allah, je Te demande le pardon et la santé dans ma religion, ma vie, ma famille et mes biens. Ô Allah, couvre mes défauts et apaise mes craintes. Ô Allah, protège-moi de devant, de derrière, de ma droite, de ma gauche, et d\'au-dessus de moi. Je cherche refuge dans Ta grandeur contre le fait d\'être englouti par en dessous.',
    },
    source: DuaSource.hadith,
    reference: 'Sunan Ibn Majah 3871, Sunan Abu Dawud 5074',
    category: 'Safety & Wellbeing',
    occasion: 'Morning and evening — never missed by the Prophet ﷺ',
    tags: ['safety', 'wellbeing', 'morning', 'evening', 'comprehensive', 'daily', 'protection'],
  ),

  // ── 69. Abu Bakr's Morning & Evening Dua ──────────────────────────────────
  Dua(
    id: 69,
    arabic:
        'اللَّهُمَّ عَالِمَ الْغَيْبِ وَالشَّهَادَةِ فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا أَنْتَ أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي وَمِنْ شَرِّ الشَّيْطَانِ وَشِرْكِهِ',
    transliteration:
        'Allaahumma \'aalimal-ghaibi wash-shahaadati faatiras-samaawaati wal-ardhi rabba kulli shai\'in wa maleekahu ashhadu an laa ilaaha illaa anta a\'oodhu bika min sharri nafsee wa min sharrish-shaitaani wa shirkihi.',
    translations: {
      'en':
          'O Allah, Knower of the unseen and the seen, Creator of the heavens and the earth, Lord and Sovereign of everything, I bear witness that there is no god but You. I seek refuge in You from the evil of my own self and from the evil of Shaytan and his call to associate partners (with You).',
      'ur':
          'اے اللہ! غیب اور حاضر کے جاننے والے، آسمانوں اور زمین کے پیدا کرنے والے، ہر چیز کے رب اور مالک! میں گواہی دیتا ہوں کہ تیرے سوا کوئی معبود نہیں۔ میں اپنے نفس کے شر سے اور شیطان کے شر اور اس کے شرک سے تیری پناہ مانگتا ہوں۔',
      'fr':
          'Ô Allah, Connaisseur de l\'invisible et du visible, Créateur des cieux et de la terre, Seigneur et Souverain de toute chose, j\'atteste qu\'il n\'y a de divinité que Toi. Je cherche refuge auprès de Toi contre le mal de mon âme et contre le mal du diable et de son association.',
    },
    source: DuaSource.hadith,
    reference: 'Jami\' At-Tirmidhi 3392, Musnad Ahmad 63',
    category: 'Morning & Evening',
    occasion: 'Abu Bakr asked the Prophet ﷺ to teach him — morning, evening, and before sleep',
    tags: ['morning', 'evening', 'sleep', 'protection', 'shaytan', 'daily', 'adhkar'],
  ),

  // ── 70. Before Sleeping (Comprehensive) ───────────────────────────────────
  Dua(
    id: 70,
    arabic:
        'اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ وَوَجَّهْتُ وَجْهِي إِلَيْكَ وَفَوَّضْتُ أَمْرِي إِلَيْكَ وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ رَغْبَةً وَرَهْبَةً إِلَيْكَ لَا مَلْجَأَ وَلَا مَنْجَا مِنْكَ إِلَّا إِلَيْكَ آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ وَبِنَبِيِّكَ الَّذِي أَرْسَلْتَ',
    transliteration:
        'Allaahumma aslamtu nafsee ilaika wa wajjahtu wajhee ilaika wa fawwadhtu amree ilaika wa alja\'tu dhahree ilaika raghbatan wa rahbatan ilaika laa malja\'a wa laa manjaa minka illaa ilaika aamantu bikitaabikalladhee anzalta wa binabiyyikalladhee arsalt.',
    translations: {
      'en':
          'O Allah, I submit my soul to You, I turn my face to You, I entrust my affair to You, I commit my back to You, out of hope and fear of You. There is no refuge and no escape from You except to You. I believe in Your Book which You have revealed and in Your Prophet whom You have sent.',
      'ur':
          'اے اللہ! میں نے اپنی جان تیرے سپرد کی اور اپنا چہرہ تیری طرف کیا اور اپنا معاملہ تیرے حوالے کیا اور اپنی پشت تیرے سہارے لگائی، تیری رغبت اور تیرے خوف سے۔ تیرے سوا نہ کوئی پناہ ہے نہ نجات کی جگہ، مگر تیری طرف۔ میں تیری نازل کی ہوئی کتاب پر ایمان لایا اور تیرے بھیجے ہوئے نبی پر ایمان لایا۔',
      'fr':
          'Ô Allah, je Te soumets mon âme, je tourne mon visage vers Toi, je Te confie mon affaire, je m\'adosse à Toi, par désir et crainte de Toi. Il n\'y a de refuge ni d\'échappatoire de Toi vers autre que Toi. Je crois en Ton Livre que Tu as révélé et en Ton Prophète que Tu as envoyé.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Al-Bukhari 6311, 6313, Sahih Muslim 2710',
    category: 'Sleep',
    occasion: 'Before sleeping — whoever dies that night dies upon the Fitrah',
    tags: ['sleep', 'night', 'daily', 'faith', 'powerful'],
  ),

  // ── 71. SubhanAllahi wa bihamdihi — 100 times ─────────────────────────────
  Dua(
    id: 71,
    arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    transliteration: 'Subhaanallaahi wa bihamdihi.',
    translations: {
      'en': 'Glory be to Allah and praise be to Him.',
      'ur': 'اللہ پاک ہے اور اس کی تعریف ہے۔',
      'fr': 'Gloire à Allah et louange à Lui.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Al-Bukhari 6405, Sahih Muslim 2691',
    category: 'Dhikr & Forgiveness',
    occasion: 'Recite 100 times — sins forgiven even if like ocean foam',
    tags: ['dhikr', 'tasbih', 'forgiveness', 'daily', 'powerful', 'morning', 'evening'],
  ),

  // ── 72. La ilaha illAllah wahdahu — 100 times ─────────────────────────────
  Dua(
    id: 72,
    arabic:
        'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
    transliteration:
        'Laa ilaaha illallaahu wahdahu laa shareeka lahu lahul-mulku wa lahul-hamdu wa huwa \'alaa kulli shai\'in qadeer.',
    translations: {
      'en':
          'There is no god but Allah alone, without any partner. His is the dominion and His is the praise, and He is over all things capable.',
      'ur':
          'اللہ کے سوا کوئی معبود نہیں وہ اکیلا ہے اس کا کوئی شریک نہیں۔ اسی کی بادشاہی ہے اور اسی کے لیے تعریف ہے اور وہ ہر چیز پر قادر ہے۔',
      'fr':
          'Il n\'y a de divinité qu\'Allah seul, sans associé. À Lui le royaume, à Lui la louange, et Il est capable de toute chose.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Al-Bukhari 6403, Sahih Muslim 2693',
    category: 'Dhikr & Tawheed',
    occasion: 'Recite 100 times daily — equals freeing 10 slaves, 100 good deeds, 100 sins erased, protection from Shaytan',
    tags: ['dhikr', 'tahleel', 'tawheed', 'daily', 'morning', 'powerful'],
  ),

  // ── 73. Dua upon Calamity ─────────────────────────────────────────────────
  Dua(
    id: 73,
    arabic:
        'إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ اللَّهُمَّ أْجُرْنِي فِي مُصِيبَتِي وَأَخْلِفْ لِي خَيْرًا مِنْهَا',
    transliteration:
        'Innaa lillaahi wa innaa ilaihi raaji\'oon. Allaahumma\'jurnee fee museebatee wa akhlif lee khairan minhaa.',
    translations: {
      'en':
          'Indeed we belong to Allah and indeed to Him we will return. O Allah, reward me for my affliction and replace it for me with something better.',
      'ur':
          'بے شک ہم اللہ کے لیے ہیں اور اسی کی طرف لوٹ کر جانے والے ہیں۔ اے اللہ! مجھے میری مصیبت میں اجر دے اور اس کے بدلے مجھے اس سے بہتر چیز عطا فرما۔',
      'fr':
          'Certes nous appartenons à Allah et c\'est vers Lui que nous retournerons. Ô Allah, récompense-moi dans mon affliction et remplace-la moi par quelque chose de meilleur.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Muslim 918',
    category: 'Calamity & Patience',
    occasion: 'When afflicted by a calamity or loss',
    tags: ['calamity', 'patience', 'loss', 'grief', 'powerful', 'sabr'],
  ),

  // ── 74. Dua for Protection — Morning & Evening ────────────────────────────
  Dua(
    id: 74,
    arabic:
        'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْكُفْرِ وَالْفَقْرِ وَأَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ لَا إِلَٰهَ إِلَّا أَنْتَ',
    transliteration:
        'Allaahumma innee a\'oodhu bika minal-kufri wal-faqri wa a\'oodhu bika min \'adhaabil-qabri laa ilaaha illaa ant.',
    translations: {
      'en':
          'O Allah, I seek refuge in You from disbelief and poverty, and I seek refuge in You from the punishment of the grave. There is no god but You.',
      'ur':
          'اے اللہ! میں کفر اور فقر سے تیری پناہ مانگتا ہوں اور قبر کے عذاب سے تیری پناہ مانگتا ہوں۔ تیرے سوا کوئی معبود نہیں۔',
      'fr':
          'Ô Allah, je cherche refuge auprès de Toi contre la mécréance et la pauvreté, et je cherche refuge auprès de Toi contre le châtiment de la tombe. Il n\'y a de divinité que Toi.',
    },
    source: DuaSource.hadith,
    reference: 'Sunan Abu Dawud 5090, Al-Adab Al-Mufrad 701',
    category: 'Morning & Evening',
    occasion: 'Morning and evening — 3 times each',
    tags: ['morning', 'evening', 'protection', 'poverty', 'daily', 'adhkar'],
  ),

  // ── 75. La hawla wa la quwwata illa billah ────────────────────────────────
  Dua(
    id: 75,
    arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    transliteration: 'Laa hawla wa laa quwwata illaa billaah.',
    translations: {
      'en':
          'There is no might nor power except with Allah.',
      'ur':
          'اللہ کے بغیر نہ کوئی طاقت ہے نہ قوت۔',
      'fr':
          'Il n\'y a de force ni de puissance qu\'en Allah.',
    },
    source: DuaSource.hadith,
    reference: 'Sahih Al-Bukhari 4205, Sahih Muslim 2704',
    category: 'Dhikr & Reliance',
    occasion: 'A treasure from the treasures of Paradise — recite frequently',
    tags: ['dhikr', 'tawakkul', 'paradise', 'daily', 'powerful', 'hawqala'],
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  //  ADDITIONAL QURANIC DUAS (76–105)
  // ═══════════════════════════════════════════════════════════════════════════

  // ── 76. Al-Baqarah 2:285 — Sami'na wa ata'na ─────────────────────────────
  Dua(
    id: 76,
    arabic:
        'سَمِعْنَا وَأَطَعْنَا ۖ غُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ',
    transliteration:
        'Sami\'naa wa ata\'naa ghufraanaka rabbanaa wa ilaikal-maseer.',
    translations: {
      'en':
          'We hear and we obey. [We seek] Your forgiveness, our Lord, and to You is the [final] destination.',
      'ur':
          'ہم نے سنا اور اطاعت کی۔ اے ہمارے رب! ہم تیری مغفرت چاہتے ہیں اور تیری ہی طرف لوٹ کر جانا ہے۔',
      'fr':
          'Nous avons entendu et obéi. Ton pardon, notre Seigneur, et c\'est vers Toi le retour final.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Baqarah 2:285',
    category: 'Obedience & Forgiveness',
    occasion: 'Recited before sleep — last two ayat of Surah Al-Baqarah suffice for whoever recites them at night',
    tags: ['obedience', 'forgiveness', 'sleep', 'daily', 'powerful', 'rabbana'],
  ),

  // ── 77. Aal-Imran 3:9 — Day of Gathering ─────────────────────────────────
  Dua(
    id: 77,
    arabic:
        'رَبَّنَا إِنَّكَ جَامِعُ النَّاسِ لِيَوْمٍ لَّا رَيْبَ فِيهِ ۚ إِنَّ اللَّهَ لَا يُخْلِفُ الْمِيعَادَ',
    transliteration:
        'Rabbanaaa innaka jaami\'un-naasi li-yawmil-laa raiba feeh. Innal-laaha laa yukhliful-mee\'aad.',
    translations: {
      'en':
          'Our Lord, surely You will gather the people for a Day about which there is no doubt. Indeed, Allah does not fail in His promise.',
      'ur':
          'اے ہمارے رب! تو ضرور سب لوگوں کو ایک دن جمع کرے گا جس میں کوئی شک نہیں۔ بے شک اللہ وعدہ خلافی نہیں کرتا۔',
      'fr':
          'Notre Seigneur, Tu rassembleras certainement les hommes pour un Jour sur lequel il n\'y a aucun doute. Certes, Allah ne manque jamais à Sa promesse.',
    },
    source: DuaSource.quran,
    reference: 'Surah Aal-Imran 3:9',
    category: 'Faith & Akhirah',
    occasion: 'Affirming belief in the Day of Judgment',
    tags: ['faith', 'akhirah', 'judgment', 'rabbana'],
  ),

  // ── 78. Aal-Imran 3:26-27 — Malikal-Mulk ────────────────────────────────
  Dua(
    id: 78,
    arabic:
        'اللَّهُمَّ مَالِكَ الْمُلْكِ تُؤْتِي الْمُلْكَ مَن تَشَاءُ وَتَنزِعُ الْمُلْكَ مِمَّن تَشَاءُ وَتُعِزُّ مَن تَشَاءُ وَتُذِلُّ مَن تَشَاءُ ۖ بِيَدِكَ الْخَيْرُ ۖ إِنَّكَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ ﴿٢٦﴾ تُولِجُ اللَّيْلَ فِي النَّهَارِ وَتُولِجُ النَّهَارَ فِي اللَّيْلِ وَتُخْرِجُ الْحَيَّ مِنَ الْمَيِّتِ وَتُخْرِجُ الْمَيِّتَ مِنَ الْحَيِّ وَتَرْزُقُ مَن تَشَاءُ بِغَيْرِ حِسَابٍ ﴿٢٧﴾',
    transliteration:
        'Allaahumma maalikal-mulki tu\'til-mulka man tashaa\'u wa tanzi\'ul-mulka mimman tashaa\'u wa tu\'izzu man tashaa\'u wa tudhillu man tashaa\'u biyadikal-khair. Innaka \'alaa kulli shai\'in qadeer. Toolijul-laila fin-nahaari wa toolijun-nahaara fil-laili wa tukhrijul-hayya minal-mayyiti wa tukhrijul-mayyita minal-hayyi wa tarzuqu man tashaa\'u bighairi hisaab.',
    translations: {
      'en':
          'O Allah, Owner of sovereignty, You give sovereignty to whom You will and You take sovereignty away from whom You will. You honor whom You will and humble whom You will. In Your hand is all good. You are indeed Most Capable of everything. You cause the night to enter the day and the day to enter the night; You bring the living out of the dead and the dead out of the living. And You provide for whom You will without limit.',
      'ur':
          'اے اللہ! بادشاہی کے مالک! تو جسے چاہے بادشاہی دے اور جس سے چاہے چھین لے۔ جسے چاہے عزت دے اور جسے چاہے ذلیل کرے۔ تیرے ہاتھ میں تمام بھلائی ہے۔ بے شک تو ہر چیز پر قادر ہے۔ تو رات کو دن میں داخل کرتا ہے اور دن کو رات میں۔ زندہ کو مردہ سے نکالتا ہے اور مردہ کو زندہ سے۔ اور جسے چاہے بے حساب رزق دیتا ہے۔',
      'fr':
          'Ô Allah, Maître de la souveraineté, Tu donnes la souveraineté à qui Tu veux et Tu la retires à qui Tu veux. Tu honores qui Tu veux et Tu humilies qui Tu veux. Le bien est entre Tes mains. Tu es certes capable de toute chose. Tu fais pénétrer la nuit dans le jour et le jour dans la nuit. Tu fais sortir le vivant du mort et le mort du vivant. Et Tu donnes à qui Tu veux sans compter.',
    },
    source: DuaSource.quran,
    reference: 'Surah Aal-Imran 3:26-27',
    category: 'Sovereignty & Praise',
    occasion: 'Praising Allah as the Owner of all sovereignty and provision',
    tags: ['sovereignty', 'praise', 'tawheed', 'provision', 'powerful'],
  ),

  // ── 79. Aal-Imran 3:38 — Zakariyya for Good Offspring ────────────────────
  Dua(
    id: 79,
    arabic:
        'رَبِّ هَبْ لِي مِن لَّدُنكَ ذُرِّيَّةً طَيِّبَةً ۖ إِنَّكَ سَمِيعُ الدُّعَاءِ',
    transliteration:
        'Rabbi hab lee mil-ladunka dhurriyyatan tayyibah. Innaka samee\'ud-du\'aa\'.',
    translations: {
      'en':
          'My Lord, grant me from Yourself a good offspring. Indeed, You are the Hearer of [all] prayer.',
      'ur':
          'اے میرے رب! مجھے اپنے پاس سے پاکیزہ اولاد عطا فرما۔ بے شک تو دعا سننے والا ہے۔',
      'fr':
          'Ô mon Seigneur, donne-moi une descendance pure. Tu es Celui qui entend les prières.',
    },
    source: DuaSource.quran,
    reference: 'Surah Aal-Imran 3:38',
    category: 'Family & Offspring',
    occasion: 'Dua of Zakariyya (AS) — seeking righteous children',
    tags: ['family', 'children', 'offspring', 'zakariyya', 'rabbana'],
  ),

  // ── 80. Aal-Imran 3:192-194 — Extended Supplication ──────────────────────
  Dua(
    id: 80,
    arabic:
        'رَبَّنَا إِنَّكَ مَن تُدْخِلِ النَّارَ فَقَدْ أَخْزَيْتَهُ ۖ وَمَا لِلظَّالِمِينَ مِنْ أَنصَارٍ ﴿١٩٢﴾ رَّبَّنَا إِنَّنَا سَمِعْنَا مُنَادِيًا يُنَادِي لِلْإِيمَانِ أَنْ آمِنُوا بِرَبِّكُمْ فَآمَنَّا ۚ رَبَّنَا فَاغْفِرْ لَنَا ذُنُوبَنَا وَكَفِّرْ عَنَّا سَيِّئَاتِنَا وَتَوَفَّنَا مَعَ الْأَبْرَارِ ﴿١٩٣﴾ رَبَّنَا وَآتِنَا مَا وَعَدتَّنَا عَلَىٰ رُسُلِكَ وَلَا تُخْزِنَا يَوْمَ الْقِيَامَةِ ۗ إِنَّكَ لَا تُخْلِفُ الْمِيعَادَ ﴿١٩٤﴾',
    transliteration:
        'Rabbanaaa innaka man tudkhilin-naara faqad akhzaitah. Wa maa liz-zaalimeena min ansaar. Rabbanaaa innanaa sami\'naa munaadiyay-yunaadee lil-eemaani an aaminoo birabbikum fa-aamannaa. Rabbanaa faghfir lanaa dhunoobanaa wa kaffir \'annaa sayyi-aatinaa wa tawaffanaa ma\'al-abraar. Rabbanaa wa aatinaa maa wa\'adtanaa \'alaa rusulika wa laa tukhzinaa yawmal-qiyaamah. Innaka laa tukhliful-mee\'aad.',
    translations: {
      'en':
          'Our Lord, indeed whoever You admit to the Fire — You have disgraced him, and for the wrongdoers there are no helpers. Our Lord, indeed we have heard a caller calling to faith, "Believe in your Lord," and we have believed. Our Lord, so forgive us our sins, remove from us our misdeeds, and cause us to die with the righteous. Our Lord, grant us what You have promised us through Your messengers and do not disgrace us on the Day of Resurrection. Indeed, You do not fail in [Your] promise.',
      'ur':
          'اے ہمارے رب! بے شک جسے تو آگ میں داخل کرے اسے تو نے رسوا کیا اور ظالموں کا کوئی مددگار نہ ہوگا۔ اے ہمارے رب! ہم نے ایک پکارنے والے کو ایمان کی طرف پکارتے سنا کہ اپنے رب پر ایمان لاؤ، تو ہم ایمان لائے۔ اے ہمارے رب! ہمارے گناہ بخش دے اور ہماری برائیاں مٹا دے اور ہمیں نیک لوگوں کے ساتھ اٹھا۔ اے ہمارے رب! جو تو نے اپنے رسولوں کے ذریعے وعدہ کیا ہے وہ ہمیں عطا فرما اور ہمیں قیامت کے دن رسوا نہ کر۔ بے شک تو وعدہ خلافی نہیں کرتا۔',
      'fr':
          'Notre Seigneur, quiconque Tu fais entrer dans le Feu, Tu l\'as certes couvert d\'ignominie. Et les injustes n\'ont pas de secoureurs. Notre Seigneur, nous avons entendu un appeleur qui appelait à la foi : « Croyez en votre Seigneur !» et nous avons cru. Notre Seigneur, pardonne-nous nos péchés, efface nos méfaits, et fais-nous mourir avec les vertueux. Notre Seigneur, donne-nous ce que Tu nous as promis par Tes messagers et ne nous couvre pas d\'ignominie au Jour de la Résurrection. Tu ne manques jamais à Ta promesse.',
    },
    source: DuaSource.quran,
    reference: 'Surah Aal-Imran 3:192-194',
    category: 'Forgiveness & Akhirah',
    occasion: 'Continuation of 3:191 — last verses of Surah Aal-Imran, recited by the Prophet ﷺ before sleep',
    tags: ['forgiveness', 'akhirah', 'judgment', 'rabbana', 'powerful', 'sleep'],
  ),

  // ── 81. An-Nisa 4:75 — Dua of the Oppressed ──────────────────────────────
  Dua(
    id: 81,
    arabic:
        'رَبَّنَا أَخْرِجْنَا مِنْ هَٰذِهِ الْقَرْيَةِ الظَّالِمِ أَهْلُهَا وَاجْعَل لَّنَا مِن لَّدُنكَ وَلِيًّا وَاجْعَل لَّنَا مِن لَّدُنكَ نَصِيرًا',
    transliteration:
        'Rabbanaaa akhrijnaa min haadhihil-qaryatiz-zaalimi ahluhaa waj\'al lanaa mil-ladunka waliyyaw-waj\'al lanaa mil-ladunka naseeraa.',
    translations: {
      'en':
          'Our Lord! Deliver us from this land of oppressors! Appoint for us a saviour; appoint for us a helper — all by Your grace.',
      'ur':
          'اے ہمارے رب! ہمیں اس بستی سے نکال جس کے باسی ظالم ہیں اور ہمارے لیے اپنی طرف سے ایک حامی مقرر کر اور اپنی طرف سے ایک مددگار مقرر کر۔',
      'fr':
          'Ô notre Seigneur, fais-nous sortir de cette cité dont les habitants sont injustes, et accorde-nous de Ta part un allié, et accorde-nous de Ta part un secoureur.',
    },
    source: DuaSource.quran,
    reference: 'Surah An-Nisa 4:75',
    category: 'Oppression & Relief',
    occasion: 'Dua of the oppressed — seeking freedom from injustice',
    tags: ['oppression', 'freedom', 'justice', 'help', 'rabbana'],
  ),

  // ── 82. Al-Ma'idah 5:83 — Witnessing the Truth ───────────────────────────
  Dua(
    id: 82,
    arabic:
        'رَبَّنَا آمَنَّا فَاكْتُبْنَا مَعَ الشَّاهِدِينَ',
    transliteration:
        'Rabbanaaa aamannaa fak-tubnaa ma\'ash-shaahideen.',
    translations: {
      'en':
          'Our Lord! We believe, so count us among the witnesses.',
      'ur':
          'اے ہمارے رب! ہم ایمان لائے تو ہمیں گواہی دینے والوں میں لکھ لے۔',
      'fr':
          'Ô notre Seigneur, nous croyons, inscris-nous parmi les témoins.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Ma\'idah 5:83',
    category: 'Faith',
    occasion: 'Affirming faith upon recognizing the truth',
    tags: ['faith', 'witness', 'iman', 'rabbana'],
  ),

  // ── 83. Al-Ma'idah 5:114 — Dua of Isa (AS) ──────────────────────────────
  Dua(
    id: 83,
    arabic:
        'اللَّهُمَّ رَبَّنَا أَنزِلْ عَلَيْنَا مَائِدَةً مِّنَ السَّمَاءِ تَكُونُ لَنَا عِيدًا لِّأَوَّلِنَا وَآخِرِنَا وَآيَةً مِّنكَ ۖ وَارْزُقْنَا وَأَنتَ خَيْرُ الرَّازِقِينَ',
    transliteration:
        'Allaahumma rabbanaaa anzil \'alainaa maaa\'idatam-minas-samaaa\'i takoonu lanaa \'eedal-li-awwalinaa wa aakhirinaa wa aayatam-minka warzuqnaa wa anta khairur-raaziqeen.',
    translations: {
      'en':
          'O Allah, our Lord, send down to us a table [spread with food] from the heaven to be for us a festival for the first of us and the last of us and a sign from You. And provide for us, and You are the best of providers.',
      'ur':
          'اے اللہ ہمارے رب! ہم پر آسمان سے ایک خوان نازل فرما جو ہمارے لیے عید ہو، ہمارے اگلوں اور پچھلوں کے لیے، اور تیری طرف سے ایک نشانی۔ اور ہمیں رزق عطا فرما تو بہترین رزق دینے والا ہے۔',
      'fr':
          'Ô Allah notre Seigneur, fais descendre sur nous du ciel une table servie qui soit une fête pour nous, pour nos prédécesseurs et nos successeurs, et un signe de Toi. Et pourvois-nous, Tu es le meilleur des pourvoyeurs.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Ma\'idah 5:114',
    category: 'Provision',
    occasion: 'Dua of Isa (AS) — asking Allah for provision and signs',
    tags: ['provision', 'isa', 'signs', 'rabbana'],
  ),

  // ── 84. Al-A'raf 7:47 — Protection from Wrongdoers ───────────────────────
  Dua(
    id: 84,
    arabic: 'رَبَّنَا لَا تَجْعَلْنَا مَعَ الْقَوْمِ الظَّالِمِينَ',
    transliteration:
        'Rabbana laa taj\'alnaa ma\'al-qawmiz-zaalimeen.',
    translations: {
      'en':
          'Our Lord, do not place us with the wrongdoing people.',
      'ur':
          'اے ہمارے رب! ہمیں ظالم لوگوں میں شامل نہ کر۔',
      'fr':
          'Ô notre Seigneur, ne nous place pas avec les gens injustes.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-A\'raf 7:47',
    category: 'Protection',
    occasion: 'Seeking protection from being counted among the wrongdoers',
    tags: ['protection', 'wrongdoers', 'rabbana', 'akhirah'],
  ),

  // ── 85. Al-A'raf 7:89 — Judging with Truth ───────────────────────────────
  Dua(
    id: 85,
    arabic:
        'رَبَّنَا افْتَحْ بَيْنَنَا وَبَيْنَ قَوْمِنَا بِالْحَقِّ وَأَنتَ خَيْرُ الْفَاتِحِينَ',
    transliteration:
        'Rabbanaf-tah bainanaa wa baina qawminaa bil-haqqi wa anta khairul-faatiheen.',
    translations: {
      'en':
          'Our Lord, decide between us and our people in truth, and You are the best of those who give decision.',
      'ur':
          'اے ہمارے رب! ہمارے اور ہماری قوم کے درمیان حق کے ساتھ فیصلہ فرما اور تو بہترین فیصلہ کرنے والا ہے۔',
      'fr':
          'Ô notre Seigneur, tranche entre nous et notre peuple avec la vérité, et Tu es le meilleur des juges.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-A\'raf 7:89',
    category: 'Justice',
    occasion: 'Dua of Prophet Shu\'ayb (AS) — seeking just judgment from Allah',
    tags: ['justice', 'truth', 'rabbana', 'prophets'],
  ),

  // ── 86. Al-A'raf 7:151 — Musa (AS) for Forgiveness ───────────────────────
  Dua(
    id: 86,
    arabic:
        'رَبِّ اغْفِرْ لِي وَلِأَخِي وَأَدْخِلْنَا فِي رَحْمَتِكَ ۖ وَأَنتَ أَرْحَمُ الرَّاحِمِينَ',
    transliteration:
        'Rabbigh-fir lee wa li-akhee wa adkhilnaa fee rahmatika wa anta arhamur-raahimeen.',
    translations: {
      'en':
          'My Lord, forgive me and my brother and admit us into Your mercy, for You are the Most Merciful of the merciful.',
      'ur':
          'اے میرے رب! مجھے اور میرے بھائی کو بخش دے اور ہمیں اپنی رحمت میں داخل فرما اور تو سب سے زیادہ رحم کرنے والا ہے۔',
      'fr':
          'Ô mon Seigneur, pardonne-moi ainsi qu\'à mon frère et fais-nous entrer dans Ta miséricorde, car Tu es le plus Miséricordieux des miséricordieux.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-A\'raf 7:151',
    category: 'Forgiveness & Mercy',
    occasion: 'Dua of Musa (AS) — seeking mercy for himself and Harun (AS)',
    tags: ['forgiveness', 'mercy', 'musa', 'family', 'rabbana'],
  ),

  // ── 87. Al-A'raf 7:155-156 — You are our Protector ───────────────────────
  Dua(
    id: 87,
    arabic:
        'أَنتَ وَلِيُّنَا فَاغْفِرْ لَنَا وَارْحَمْنَا ۖ وَأَنتَ خَيْرُ الْغَافِرِينَ',
    transliteration:
        'Anta waliyyunaa faghfir lanaa warhamnaa wa anta khairul-ghaafireen.',
    translations: {
      'en':
          'You are our Protector, so forgive us and have mercy upon us, and You are the best of those who forgive.',
      'ur':
          'تو ہمارا کارساز ہے تو ہمیں بخش دے اور ہم پر رحم فرما اور تو بخشنے والوں میں سب سے بہتر ہے۔',
      'fr':
          'Tu es notre Protecteur, pardonne-nous et aie pitié de nous, et Tu es le meilleur des pardonneurs.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-A\'raf 7:155',
    category: 'Forgiveness',
    occasion: 'Dua of Musa (AS) — after the earthquake struck his seventy companions',
    tags: ['forgiveness', 'mercy', 'musa', 'protection'],
  ),

  // ── 88. Hud 11:47 — Nuh (AS) Seeking Refuge ──────────────────────────────
  Dua(
    id: 88,
    arabic:
        'رَبِّ إِنِّي أَعُوذُ بِكَ أَنْ أَسْأَلَكَ مَا لَيْسَ لِي بِهِ عِلْمٌ ۖ وَإِلَّا تَغْفِرْ لِي وَتَرْحَمْنِي أَكُن مِّنَ الْخَاسِرِينَ',
    transliteration:
        'Rabbi innee a\'oodhu bika an as\'alaka maa laisa lee bihee \'ilm. Wa illaa taghfir lee wa tarhamnee akum-minal-khaasireen.',
    translations: {
      'en':
          'My Lord, I seek refuge in You from asking You about that of which I have no knowledge, and unless You forgive me and have mercy on me, I will surely be among the losers.',
      'ur':
          'اے میرے رب! میں تیری پناہ مانگتا ہوں کہ تجھ سے وہ بات مانگوں جس کا مجھے علم نہیں۔ اور اگر تو مجھے معاف نہ کرے اور مجھ پر رحم نہ فرمائے تو میں نقصان اٹھانے والوں میں سے ہو جاؤں گا۔',
      'fr':
          'Ô mon Seigneur, je cherche refuge auprès de Toi contre le fait de Te demander ce dont je n\'ai aucune connaissance. Et si Tu ne me pardonnes pas et ne me fais pas miséricorde, je serai parmi les perdants.',
    },
    source: DuaSource.quran,
    reference: 'Surah Hud 11:47',
    category: 'Humility & Forgiveness',
    occasion: 'Dua of Nuh (AS) — after asking about his son, showing humility before Allah',
    tags: ['humility', 'forgiveness', 'nuh', 'repentance'],
  ),

  // ── 89. Yusuf 12:101 — Dua of Yusuf (AS) ─────────────────────────────────
  Dua(
    id: 89,
    arabic:
        'رَبِّ قَدْ آتَيْتَنِي مِنَ الْمُلْكِ وَعَلَّمْتَنِي مِن تَأْوِيلِ الْأَحَادِيثِ ۚ فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ أَنتَ وَلِيِّي فِي الدُّنْيَا وَالْآخِرَةِ ۖ تَوَفَّنِي مُسْلِمًا وَأَلْحِقْنِي بِالصَّالِحِينَ',
    transliteration:
        'Rabbi qad aataitanee minal-mulki wa \'allamtanee min ta\'weelil-ahaadeeth. Faatiras-samaawaati wal-ardhi anta waliyyee fid-dunyaa wal-aakhirati tawaffanee muslimaw-wa alhiqnee bis-saaliheen.',
    translations: {
      'en':
          'My Lord, You have certainly granted me [something] of sovereignty and taught me the interpretation of dreams. O Originator of the heavens and the earth, You are my Protector in this world and the Hereafter. Cause me to die a Muslim and join me with the righteous.',
      'ur':
          'اے میرے رب! تو نے مجھے بادشاہی سے کچھ حصہ دیا اور خوابوں کی تعبیر سکھائی۔ اے آسمانوں اور زمین کے پیدا کرنے والے! تو ہی دنیا اور آخرت میں میرا کارساز ہے۔ مجھے مسلمان اٹھا اور نیک لوگوں سے ملا دے۔',
      'fr':
          'Ô mon Seigneur, Tu m\'as donné une part de souveraineté et Tu m\'as enseigné l\'interprétation des rêves. Créateur des cieux et de la terre, Tu es mon protecteur ici-bas et dans l\'au-delà. Fais-moi mourir musulman et fais-moi rejoindre les vertueux.',
    },
    source: DuaSource.quran,
    reference: 'Surah Yusuf 12:101',
    category: 'Gratitude & Righteous Death',
    occasion: 'Dua of Yusuf (AS) — after reuniting with his family, expressing gratitude',
    tags: ['gratitude', 'death', 'yusuf', 'righteousness', 'powerful'],
  ),

  // ── 90. Ibrahim 14:35 — Making Makkah Secure ─────────────────────────────
  Dua(
    id: 90,
    arabic:
        'رَبِّ اجْعَلْ هَٰذَا الْبَلَدَ آمِنًا وَاجْنُبْنِي وَبَنِيَّ أَن نَّعْبُدَ الْأَصْنَامَ',
    transliteration:
        'Rabbij-\'al haadhal-balada aaminaw-wajnubnee wa baniyya an na\'budal-asnaam.',
    translations: {
      'en':
          'My Lord, make this city [Makkah] secure and keep me and my children away from the worship of idols.',
      'ur':
          'اے میرے رب! اس شہر کو امن والا بنا دے اور مجھے اور میری اولاد کو بتوں کی پوجا سے بچا۔',
      'fr':
          'Ô mon Seigneur, fais de cette cité un lieu sûr et préserve-moi ainsi que mes enfants de l\'adoration des idoles.',
    },
    source: DuaSource.quran,
    reference: 'Surah Ibrahim 14:35',
    category: 'Safety & Tawheed',
    occasion: 'Dua of Ibrahim (AS) — for security and pure monotheism',
    tags: ['safety', 'tawheed', 'ibraheem', 'makkah'],
  ),

  // ── 91. Ibrahim 14:38 — Allah Knows All ───────────────────────────────────
  Dua(
    id: 91,
    arabic:
        'رَبَّنَا إِنَّكَ تَعْلَمُ مَا نُخْفِي وَمَا نُعْلِنُ ۗ وَمَا يَخْفَىٰ عَلَى اللَّهِ مِن شَيْءٍ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ',
    transliteration:
        'Rabbanaaa innaka ta\'lamu maa nukhfee wa maa nu\'lin. Wa maa yakhfaa \'alal-laahi min shai\'in fil-ardhi wa laa fis-samaa\'.',
    translations: {
      'en':
          'Our Lord, indeed You know what we conceal and what we declare, and nothing is hidden from Allah on the earth or in the heaven.',
      'ur':
          'اے ہمارے رب! تو جانتا ہے جو ہم چھپاتے ہیں اور جو ظاہر کرتے ہیں۔ اور اللہ سے نہ زمین میں کوئی چیز چھپ سکتی ہے نہ آسمان میں۔',
      'fr':
          'Notre Seigneur, Tu sais ce que nous cachons et ce que nous divulguons. Rien n\'est caché à Allah sur la terre ni dans le ciel.',
    },
    source: DuaSource.quran,
    reference: 'Surah Ibrahim 14:38',
    category: 'Trust & Reliance',
    occasion: 'Dua of Ibrahim (AS) — expressing complete trust in Allah\'s knowledge',
    tags: ['trust', 'reliance', 'ibraheem', 'tawheed', 'rabbana'],
  ),

  // ── 92. Maryam 19:4-5 — Zakariyya's Extended Plea ────────────────────────
  Dua(
    id: 92,
    arabic:
        'رَبِّ إِنِّي وَهَنَ الْعَظْمُ مِنِّي وَاشْتَعَلَ الرَّأْسُ شَيْبًا وَلَمْ أَكُن بِدُعَائِكَ رَبِّ شَقِيًّا ﴿٤﴾ وَإِنِّي خِفْتُ الْمَوَالِيَ مِن وَرَائِي وَكَانَتِ امْرَأَتِي عَاقِرًا فَهَبْ لِي مِن لَّدُنكَ وَلِيًّا ﴿٥﴾',
    transliteration:
        'Rabbi innee wahanal-\'azmu minnee wash-ta\'alar-ra\'su shaibaw-wa lam akum-bidu\'aa\'ika rabbi shaqiyyaa. Wa innee khiftul-mawaaliya miw-waraaa\'ee wa kaanatim-ra\'atee \'aaqiran fahab lee mil-ladunka waliyyaa.',
    translations: {
      'en':
          'My Lord, indeed my bones have become weak and my head has filled with white hair, yet I never have been disappointed in my supplication to You, my Lord. And I fear the successors after me, and my wife has been barren, so grant me from Yourself an heir.',
      'ur':
          'اے میرے رب! میری ہڈیاں کمزور ہو گئی ہیں اور بالوں نے سفیدی سے چمکنا شروع کر دیا ہے اور اے رب! میں تجھ سے دعا مانگ کر کبھی محروم نہیں رہا۔ اور مجھے اپنے بعد اپنے عزیزوں کا خوف ہے اور میری بیوی بانجھ ہے۔ تو مجھے اپنے پاس سے ایک وارث عطا فرما۔',
      'fr':
          'Ô mon Seigneur, mes os sont affaiblis et ma tête s\'est couverte de cheveux blancs, et jamais, en Te priant, ô Seigneur, je n\'ai été déçu. Et je crains les héritiers après moi, et ma femme est stérile. Accorde-moi de Ta part un successeur.',
    },
    source: DuaSource.quran,
    reference: 'Surah Maryam 19:4-5',
    category: 'Family & Offspring',
    occasion: 'Extended dua of Zakariyya (AS) — crying out in old age for an heir',
    tags: ['family', 'children', 'zakariyya', 'old-age', 'hope'],
  ),

  // ── 93. Ta-Ha 20:45 — Musa & Harun Fear Firawn ───────────────────────────
  Dua(
    id: 93,
    arabic:
        'رَبَّنَا إِنَّنَا نَخَافُ أَن يَفْرُطَ عَلَيْنَا أَوْ أَن يَطْغَىٰ',
    transliteration:
        'Rabbanaaa innanaa nakhaafu ay-yafruta \'alainaa aw ay-yatghaa.',
    translations: {
      'en':
          'Our Lord, indeed we fear that he will hasten [punishment] against us or that he will transgress.',
      'ur':
          'اے ہمارے رب! ہمیں ڈر ہے کہ وہ ہم پر زیادتی کرے یا سرکشی کرے۔',
      'fr':
          'Ô notre Seigneur, nous craignons qu\'il ne nous persécute ou qu\'il ne transgresse.',
    },
    source: DuaSource.quran,
    reference: 'Surah Ta-Ha 20:45',
    category: 'Fear & Courage',
    occasion: 'Dua of Musa and Harun (AS) — before facing Firawn. Allah replied: "Do not fear, I am with you both."',
    tags: ['courage', 'fear', 'musa', 'harun', 'rabbana'],
  ),

  // ── 94. Al-Anbiya 21:83 — Ayyub (AS) in Affliction ───────────────────────
  Dua(
    id: 94,
    arabic:
        'رَبِّ إِنِّي مَسَّنِيَ الضُّرُّ وَأَنتَ أَرْحَمُ الرَّاحِمِينَ',
    transliteration:
        'Rabbi annee massaniyad-durru wa anta arhamur-raahimeen.',
    translations: {
      'en':
          'My Lord, indeed adversity has touched me, and You are the Most Merciful of the merciful.',
      'ur':
          'اے میرے رب! مجھے تکلیف پہنچی ہے اور تو سب سے زیادہ رحم کرنے والا ہے۔',
      'fr':
          'Ô mon Seigneur, une adversité m\'a touché et Tu es le plus Miséricordieux des miséricordieux.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Anbiya 21:83',
    category: 'Affliction & Healing',
    occasion: 'Dua of Ayyub (AS) — after prolonged illness. Allah answered and removed his affliction.',
    tags: ['healing', 'affliction', 'patience', 'ayyub', 'powerful', 'sabr'],
  ),

  // ── 95. Al-Mu'minun 23:29 — Blessed Landing ──────────────────────────────
  Dua(
    id: 95,
    arabic:
        'رَبِّ أَنزِلْنِي مُنزَلًا مُّبَارَكًا وَأَنتَ خَيْرُ الْمُنزِلِينَ',
    transliteration:
        'Rabbi anzilnee munzalam-mubaarakaw-wa anta khairul-munzileen.',
    translations: {
      'en':
          'My Lord, let me land at a blessed landing place, and You are the best to accommodate [us].',
      'ur':
          'اے میرے رب! مجھے مبارک جگہ اتار اور تو بہترین مہمان نواز ہے۔',
      'fr':
          'Ô mon Seigneur, fais-moi débarquer d\'un débarquement béni, car Tu es le meilleur de ceux qui font débarquer.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Mu\'minun 23:29',
    category: 'Travel & Safety',
    occasion: 'Dua of Nuh (AS) — upon disembarkation from the Ark',
    tags: ['travel', 'safety', 'nuh', 'blessing'],
  ),

  // ── 96. Al-Mu'minun 23:118 — Short Dua for Mercy ─────────────────────────
  Dua(
    id: 96,
    arabic:
        'رَبِّ اغْفِرْ وَارْحَمْ وَأَنتَ خَيْرُ الرَّاحِمِينَ',
    transliteration:
        'Rabbigh-fir warham wa anta khairur-raahimeen.',
    translations: {
      'en':
          'My Lord, forgive and have mercy, and You are the best of the merciful.',
      'ur':
          'اے میرے رب! بخش دے اور رحم فرما اور تو بہترین رحم کرنے والا ہے۔',
      'fr':
          'Ô mon Seigneur, pardonne et fais miséricorde, car Tu es le meilleur des miséricordieux.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Mu\'minun 23:118',
    category: 'Forgiveness & Mercy',
    occasion: 'Short comprehensive dua for forgiveness and mercy — easy to memorize',
    tags: ['forgiveness', 'mercy', 'short', 'daily', 'rabbana'],
  ),

  // ── 97. Al-Furqan 25:65-66 — Protection from Hell ────────────────────────
  Dua(
    id: 97,
    arabic:
        'رَبَّنَا اصْرِفْ عَنَّا عَذَابَ جَهَنَّمَ ۖ إِنَّ عَذَابَهَا كَانَ غَرَامًا ﴿٦٥﴾ إِنَّهَا سَاءَتْ مُسْتَقَرًّا وَمُقَامًا ﴿٦٦﴾',
    transliteration:
        'Rabbanas-rif \'annaa \'adhaaba jahannama inna \'adhaabahaa kaana gharaamaa. Innahaa saaa\'at mustaqarraw-wa muqaamaa.',
    translations: {
      'en':
          'Our Lord, avert from us the punishment of Hell. Indeed, its punishment is ever adhering; Indeed, it is evil as a settlement and residence.',
      'ur':
          'اے ہمارے رب! ہم سے جہنم کا عذاب ٹال دے۔ بے شک اس کا عذاب ہمیشہ لگا رہنے والا ہے۔ بے شک وہ ٹھکانے اور مقام کے اعتبار سے بہت بری جگہ ہے۔',
      'fr':
          'Notre Seigneur, détourne de nous le châtiment de l\'Enfer, car son châtiment est un tourment permanent. C\'est certes un mauvais gîte et un mauvais séjour.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Furqan 25:65-66',
    category: 'Hellfire Protection',
    occasion: 'Dua of \'Ibad ar-Rahman — Servants of the Most Merciful',
    tags: ['protection', 'hellfire', 'akhirah', 'rabbana', 'ibad-ar-rahman'],
  ),

  // ── 98. Ash-Shu'ara 26:83-87 — Ibrahim for Wisdom ────────────────────────
  Dua(
    id: 98,
    arabic:
        'رَبِّ هَبْ لِي حُكْمًا وَأَلْحِقْنِي بِالصَّالِحِينَ ﴿٨٣﴾ وَاجْعَل لِّي لِسَانَ صِدْقٍ فِي الْآخِرِينَ ﴿٨٤﴾ وَاجْعَلْنِي مِن وَرَثَةِ جَنَّةِ النَّعِيمِ ﴿٨٥﴾ وَاغْفِرْ لِأَبِي إِنَّهُ كَانَ مِنَ الضَّالِّينَ ﴿٨٦﴾ وَلَا تُخْزِنِي يَوْمَ يُبْعَثُونَ ﴿٨٧﴾',
    transliteration:
        'Rabbi hab lee hukmaw-wa alhiqnee bis-saaliheen. Waj\'al lee lisaana sidqin fil-aakhireen. Waj\'alnee miw-warathati jannatinnn-na\'eem. Waghfir li-abee innahoo kaana minad-daaaalleen. Wa laa tukhzinee yawma yub\'athoon.',
    translations: {
      'en':
          'My Lord, grant me authority and join me with the righteous. And grant me a tongue of truthfulness among the later generations. And make me among the inheritors of the Garden of Pleasure. And forgive my father; indeed he has been one of those astray. And do not disgrace me on the Day they are resurrected.',
      'ur':
          'اے میرے رب! مجھے حکمت عطا فرما اور مجھے نیک لوگوں میں شامل کر۔ اور بعد میں آنے والوں میں میرا سچا ذکر باقی رکھ۔ اور مجھے نعمت والی جنت کے وارثوں میں سے بنا۔ اور میرے باپ کو بخش دے، بے شک وہ گمراہوں میں سے تھا۔ اور مجھے اس دن رسوا نہ کر جب لوگ اٹھائے جائیں گے۔',
      'fr':
          'Ô mon Seigneur, accorde-moi sagesse et fais-moi rejoindre les vertueux. Et accorde-moi une langue de vérité parmi les générations futures. Et fais-moi héritier du Jardin des délices. Et pardonne à mon père, il était certes du nombre des égarés. Et ne me couvre pas d\'ignominie le Jour où ils seront ressuscités.',
    },
    source: DuaSource.quran,
    reference: 'Surah Ash-Shu\'ara 26:83-87',
    category: 'Wisdom & Righteousness',
    occasion: 'Dua of Ibrahim (AS) — for wisdom, good legacy, Paradise, and protection from disgrace',
    tags: ['wisdom', 'righteousness', 'ibraheem', 'paradise', 'legacy', 'rabbana'],
  ),

  // ── 99. Ash-Shu'ara 26:169 — Lut (AS) for Family ─────────────────────────
  Dua(
    id: 99,
    arabic: 'رَبِّ نَجِّنِي وَأَهْلِي مِمَّا يَعْمَلُونَ',
    transliteration: 'Rabbi najjinee wa ahlee mimmaa ya\'maloon.',
    translations: {
      'en':
          'My Lord, save me and my family from [the consequence of] what they do.',
      'ur':
          'اے میرے رب! مجھے اور میرے گھر والوں کو ان کے اعمال (کے نتائج) سے بچا لے۔',
      'fr':
          'Ô mon Seigneur, sauve-moi ainsi que ma famille des conséquences de ce qu\'ils font.',
    },
    source: DuaSource.quran,
    reference: 'Surah Ash-Shu\'ara 26:169',
    category: 'Family Protection',
    occasion: 'Dua of Lut (AS) — seeking safety for his family from corruption',
    tags: ['family', 'protection', 'lut', 'safety'],
  ),

  // ── 100. An-Naml 27:19 — Sulaiman's Gratitude ────────────────────────────
  Dua(
    id: 100,
    arabic:
        'رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ الَّتِي أَنْعَمْتَ عَلَيَّ وَعَلَىٰ وَالِدَيَّ وَأَنْ أَعْمَلَ صَالِحًا تَرْضَاهُ وَأَدْخِلْنِي بِرَحْمَتِكَ فِي عِبَادِكَ الصَّالِحِينَ',
    transliteration:
        'Rabbi awzi\'nee an ashkura ni\'matakal-latee an\'amta \'alayya wa \'alaa waalidayya wa an a\'mala saalihan tardaahu wa adkhilnee birahmatika fee \'ibaadakas-saaliheen.',
    translations: {
      'en':
          'My Lord, enable me to be grateful for Your favor which You have bestowed upon me and upon my parents and to do righteous deeds that please You, and admit me by Your mercy into [the ranks of] Your righteous servants.',
      'ur':
          'اے میرے رب! مجھے توفیق دے کہ میں تیری اُس نعمت کا شکر ادا کروں جو تو نے مجھ پر اور میرے والدین پر کی ہے اور یہ کہ ایسا نیک عمل کروں جو تجھے پسند آئے اور مجھے اپنی رحمت سے اپنے نیک بندوں میں داخل کر۔',
      'fr':
          'Ô mon Seigneur, inspire-moi pour que je rende grâce à Ton bienfait dont Tu m\'as comblé ainsi que mes parents, et pour que j\'accomplisse une bonne œuvre que Tu agréeras. Et fais-moi entrer, par Ta miséricorde, parmi Tes serviteurs vertueux.',
    },
    source: DuaSource.quran,
    reference: 'Surah An-Naml 27:19',
    category: 'Gratitude & Righteousness',
    occasion: 'Dua of Sulaiman (AS) — expressing gratitude after hearing the ant',
    tags: ['gratitude', 'parents', 'righteousness', 'sulaiman'],
  ),

  // ── 101. Al-Qasas 28:16 — Musa's Repentance ──────────────────────────────
  Dua(
    id: 101,
    arabic:
        'رَبِّ إِنِّي ظَلَمْتُ نَفْسِي فَاغْفِرْ لِي',
    transliteration: 'Rabbi innee zalamtu nafsee faghfir lee.',
    translations: {
      'en':
          'My Lord, indeed I have wronged myself, so forgive me.',
      'ur':
          'اے میرے رب! میں نے اپنے آپ پر ظلم کیا ہے تو مجھے معاف فرما۔',
      'fr':
          'Ô mon Seigneur, je me suis fait du tort à moi-même, pardonne-moi.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Qasas 28:16',
    category: 'Repentance',
    occasion: 'Dua of Musa (AS) — short and powerful repentance after his mistake. Allah forgave him immediately.',
    tags: ['repentance', 'forgiveness', 'musa', 'short', 'powerful'],
  ),

  // ── 102. Al-Qasas 28:21 — Musa Escapes Injustice ─────────────────────────
  Dua(
    id: 102,
    arabic: 'رَبِّ نَجِّنِي مِنَ الْقَوْمِ الظَّالِمِينَ',
    transliteration: 'Rabbi najjinee minal-qawmiz-zaalimeen.',
    translations: {
      'en':
          'My Lord, deliver me from the wrongdoing people.',
      'ur':
          'اے میرے رب! مجھے ظالم قوم سے نجات دے۔',
      'fr':
          'Ô mon Seigneur, délivre-moi du peuple injuste.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Qasas 28:21',
    category: 'Oppression & Relief',
    occasion: 'Dua of Musa (AS) — while fleeing Firawn\'s city',
    tags: ['oppression', 'freedom', 'musa', 'safety', 'short'],
  ),

  // ── 103. Al-'Ankabut 29:30 — Against Corruption ──────────────────────────
  Dua(
    id: 103,
    arabic: 'رَبِّ انصُرْنِي عَلَى الْقَوْمِ الْمُفْسِدِينَ',
    transliteration: 'Rabbin-surnee \'alal-qawmil-mufsideen.',
    translations: {
      'en':
          'My Lord, support me against the people of corruption.',
      'ur':
          'اے میرے رب! فساد پھیلانے والی قوم کے خلاف میری مدد فرما۔',
      'fr':
          'Ô mon Seigneur, secours-moi contre le peuple corrupteur.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-\'Ankabut 29:30',
    category: 'Victory & Justice',
    occasion: 'Dua of Lut (AS) — seeking help against corruption',
    tags: ['justice', 'victory', 'lut', 'corruption', 'help'],
  ),

  // ── 104. Ghafir 40:7-9 — Angels' Dua for Believers ───────────────────────
  Dua(
    id: 104,
    arabic:
        'رَبَّنَا وَسِعْتَ كُلَّ شَيْءٍ رَّحْمَةً وَعِلْمًا فَاغْفِرْ لِلَّذِينَ تَابُوا وَاتَّبَعُوا سَبِيلَكَ وَقِهِمْ عَذَابَ الْجَحِيمِ ﴿٧﴾ رَبَّنَا وَأَدْخِلْهُمْ جَنَّاتِ عَدْنٍ الَّتِي وَعَدتَّهُمْ وَمَن صَلَحَ مِنْ آبَائِهِمْ وَأَزْوَاجِهِمْ وَذُرِّيَّاتِهِمْ ۚ إِنَّكَ أَنتَ الْعَزِيزُ الْحَكِيمُ ﴿٨﴾ وَقِهِمُ السَّيِّئَاتِ ۚ وَمَن تَقِ السَّيِّئَاتِ يَوْمَئِذٍ فَقَدْ رَحِمْتَهُ ۚ وَذَٰلِكَ هُوَ الْفَوْزُ الْعَظِيمُ ﴿٩﴾',
    transliteration:
        'Rabbanaa wasi\'ta kulla shai\'ir-rahmataw-wa \'ilman faghfir lilladheena taaboo wattaba\'oo sabeelaka wa qihim \'adhabal-jaheem. Rabbanaa wa adkhilhum jannaati \'adninil-latee wa\'adtahum wa man salaha min aabaaa\'ihim wa azwaajihim wa dhurriyyaatihim. Innaka antal-\'azeezul-hakeem. Wa qihimus-sayyi-aat. Wa man taqis-sayyi-aati yawma-idhin faqad rahimtah. Wa dhaalika huwal-fawzul-\'azeem.',
    translations: {
      'en':
          'Our Lord, You have encompassed all things in mercy and knowledge, so forgive those who have repented and followed Your way and protect them from the punishment of Hellfire. Our Lord, and admit them to Gardens of perpetual residence which You have promised them and whoever was righteous among their fathers, their spouses and their offspring. Indeed, You are the Exalted in Might, the Wise. And protect them from evil deeds. And he whom You protect from evil deeds that Day — You will have given him mercy. And that is the great attainment.',
      'ur':
          'اے ہمارے رب! تو نے ہر چیز کو رحمت اور علم سے وسعت دی ہے۔ پس توبہ کرنے والوں اور تیرے راستے پر چلنے والوں کو بخش دے اور انہیں جہنم کے عذاب سے بچا۔ اے ہمارے رب! انہیں ہمیشہ رہنے والی جنتوں میں داخل فرما جن کا تو نے ان سے وعدہ کیا ہے اور ان کے آباؤ اجداد، بیویوں اور اولاد میں سے جو نیک ہوں (انہیں بھی)۔ بے شک تو ہی غالب حکمت والا ہے۔ اور انہیں برائیوں سے بچا۔ اور جسے تو اُس دن برائیوں سے بچالے تو تو نے اس پر رحم فرمایا۔ اور یہی بڑی کامیابی ہے۔',
      'fr':
          'Notre Seigneur, Tu contiens toute chose en Ta miséricorde et en Ta science. Pardonne donc à ceux qui se repentent et suivent Ton chemin et préserve-les du châtiment de l\'Enfer. Notre Seigneur, fais-les entrer aux jardins d\'Éden que Tu leur as promis, ainsi que les vertueux parmi leurs ancêtres, leurs conjoints et leurs descendants. Tu es certes le Puissant, le Sage. Et préserve-les des mauvaises actions. Quiconque Tu préserves des mauvaises actions ce Jour-là, Tu lui auras fait miséricorde. Et c\'est cela le grand succès.',
    },
    source: DuaSource.quran,
    reference: 'Surah Ghafir 40:7-9',
    category: 'Forgiveness & Paradise',
    occasion: 'Dua of the angels who bear the Throne — interceding for the believers',
    tags: ['forgiveness', 'paradise', 'family', 'angels', 'rabbana', 'powerful'],
  ),

  // ── 105. Ad-Dukhan 44:12 — Removing Punishment ───────────────────────────
  Dua(
    id: 105,
    arabic:
        'رَبَّنَا اكْشِفْ عَنَّا الْعَذَابَ إِنَّا مُؤْمِنُونَ',
    transliteration:
        'Rabbanakshif \'annal-\'adhaaba innaa mu\'minoon.',
    translations: {
      'en':
          'Our Lord, remove from us the punishment; indeed, we are believers.',
      'ur':
          'اے ہمارے رب! ہم سے عذاب دور کر دے بے شک ہم ایمان والے ہیں۔',
      'fr':
          'Ô notre Seigneur, éloigne de nous le châtiment, certes nous sommes croyants.',
    },
    source: DuaSource.quran,
    reference: 'Surah Ad-Dukhan 44:12',
    category: 'Relief & Mercy',
    occasion: 'Plea to remove affliction and punishment',
    tags: ['relief', 'mercy', 'punishment', 'rabbana'],
  ),

  // ── 106. Al-Mumtahanah 60:4-5 — Trust & No Fitnah ───────────────────────
  Dua(
    id: 106,
    arabic:
        'رَّبَّنَا عَلَيْكَ تَوَكَّلْنَا وَإِلَيْكَ أَنَبْنَا وَإِلَيْكَ الْمَصِيرُ ﴿٤﴾ رَبَّنَا لَا تَجْعَلْنَا فِتْنَةً لِّلَّذِينَ كَفَرُوا وَاغْفِرْ لَنَا رَبَّنَا ۖ إِنَّكَ أَنتَ الْعَزِيزُ الْحَكِيمُ ﴿٥﴾',
    transliteration:
        'Rabbanaa \'alaika tawakkalnaa wa ilaika anabnaa wa ilaikal-maseer. Rabbanaa laa taj\'alnaa fitnatal-lilladheena kafaroo waghfir lanaa Rabbanaaa innaka antal-\'azeezul-hakeem.',
    translations: {
      'en':
          'Our Lord, upon You we have relied and to You we have turned, and to You is the final destination. Our Lord, make us not a trial for the disbelievers, and forgive us, our Lord. Indeed, You are the Exalted in Might, the Wise.',
      'ur':
          'اے ہمارے رب! ہم نے تجھ پر بھروسہ کیا اور تیری طرف رجوع کیا اور تیری ہی طرف لوٹنا ہے۔ اے ہمارے رب! ہمیں کافروں کے لیے فتنہ نہ بنا اور ہمیں بخش دے۔ اے ہمارے رب! بے شک تو ہی غالب حکمت والا ہے۔',
      'fr':
          'Notre Seigneur, c\'est en Toi que nous plaçons notre confiance, vers Toi nous nous tournons et vers Toi est le retour final. Notre Seigneur, ne fais pas de nous une épreuve pour les mécréants et pardonne-nous, notre Seigneur, car Tu es le Puissant, le Sage.',
    },
    source: DuaSource.quran,
    reference: 'Surah Al-Mumtahanah 60:4-5',
    category: 'Trust & Fitnah Protection',
    occasion: 'Dua of Ibrahim (AS) — placing complete trust in Allah and seeking protection from being a trial for disbelievers',
    tags: ['trust', 'tawakkul', 'ibraheem', 'protection', 'fitnah', 'rabbana'],
  ),

  // ── 107. At-Tahrim 66:11 — Asiya's Dua for Paradise ──────────────────────
  Dua(
    id: 107,
    arabic:
        'رَبِّ ابْنِ لِي عِندَكَ بَيْتًا فِي الْجَنَّةِ وَنَجِّنِي مِن فِرْعَوْنَ وَعَمَلِهِ وَنَجِّنِي مِنَ الْقَوْمِ الظَّالِمِينَ',
    transliteration:
        'Rabbibnee lee \'indaka baitan fil-jannati wa najjinee min fir\'awna wa \'amalihee wa najjinee minal-qawmiz-zaalimeen.',
    translations: {
      'en':
          'My Lord, build for me near You a house in Paradise and deliver me from Pharaoh and his deeds, and deliver me from the wrongdoing people.',
      'ur':
          'اے میرے رب! میرے لیے اپنے پاس جنت میں ایک گھر بنا دے اور مجھے فرعون اور اس کے عمل سے بچا اور مجھے ظالم قوم سے نجات دے۔',
      'fr':
          'Ô mon Seigneur, construis-moi auprès de Toi une maison au Paradis, délivre-moi de Pharaon et de ses œuvres, et délivre-moi du peuple injuste.',
    },
    source: DuaSource.quran,
    reference: 'Surah At-Tahrim 66:11',
    category: 'Paradise',
    occasion: 'Dua of Asiya, wife of Firawn — one of the greatest women ever. She chose Allah and Paradise over worldly power.',
    tags: ['paradise', 'asiya', 'women', 'oppression', 'powerful'],
  ),
];
