import 'package:flutter/material.dart';

import '/components/progress.dart';
import '/screens/transaction_form.dart';
import 'contact_form.dart';
import '/models/contact.dart';
import '/database/dao/contact_dao.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    final ContactDao dao = ContactDao();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferência'),
      ),
      body: FutureBuilder<List<Contact>>(
        initialData: const [],
        future: dao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return const Progress();
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<Contact> contatos = snapshot.data!;
              return ListView.builder(
                itemCount: contatos.length,
                itemBuilder: (context, index) {
                  final Contact contato = contatos[index];
                  return _ContatacItem(
                    contato,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TransactionForm(contato: contato),
                      ),
                    ),
                  );
                },
              );
            default:
          }
          return const Text('Erro Desconhecido');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => const ContactForm(),
              ),
            )
            .then((novoContato) => setState(
                  () {},
                )),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class _ContatacItem extends StatelessWidget {
  final Contact contato;
  final Function() onTap;

  const _ContatacItem(
    this.contato, {
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onTap(),
        title: Text(
          contato.nome,
          style: const TextStyle(
            fontSize: 24.0,
          ),
        ),
        subtitle: Text(
          contato.numeroConta.toString(),
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
