import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:invego_app/pages/util/clean_fields.dart';
import 'package:invego_app/pages/util/dialogs_alert.dart';
import 'package:invego_app/pages/util/formatters.dart';
import 'package:invego_app/pages/util/urls.dart';

class AcquisitonRegisterScreen extends StatelessWidget {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _receptionDateController =
      TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _processNumberController =
      TextEditingController();
  final TextEditingController _invoiceNumberController =
      TextEditingController();
  final TextEditingController _userResponsibleController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final _dateMaskFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  AcquisitonRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Compra'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(labelText: 'Marca'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _modelController,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: 'Quantidade'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _receptionDateController,
                  decoration: const InputDecoration(
                    labelText: 'Data de Recebimento',
                    hintText: 'dd/mm/aaaa',
                  ),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [_dateMaskFormatter],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _supplierController,
                  decoration: const InputDecoration(labelText: 'Fornecedor'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _receiverController,
                  decoration: const InputDecoration(labelText: 'Recebedor'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _processNumberController,
                  decoration:
                      const InputDecoration(labelText: 'Número do Processo'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _invoiceNumberController,
                  decoration:
                      const InputDecoration(labelText: 'Número da Nota Fiscal'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _userResponsibleController,
                  decoration: const InputDecoration(labelText: 'Responsável'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  maxLines: null,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _registerAcquisition(context),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(300, 45)),
              ),
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerAcquisition(BuildContext context) async {
    final String? token = await storage.read(key: 'token');

    final Map<String, dynamic> requestBody = {
      'brand': _brandController.text,
      'model': _modelController.text,
      'category': _categoryController.text,
      'quantity': _quantityController.text,
      'receptionDate': formatDateSend(_receptionDateController.text),
      'supplier': _supplierController.text,
      'receiver': _receiverController.text,
      'processNumber': _processNumberController.text,
      'invoiceNumber': _invoiceNumberController.text,
      'responsibleUser': _userResponsibleController.text,
      'description': _descriptionController.text,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(Urls.AcquisitionRegister.value),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sucesso'),
              content: const Text('Compra registrada com sucesso!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    FieldCleaner.cleanFields(
                      brandController: _brandController,
                      modelController: _modelController,
                      categoryController: _categoryController,
                      quantityController: _quantityController,
                      receptionDateController: _receptionDateController,
                      supplierController: _supplierController,
                      receiverController: _receiverController,
                      processNumberController: _processNumberController,
                      invoiceNumberController: _invoiceNumberController,
                      userResponsibleController: _userResponsibleController,
                      descriptionController: _descriptionController,
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else if (response.statusCode == 403) {
        showSessionExpiredDialog(context);
      }
      else {
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Falha ao registrar a aquisição. Verifique os dados e tente novamente'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Erro ao realizar a requisição para registrar a aquisição.'),
        ),
      );
    }
  }
}
