/// Set to a fixed moment to preview a date while designing (then hot restart), e.g.
///   DateTime(2026, 11, 18, 9, 0)    midweek
///   DateTime(2026, 11, 20, 17, 45)  Friday, just before Sabbath
///   DateTime(2026, 11, 21, 10, 15)  Sabbath morning
/// Leave null to use the real clock.
const DateTime? kPreviewNow = null;

DateTime appNow() => kPreviewNow ?? DateTime.now();
