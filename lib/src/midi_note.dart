import 'package:flutter_music_core/flutter_music_core.dart';

class MidiNote {
  /// Index of the note do=0 si=6
  final int index;

  /// Octave of the note 0-8
  /// 4 is the central octave
  final int octave;
  final MusicalAccidental? accidental;

  const MidiNote({required this.index, required this.octave, this.accidental});

  static List<int> get whiteNoteOffsets => [0, 2, 4, 5, 7, 9, 11];
  static List<int> get blackNoteOffsets => [1, 3, 6, 8, 10];

  /// Creates a [MidiNote] from a MIDI number.
  factory MidiNote.fromMidiNumber(
    int midiNumber, {
    bool preferSharps = true, // Default to prefer sharps
  }) {
    final octave = (midiNumber / 12).floor() - 1;
    final exactNoteIndex = midiNumber % 12;
    int noteIndex = whiteNoteOffsets.indexOf(exactNoteIndex);

    // Calculate accidental based on preference. Bu dal yalnız siyah tuşlarda
    // çalışır (pc 1,3,6,8,10): komşu beyaz harf hep aynı oktavdadır, ofset
    // ±1'dir. (0.0.3 düzeltmesi: bemol dalı fazladan -12 düşüyordu → siyah
    // tuşlarda -13 ofsetle exception atıyordu.)
    MusicalAccidental? accidental;
    if (noteIndex == -1) {
      if (preferSharps) {
        noteIndex = whiteNoteOffsets.indexOf((midiNumber - 1) % 12);
        final accidentalOffset = (midiNumber % 12) - whiteNoteOffsets[noteIndex];
        accidental = MusicalAccidental.fromOffsetOrNull(accidentalOffset);
      } else {
        noteIndex = whiteNoteOffsets.indexOf((midiNumber + 1) % 12);
        final flatOffset = (midiNumber % 12) - whiteNoteOffsets[noteIndex];
        accidental = MusicalAccidental.fromOffsetOrNull(flatOffset);
      }
    }

    return MidiNote(index: noteIndex, octave: octave, accidental: accidental);
  }

  factory MidiNote.fromExpandedIndex(int expandedIndex) {
    final index = expandedIndex % 7;
    final octave = expandedIndex ~/ 7;
    return MidiNote(index: index, octave: octave);
  }

  int get expandedIndex {
    return index + (7 * octave);
  }

  /// The MIDI number of the note.
  int get midiNumber {
    return whiteNoteOffsets[index] + (accidental?.offset ?? 0) + (12 * (octave + 1));
  }

  int get midiNumberWithoutAccidental {
    return whiteNoteOffsets[index] + (12 * (octave + 1));
  }

  int get midiNumberIndex {
    return midiNumber % 12;
  }

  MidiNote copyWith({int? index, int? octave, MusicalAccidental? accidental}) {
    return MidiNote(
      index: index ?? this.index,
      octave: octave ?? this.octave,
      accidental: accidental ?? this.accidental,
    );
  }

  /// Adds a [MusicalInterval] to the note.
  MidiNote add(MusicalInterval interval) {
    final addDegreeToNoteIndex = index + interval.degree - 1;
    final newNoteIndex = addDegreeToNoteIndex % 7;
    final octaveAdjustment = (addDegreeToNoteIndex / 7).floor();
    final newOctave = octave + octaveAdjustment;
    final newNoteMidiNumber = midiNumber + interval.semitones;

    final naturalNewMidiNote = MidiNote(index: newNoteIndex, octave: newOctave);

    final newNoteAccidental = MusicalAccidental.fromOffsetOrNull(
      newNoteMidiNumber - naturalNewMidiNote.midiNumber,
    );

    return MidiNote(index: newNoteIndex, octave: newOctave, accidental: newNoteAccidental);
  }

  /// Subtracts a [MusicalInterval] from the note.
  MidiNote subtract(MusicalInterval interval) {
    final addDegreeToNoteIndex = index - interval.degree + 1;
    final newNoteIndex = addDegreeToNoteIndex % 7;
    final octaveAdjustment = (addDegreeToNoteIndex / 7).floor();
    final newOctave = octave + octaveAdjustment;
    final newNoteMidiNumber = midiNumber - interval.semitones;

    final naturalNewMidiNote = MidiNote(index: newNoteIndex, octave: newOctave);

    final newNoteAccidental = MusicalAccidental.fromOffsetOrNull(
      newNoteMidiNumber - naturalNewMidiNote.midiNumber,
    );

    return MidiNote(index: newNoteIndex, octave: newOctave, accidental: newNoteAccidental);
  }

  Map<String, dynamic> toJson() {
    return {'index': index, 'octave': octave, 'accidental': accidental?.name};
  }

  factory MidiNote.fromJson(Map<String, dynamic> json) {
    return MidiNote(
      index: json['index'],
      octave: json['octave'],
      accidental:
          json['accidental'] != null
              ? MusicalAccidental.values.firstWhere((e) => e.name == json['accidental'])
              : null,
    );
  }

  @override
  String toString() {
    return 'MidiNote(index: $index, octave: $octave, accidental: $accidental)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MidiNote &&
        other.index == index &&
        other.octave == octave &&
        other.accidental == accidental;
  }

  @override
  int get hashCode {
    return index.hashCode ^ octave.hashCode ^ accidental.hashCode;
  }
}
