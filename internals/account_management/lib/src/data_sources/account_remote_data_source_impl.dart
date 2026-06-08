import 'package:core/core.dart';

import '../errors/account_failure.dart';
import '../models/user_account.dart';
import '../observability/account_observability_tags.dart';
import '../requests/account_inquiry_request.dart';
import '../responses/account_inquiry_response.dart';
import 'account_remote_data_source.dart';

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  const AccountRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AuthSession authSession,
    required ObservabilityService observabilityService,
  })  : _apiClient = apiClient,
        _authSession = authSession,
        _observabilityService = observabilityService;

  final ApiClient _apiClient;
  final AuthSession _authSession;
  final ObservabilityService _observabilityService;

  @override
  Future<List<UserAccount>> getAccounts() async {
    try {
      final AppResult<JsonMap> response = await _apiClient.get(
        '/accounts',
        headers: _authSession.headers,
      );

      if (response.isFailure) {
        throw AccountFailure.fromFailure(response.failure);
      }

      final List<dynamic> payload = response.data['accounts'] as List<dynamic>? ?? <dynamic>[];
      return payload
          .map((dynamic item) => UserAccount.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false);
    } catch (error, stackTrace) {
      _observabilityService.recordError(
        error,
        stackTrace,
        tags: AccountObservabilityTags.getAccountsDataSource,
      );
      if (error is AccountFailure) {
        rethrow;
      }
      throw AccountFailure(
        code: 'accounts_data_source_failure',
        message: 'Unable to load fake accounts.',
        details: <String, dynamic>{'error': error.toString()},
      );
    }
  }

  @override
  Future<AccountInquiryResponse> inquireAccount(
    AccountInquiryRequest request,
  ) async {
    try {
      final AppResult<JsonMap> response = await _apiClient.post(
        '/accounts/inquiry',
        headers: _authSession.headers,
        body: request.toJson(),
      );

      if (response.isFailure) {
        throw AccountFailure.fromFailure(response.failure);
      }

      return AccountInquiryResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      _observabilityService.recordError(
        error,
        stackTrace,
        tags: AccountObservabilityTags.accountInquiryApi,
      );
      if (error is AccountFailure) {
        rethrow;
      }
      throw AccountFailure(
        code: 'account_inquiry_data_source_failure',
        message: 'Unable to perform fake account inquiry.',
        details: <String, dynamic>{'error': error.toString()},
      );
    }
  }
}
