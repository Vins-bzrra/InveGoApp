import 'package:flutter/material.dart';

class TransferForm extends StatelessWidget {
  final TextEditingController patrimonyController;
  final TextEditingController newOwnerController;
  final TextEditingController newLocationController;
  final VoidCallback onSearch;
  final bool isFieldsEnable;

  TransferForm({
    required this.patrimonyController,
    required this.newOwnerController,
    required this.newLocationController,
    required this.onSearch,
    required this.isFieldsEnable,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: patrimonyController,
          decoration: InputDecoration(
            labelText: 'Patrimônio',
            suffixIcon: IconButton(
              icon: Icon(Icons.update),
              onPressed: onSearch,
            ),
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: newOwnerController,
          decoration: InputDecoration(labelText: 'Novo Proprietário'),
          enabled: isFieldsEnable,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: newLocationController,
          decoration: InputDecoration(labelText: 'Nova Localização'),
          enabled: isFieldsEnable,
        ),
      ],
    );
  }
}
