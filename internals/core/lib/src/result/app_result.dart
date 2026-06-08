import '../errors/app_failure.dart';

class AppResult<T> {
  const AppResult._({
    T? value,
    AppFailure? failure,
  })  : _value = value,
        _failure = failure;

  factory AppResult.success(T value) {
    return AppResult._(value: value);
  }

  factory AppResult.failure(AppFailure failure) {
    return AppResult._(failure: failure);
  }

  final T? _value;
  final AppFailure? _failure;

  bool get isSuccess => _failure == null;
  bool get isFailure => _failure != null;

  T get data => _value as T;
  AppFailure get failure => _failure as AppFailure;

  R fold<R>({
    required R Function(T value) success,
    required R Function(AppFailure failure) failure,
  }) {
    if (isSuccess) {
      return success(data);
    }
    return failure(this.failure);
  }
}

