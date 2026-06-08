import 'package:flutter/foundation.dart';

import '../models/user_account.dart';

class AccountStateStore {
  final ValueNotifier<List<UserAccount>> accounts =
      ValueNotifier<List<UserAccount>>(<UserAccount>[]);

  void updateAccounts(List<UserAccount> value) {
    accounts.value = List<UserAccount>.unmodifiable(value);
  }

  void dispose() {
    accounts.dispose();
  }
}

