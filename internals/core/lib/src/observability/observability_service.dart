abstract class ObservabilityService {
  void recordError(
    Object error,
    StackTrace stackTrace, {
    Map<String, Object?> tags = const <String, Object?>{},
  });

  void recordEvent(
    String name, {
    Map<String, Object?> tags = const <String, Object?>{},
  });
}

