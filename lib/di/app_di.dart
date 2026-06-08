import 'package:get_it/get_it.dart';
import 'package:vaultblocks_mobile/internals.dart';

import '../features/accounts/account_controller.dart';
import '../features/transfer/transfer_inquiry_controller.dart';

final GetIt getIt = GetIt.instance;

void setupAppDi() {
  if (getIt.isRegistered<ApiClient>()) {
    return;
  }

  getIt
    ..registerLazySingleton<ApiClient>(() => const FakeApiClient())
    ..registerLazySingleton<AuthSession>(() => const FakeAuthSession())
    ..registerLazySingleton<ObservabilityService>(
      () => const ConsoleObservabilityService(),
    )
    ..registerLazySingleton<AccountStateStore>(() => AccountStateStore())
    ..registerLazySingleton<AccountRemoteDataSource>(
      () => AccountRemoteDataSourceImpl(
        apiClient: getIt<ApiClient>(),
        authSession: getIt<AuthSession>(),
        observabilityService: getIt<ObservabilityService>(),
      ),
    )
    ..registerLazySingleton<AccountRepository>(
      () => AccountRepositoryImpl(
        remoteDataSource: getIt<AccountRemoteDataSource>(),
        observabilityService: getIt<ObservabilityService>(),
      ),
    )
    ..registerLazySingleton<AccountManagementService>(
      () => AccountManagementServiceImpl(
        repository: getIt<AccountRepository>(),
        accountStateStore: getIt<AccountStateStore>(),
        observabilityService: getIt<ObservabilityService>(),
      ),
    )
    ..registerFactory<AccountController>(
      () => AccountController(
        accountManagementService: getIt<AccountManagementService>(),
        accountStateStore: getIt<AccountStateStore>(),
      ),
    )
    ..registerFactory<TransferInquiryController>(
      () => TransferInquiryController(
        accountManagementService: getIt<AccountManagementService>(),
      ),
    );
}
