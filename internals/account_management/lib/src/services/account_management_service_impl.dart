import 'package:core/core.dart';

import '../errors/account_failure.dart';
import '../models/user_account.dart';
import '../observability/account_observability_tags.dart';
import '../repositories/account_repository.dart';
import '../requests/account_inquiry_request.dart';
import '../responses/account_inquiry_response.dart';
import '../state/account_state_store.dart';
import 'account_management_service.dart';

class AccountManagementServiceImpl implements AccountManagementService {
  const AccountManagementServiceImpl({
    required AccountRepository repository,
    required AccountStateStore accountStateStore,
    required ObservabilityService observabilityService,
  })  : _repository = repository,
        _accountStateStore = accountStateStore,
        _observabilityService = observabilityService;

  final AccountRepository _repository;
  final AccountStateStore _accountStateStore;
  final ObservabilityService _observabilityService;

  @override
  Future<List<UserAccount>> getAccounts() async {
    try {
      final List<UserAccount> accounts = await _repository.getAccounts();
      _accountStateStore.updateAccounts(accounts);
      return accounts;
    } catch (error, stackTrace) {
      _observabilityService.recordError(
        error,
        stackTrace,
        tags: AccountObservabilityTags.getAccountsService,
      );
      if (error is AccountFailure) {
        rethrow;
      }
      throw AccountFailure(
        code: 'accounts_service_failure',
        message: 'Unable to resolve fake accounts from the service layer.',
        details: <String, dynamic>{'error': error.toString()},
      );
    }
  }

  @override
  Future<AccountInquiryResponse> inquireAccount({
    required AccountInquiryRequest request,
  }) async {
    try {
      return await _repository.inquireAccount(request);
    } catch (error, stackTrace) {
      _observabilityService.recordError(
        error,
        stackTrace,
        tags: AccountObservabilityTags.accountInquiryService,
      );
      if (error is AccountFailure) {
        rethrow;
      }
      throw AccountFailure(
        code: 'account_inquiry_service_failure',
        message: 'Unable to resolve fake account inquiry from the service layer.',
        details: <String, dynamic>{'error': error.toString()},
      );
    }
  }
}
