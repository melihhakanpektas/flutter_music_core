import 'package:flutter/material.dart';
import 'package:flutter_music_core/src/midi_note.dart';
import 'package:flutter_music_core/src/musical_duration.dart';
import 'package:flutter_music_core/src/rhythmic_type.dart';

class MusicalValue {
  final RhythmicType type;
  final MusicalDuration duration;

  /// Noktalı değer: süre 1.5 katına çıkar; notasyonda notanın sağına
  /// nokta çizilir.
  final bool dotted;

  /// Önceki notaya bağ (tie): bu değer, aynı perdedeki bir önceki notanın
  /// süresinin devamıdır; notasyonda önceki notadan bu notaya bağ çizilir.
  /// Sus bağlanamaz.
  final bool tiedToPrevious;

  final List<MidiNote> _midiNotes;
  final Color? color;

  MusicalValue({
    this.type = RhythmicType.note,
    this.duration = MusicalDuration.quarter,
    this.dotted = false,
    this.tiedToPrevious = false,
    this.color,
    List<MidiNote>? midiNotes,
  }) : assert(
         !(tiedToPrevious && type == RhythmicType.rest),
         'Sus önceki notaya bağlanamaz.',
       ),
       _midiNotes =
           midiNotes ?? [MidiNote(index: 0, octave: 4)]
             ..sort((a, b) => a.midiNumber.compareTo(b.midiNumber));

  List<MidiNote> get midiNotes => _midiNotes;

  /// Birlik nota cinsinden süre (noktalı çarpanı dahil).
  double get timeLength => (1 / duration.value) * (dotted ? 1.5 : 1);
}
