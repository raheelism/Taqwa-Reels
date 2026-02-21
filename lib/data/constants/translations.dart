import '../models/translation_edition.dart';

/// Available translation editions from AlQuran Cloud API.
const kTranslations = <TranslationEdition>[
  TranslationEdition(
    id: 'en_sahih',
    displayName: 'Sahih International',
    language: 'English',
    edition: 'en.sahih',
  ),
  TranslationEdition(
    id: 'en_yusufali',
    displayName: 'Yusuf Ali',
    language: 'English',
    edition: 'en.yusufali',
  ),
  TranslationEdition(
    id: 'en_pickthall',
    displayName: 'Pickthall',
    language: 'English',
    edition: 'en.pickthall',
  ),
  TranslationEdition(
    id: 'ur_jalandhry',
    displayName: 'Jalandhry (Urdu)',
    language: 'Urdu',
    edition: 'ur.jalandhry',
  ),
  TranslationEdition(
    id: 'fr_hamidullah',
    displayName: 'Hamidullah (French)',
    language: 'French',
    edition: 'fr.hamidullah',
  ),
];
