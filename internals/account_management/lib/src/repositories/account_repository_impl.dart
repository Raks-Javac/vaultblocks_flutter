import 'package:core/core.dart';

import '../errors/account_failure.dart';
import '../models/user_account.dart';
import '../observability/account_observability_tags.dart';
import '../requests/account_inquiry_request.dart';
import '../responses/account_inquiry_response.dart';
import '../data_sources/account_remote_data_source.dart';
import 'account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  const AccountRepositoryImpl({
    required AccountRemoteDataSource remoteDataSource,
    required ObservabilityService observabilityService,
  })  : _remoteDataSource = remoteDataSource,
        _observabilityService = observabilityService;

  final AccountRemoteDataSource _remoteDataSource;
  final ObservabilityService _observabilityService;

  @override
  Future<List<UserAccount>> getAccounts() async {
    try {
      return await _remoteDataSource.getAccounts();
    } catch (error, stackTrace) {
      _observabilityService.recordError(
        error,
        stackTrace,
        tags: AccountObservabilityTags.getAccountsRepository,
      );
      if (error is AccountFailure) {
        rethrow;
      }
      throw AccountFailure(
        code: 'accounts_repository_failure',
        message: 'Unable to read fake accounts from the repository.',
        details: <String, dynamic>{'error': error.toString()},
      );
    }
  }

  @override
  Future<AccountInquiryResponse> inquireAccount(
    AccountInquiryRequest request,
  ) async {
    try {
      return await _remoteDataSource.inquireAccount(request);
    } catch (error, stackTrace) {
      _observabilityService.recordError(
        error,
        stackTrace,
        tags: AccountObservabilityTags.accountInquiryRepository,
      );
      if (error is AccountFailure) {
        rethrow;
      }
      throw AccountFailure(
        code: 'account_inquiry_repository_failure',
        message: 'Unable to perform fake account inquiry from the repository.',
        details: <String, dynamic>{'error': error.toString()},
      );
    }
  }
}

