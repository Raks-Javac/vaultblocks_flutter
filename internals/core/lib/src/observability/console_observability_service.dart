import 'observability_service.dart';

class ConsoleObservabilityService implements ObservabilityService {
  const ConsoleObservabilityService();

  @override
  void recordError(
    Object error,
    StackTrace stackTrace, {
    Map<String, Object?> tags = const <String, Object?>{},
  }) {
    // Intentionally simple for the demo.
    // ignore: avoid_print
    print('Observability error: $error');
    // ignore: avoid_print
    print('Tags: $tags');
    // ignore: avoid_print
    print(stackTrace);
  }

  @override
  void recordEvent(
    String name, {
    Map<String, Object?> tags = const <String, Object?>{},
  }) {
    // ignore: avoid_print
    print('Observability event: $name');
    // ignore: avoid_print
    print('Tags: $tags');
  }
}

