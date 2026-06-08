import 'package:flutter/material.dart';

import '../../di/app_di.dart';
import 'transfer_inquiry_controller.dart';

class TransferInquiryScreen extends StatefulWidget {
  const TransferInquiryScreen({super.key});

  @override
  State<TransferInquiryScreen> createState() => _TransferInquiryScreenState();
}

class _TransferInquiryScreenState extends State<TransferInquiryScreen> {
  late final TransferInquiryController _controller =
      getIt<TransferInquiryController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNumberController =
      TextEditingController(text: '0123456789');
  final TextEditingController _bankCodeController =
      TextEditingController(text: '001');

  @override
  void dispose() {
    _accountNumberController.dispose();
    _bankCodeController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    await _controller.inquire(
      accountNumber: _accountNumberController.text.trim(),
      bankCode: _bankCodeController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Transfer Inquiry'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _accountNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Account number',
                    ),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Enter an account number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _bankCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Bank code',
                    ),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Enter a bank code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _controller.isLoading ? null : _handleSubmit,
                    child: const Text('Run inquiry'),
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
                  if (_controller.response != null) ...<Widget>[
                    const SizedBox(height: 12),
                    Text(
                      'Account name: ${_controller.response!.accountName}',
                    ),
                    Text('Bank name: ${_controller.response!.bankName}'),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

