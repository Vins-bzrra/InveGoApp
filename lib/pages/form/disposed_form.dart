import 'package:flutter/material.dart';

class DisposedForm extends StatelessWidget {
  final TextEditingController patrimonyController;
  final VoidCallback onSearch;

  DisposedForm({
    required this.patrimonyController,
    required this.onSearch,
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
      ],
    );
  }
}
