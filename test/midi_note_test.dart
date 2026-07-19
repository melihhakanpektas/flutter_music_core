import 'package:flutter_music_core/flutter_music_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MidiNote.fromMidiNumber', () {
    test('beyaz tuşlar arızasız yazılır (tercihten bağımsız)', () {
      for (final midi in [60, 62, 64, 65, 67, 69, 71]) {
        for (final preferSharps in [true, false]) {
          final note = MidiNote.fromMidiNumber(midi, preferSharps: preferSharps);
          expect(note.accidental, isNull, reason: 'midi $midi');
          expect(note.midiNumber, midi);
        }
      }
    });

    test('siyah tuşlar diyez tercihinde ♯ ile yazılır', () {
      // pc 1,3,6,8,10 → Do♯ Re♯ Fa♯ Sol♯ La♯ (index 0,1,3,4,5).
      const expectedIndex = {61: 0, 63: 1, 66: 3, 68: 4, 70: 5};
      for (final entry in expectedIndex.entries) {
        final note = MidiNote.fromMidiNumber(entry.key);
        expect(note.index, entry.value, reason: 'midi ${entry.key}');
        expect(note.accidental, MusicalAccidental.sharp);
        expect(note.midiNumber, entry.key,
            reason: 'yazım perdeyi değiştirmez');
      }
    });

    test('siyah tuşlar bemol tercihinde ♭ ile yazılır (0.0.3 düzeltmesi: '
        'eskiden -13 ofsetle exception atıyordu)', () {
      // pc 1,3,6,8,10 → Re♭ Mi♭ Sol♭ La♭ Si♭ (index 1,2,4,5,6).
      const expectedIndex = {61: 1, 63: 2, 66: 4, 68: 5, 70: 6};
      for (final entry in expectedIndex.entries) {
        final note =
            MidiNote.fromMidiNumber(entry.key, preferSharps: false);
        expect(note.index, entry.value, reason: 'midi ${entry.key}');
        expect(note.accidental, MusicalAccidental.flat);
        expect(note.octave, 4, reason: 'komşu beyaz harf aynı oktavda');
        expect(note.midiNumber, entry.key,
            reason: 'yazım perdeyi değiştirmez');
      }
    });

    test('oktav sınırlarında doğru oktavı verir', () {
      final cSharp = MidiNote.fromMidiNumber(49); // Do♯3
      expect((cSharp.index, cSharp.octave), (0, 3));
      final bFlat = MidiNote.fromMidiNumber(82, preferSharps: false); // Si♭5
      expect((bFlat.index, bFlat.octave), (6, 5));
    });
  });

  group('MidiNote.add (aralık derecesiyle yazım)', () {
    test('artık dörtlü Fa üstünde Si natürel verir', () {
      const f4 = MidiNote(index: 3, octave: 4);
      final result = f4.add(MusicalInterval.augmentedFourth);
      expect((result.index, result.accidental, result.midiNumber),
          (6, null, 71));
    });

    test('eksik yedili Do üstünde Si𝄫 verir (La değil)', () {
      const c4 = MidiNote(index: 0, octave: 4);
      final result = c4.add(MusicalInterval.diminishedSeventh);
      expect((result.index, result.accidental, result.midiNumber),
          (6, MusicalAccidental.doubleFlat, 69));
    });
  });
}
