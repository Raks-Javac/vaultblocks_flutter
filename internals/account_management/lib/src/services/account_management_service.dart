import '../models/user_account.dart';
import '../requests/account_inquiry_request.dart';
import '../responses/account_inquiry_response.dart';

abstract class AccountManagementService {
  Future<List<UserAccount>> getAccounts();

  Future<AccountInquiryResponse> inquireAccount({
    required AccountInquiryRequest request,
  });
}

