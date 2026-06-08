import 'package:core/core.dart';

class AccountFailure extends AppFailure {
  const AccountFailure({
    required super.code,
    required super.message,
    super.details,
  });

  factory AccountFailure.fromFailure(AppFailure failure) {
    return AccountFailure(
      code: failure.code,
      message: failure.message,
      details: failure.details,
    );
  }
}

