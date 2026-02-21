import '../models/reciter.dart';

/// Available Quran reciters.
/// The [folder] maps to the EveryAyah CDN path:
/// `https://everyayah.com/data/{folder}/{surah}{ayah}.mp3`
const kReciters = <Reciter>[
  Reciter(
    id: 'alafasy',
    name: 'Mishary Alafasy',
    folder: 'Alafasy_128kbps',
  ),
  Reciter(
    id: 'sudais',
    name: 'Abdul Rahman Al-Sudais',
    folder: 'Abdurrahmaan_As-Sudais_192kbps',
  ),
  Reciter(
    id: 'husary',
    name: 'Mahmoud Khalil Al-Husary',
    folder: 'Husary_128kbps',
  ),
  Reciter(
    id: 'minshawi',
    name: 'Mohamed Siddiq El-Minshawi',
    folder: 'Minshawy_Murattal_128kbps',
  ),
  Reciter(
    id: 'basit',
    name: 'Abdul Basit Abdul Samad',
    folder: 'Abdul_Basit_Murattal_192kbps',
  ),
];
