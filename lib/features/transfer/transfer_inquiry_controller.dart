import 'package:flutter/foundation.dart';
import 'package:vaultblocks_mobile/internals.dart';

class TransferInquiryController extends ChangeNotifier {
  TransferInquiryController({
    required AccountManagementService accountManagementService,
  }) : _accountManagementService = accountManagementService;

  final AccountManagementService _accountManagementService;

  bool isLoading = false;
  String? errorMessage;
  AccountInquiryResponse? response;

  Future<void> inquire({
    required String accountNumber,
    required String bankCode,
  }) async {
    isLoading = true;
    errorMessage = null;
    response = null;
    notifyListeners();

    try {
      response = await _accountManagementService.inquireAccount(
        request: AccountInquiryRequest(
          accountNumber: accountNumber,
          bankCode: bankCode,
        ),
      );
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
