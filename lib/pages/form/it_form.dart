import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ITForm extends StatelessWidget {
  final TextEditingController brandController;
  final TextEditingController modelController;
  final TextEditingController categoryController;
  final TextEditingController patrimonyController;
  final TextEditingController statusController;
  final TextEditingController acquisitionDateController;
  final TextEditingController supplierController;
  final TextEditingController purchasePriceController;
  final TextEditingController processNumberController;
  final TextEditingController currentOwnerController;
  final TextEditingController unitLocationController;
  final TextEditingController serialNumberController;
  final TextEditingController descriptionController;
  final VoidCallback onSearch;
  final _dateMaskFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  final bool showDescription;

  ITForm({super.key, 
    required this.brandController,
    required this.modelController,
    required this.categoryController,
    required this.patrimonyController,
    required this.statusController,
    required this.acquisitionDateController,
    required this.supplierController,
    required this.purchasePriceController,
    required this.processNumberController,
    required this.currentOwnerController,
    required this.unitLocationController,
    required this.serialNumberController,
    required this.descriptionController,
    required this.onSearch,
    this.showDescription = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: brandController,
          decoration: const InputDecoration(labelText: 'Marca'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: modelController,
          decoration: const InputDecoration(labelText: 'Modelo'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: categoryController,
          decoration: const InputDecoration(labelText: 'Categoria'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: patrimonyController,
          decoration: const InputDecoration(labelText: 'Patrimônio'),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: null,
          items: ['Ativo', 'Inativo']
              .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
              .toList(),
          onChanged: (newValue) {
            statusController.text = newValue!;
          },
          decoration: const InputDecoration(labelText: 'Status'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: acquisitionDateController,
          decoration: const InputDecoration(
            labelText: 'Data de Aquisição',
            hintText: 'dd/mm/aaaa',
          ),
          keyboardType: TextInputType.datetime,
          inputFormatters: [_dateMaskFormatter],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: supplierController,
          decoration: const InputDecoration(labelText: 'Fornecedor'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: purchasePriceController,
          decoration: const InputDecoration(labelText: 'Preço de Compra'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: processNumberController,
          decoration: const InputDecoration(labelText: 'Número do Processo'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: currentOwnerController,
          decoration: const InputDecoration(labelText: 'Proprietário Atual'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: unitLocationController,
          decoration: const InputDecoration(labelText: 'Localização'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: serialNumberController,
          decoration: InputDecoration(
            labelText: 'Número de Série',
            suffixIcon: IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: onSearch,
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (showDescription)
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Descrição'),
            maxLines: null,
          ),
      ],
    );
  }
}
