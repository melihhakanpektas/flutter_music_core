## 0.0.2

* `KeySignature` eklendi: MusicXML'in `fifths` modeli (-7..7; + diyez,
  - bemol). `accidentalFor(noteIndex)` bir nota harfinin donanımca
  değiştirilip değiştirilmediğini verir — üretici donanımın kapsadığı
  sesler için ayrıca aksidan yazmamalıdır.
* `MusicalValue.tiedToPrevious` eklendi: önceki notaya bağ (tie). Değer,
  aynı perdedeki önceki notanın süresinin devamıdır; notasyon paketi bağ
  eğrisini çizer. Sus bağlanamaz (assert).
* `MusicalValue.dotted` (0.0.1 sonrası eklenmişti): noktalı değer, süre
  ×1.5 (`timeLength`).

## 0.0.1

* İlk sürüm.
