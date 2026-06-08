import 'package:flutter/material.dart';

import 'di/app_di.dart';
import 'features/accounts/account_list_screen.dart';
import 'features/transfer/transfer_inquiry_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupAppDi();
  runApp(const VaultblocksApp());
}

class VaultblocksApp extends StatelessWidget {
  const VaultblocksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vaultblocks Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vaultblocks Mobile'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Accounts'),
              Tab(text: 'Transfer'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            AccountListScreen(),
            TransferInquiryScreen(),
          ],
        ),
      ),
    );
  }
}
