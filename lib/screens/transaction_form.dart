import 'dart:async';

import 'package:bytebank_persistence/components/progress.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '/components/response_dialog.dart';
import '/components/transaction_auth_dialog.dart';
import '/models/contact.dart';
import '/models/transaction.dart';
import '/http/webclients/transaction_webclient.dart';

class TransactionForm extends StatefulWidget {
  final Contact contato;

  const TransactionForm({required this.contato, super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  String transactionId = const Uuid().v4();
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova transação'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: _sending,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Progress(
                    message: 'Sending...',
                  ),
                ),
              ),
              Text(
                widget.contato.nome,
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contato.numeroConta.toString(),
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: const TextStyle(fontSize: 24.0),
                  decoration: const InputDecoration(labelText: 'Valor'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      final double value = double.parse(_valueController.text);

                      final Transaction transactionCreated = Transaction(transactionId, widget.contato, value);

                      showDialog(
                        context: context,
                        builder: (contextDialog) {
                          return TransactionAuthDialog(
                            onConfirm: (password) => _save(transactionCreated, password, context),
                          );
                        },
                      );
                    },
                    child: const Text('Transferência'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save(
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    Transaction transaction = await _send(
      transactionCreated,
      password,
      context,
    );
    // ignore: use_build_context_synchronously
    _showSuccessfulMessage(transaction, context);
  }

  Future _showSuccessfulMessage(Transaction transaction, BuildContext context) async {
    if (transaction != null) {
      await showDialog(
        context: context,
        builder: (contextDialog) {
          return const SuccessDialog('Successful transaction');
        },
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  Future<Transaction> _send(
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    setState(() => _sending = true);
    final Transaction transaction = await _webClient.save(transactionCreated, password).catchError((e) {
      _showFailureMessage(context, message: e.message);
    }, test: (e) => e is HttpException).catchError((e) {
      _showFailureMessage(context, message: 'timeout submitting the transaction');
    }, test: (e) => e is TimeoutException).catchError((e) {
      _showFailureMessage(context);
    }).whenComplete(() => setState(() => _sending = false));
    return transaction;
  }

  void _showFailureMessage(
    BuildContext context, {
    String message = 'Unknown error',
  }) {
    showDialog(
      context: context,
      builder: (contextDialog) {
        return FailureDialog(message);
      },
    );
  }
}
