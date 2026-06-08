import 'package:flutter/material.dart';
import 'package:vaultblocks_mobile/internals.dart';

import '../../di/app_di.dart';
import 'account_controller.dart';

class AccountListScreen extends StatefulWidget {
  const AccountListScreen({super.key});

  @override
  State<AccountListScreen> createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  late final AccountController _controller = getIt<AccountController>();

  @override
  void initState() {
    super.initState();
    _controller.loadAccounts();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Accounts'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ValueListenableBuilder<List<UserAccount>>(
                  valueListenable: _controller.liveAccounts,
                  builder: (context, liveAccounts, _) {
                    return Text(
                      'Live account state: ${liveAccounts.length} account(s)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (_controller.isLoading) const LinearProgressIndicator(),
                if (_controller.errorMessage != null) ...<Widget>[
                  const SizedBox(height: 12),
                  Text(
                    _controller.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: _controller.accounts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final UserAccount account = _controller.accounts[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      account.accountName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                  if (account.isPrimary)
                                    const Chip(label: Text('Primary')),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('Account number: ${account.accountNumber}'),
                              Text('Type: ${account.accountType}'),
                              Text('Currency: ${account.currency}'),
                              if (account.availableBalance != null)
                                Text(
                                  'Available balance: ${account.availableBalance}',
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
