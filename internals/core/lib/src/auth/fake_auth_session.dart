import 'auth_session.dart';

class FakeAuthSession implements AuthSession {
  const FakeAuthSession();

  @override
  String? get accessToken => 'fake-demo-token';

  @override
  Map<String, String> get headers => <String, String>{
        'Authorization': 'Bearer fake-demo-token',
        'Accept': 'application/json',
      };
}

