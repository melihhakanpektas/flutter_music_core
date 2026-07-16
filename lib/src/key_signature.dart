import 'package:flutter_music_core/src/musical_accidental.dart';

/// Donanım (key signature): beşinciler çemberi üzerindeki konum.
///
/// MusicXML'in `fifths` modeli: pozitif = diyez sayısı (Sol majör +1,
/// Re majör +2 …), negatif = bemol sayısı (Fa majör -1, Si♭ majör -2 …),
/// 0 = donanımsız (Do majör / La minör).
///
/// Diyezler Fa-Do-Sol-Re-La-Mi-Si, bemoller Si-Mi-La-Re-Sol-Do-Fa sırasıyla
/// eklenir; [accidentalFor] bir nota harfinin donanımca değiştirilip
/// değiştirilmediğini verir (üretici, donanımın kapsadığı sesler için ayrıca
/// aksidan yazmamalıdır).
class KeySignature {
  /// Beşinciler çemberi konumu: -7..7 (+ diyez, - bemol).
  final int fifths;

  const KeySignature(this.fifths)
    : assert(fifths >= -7 && fifths <= 7, 'fifths -7..7 aralığında olmalı');

  /// Donanımsız (Do majör / La minör).
  static const KeySignature none = KeySignature(0);

  int get sharpCount => fifths > 0 ? fifths : 0;
  int get flatCount => fifths < 0 ? -fifths : 0;

  /// Diyez sırası nota indeksleriyle (do=0 … si=6): Fa Do Sol Re La Mi Si.
  static const List<int> sharpOrder = [3, 0, 4, 1, 5, 2, 6];

  /// Bemol sırası nota indeksleriyle: Si Mi La Re Sol Do Fa.
  static const List<int> flatOrder = [6, 2, 5, 1, 4, 0, 3];

  /// Donanımın bu nota harfine (do=0 … si=6) uyguladığı aksidan; donanım
  /// kapsamıyorsa null.
  MusicalAccidental? accidentalFor(int noteIndex) {
    if (fifths > 0 && sharpOrder.take(fifths).contains(noteIndex)) {
      return MusicalAccidental.sharp;
    }
    if (fifths < 0 && flatOrder.take(-fifths).contains(noteIndex)) {
      return MusicalAccidental.flat;
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is KeySignature && other.fifths == fifths;

  @override
  int get hashCode => fifths.hashCode;

  @override
  String toString() => 'KeySignature(fifths: $fifths)';
}
