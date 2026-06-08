import 'package:flutter/foundation.dart';
import 'package:internals/internals.dart';

class AccountController extends ChangeNotifier {
  AccountController({
    required AccountManagementService accountManagementService,
    required AccountStateStore accountStateStore,
  })  : _accountManagementService = accountManagementService,
        _accountStateStore = accountStateStore;

  final AccountManagementService _accountManagementService;
  final AccountStateStore _accountStateStore;

  bool isLoading = false;
  String? errorMessage;
  List<UserAccount> accounts = <UserAccount>[];

  ValueListenable<List<UserAccount>> get liveAccounts =>
      _accountStateStore.accounts;

  Future<void> loadAccounts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      accounts = await _accountManagementService.getAccounts();
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
