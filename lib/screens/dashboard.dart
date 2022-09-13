import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'contacts_list.dart';
import 'transactions_list.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'lib/assets/bytebank_logo.png',
            ),
          ),
          SizedBox(
            height: 200.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FeatureItem(
                  'Transferência',
                  Icons.monetization_on,
                  onTap: () => _showContactsList(context),
                ),
                _FeatureItem(
                  'Feed de Transações',
                  Icons.description,
                  onTap: () => _showTransactionsList(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showContactsList(BuildContext context) {
  FirebaseCrashlytics.instance.crash();
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const ContactsList(),
    ),
  );
}

void _showTransactionsList(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => TransactionsList(),
    ),
  );
}

class _FeatureItem extends StatelessWidget {
  final String nome;
  final IconData icon;
  final Function() onTap;

  const _FeatureItem(
    this.nome,
    this.icon, {
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 32.0,
      ),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            height: 100,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                Text(
                  nome,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
