
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:invego_app/pages/util/urls.dart';

class ItemOthersDetailsScreen extends StatefulWidget {
  final int itemId;

  const ItemOthersDetailsScreen({Key? key, required this.itemId}) : super(key: key);

  @override
  _ItemOthersDetailsScreenState createState() => _ItemOthersDetailsScreenState();
}

class _ItemOthersDetailsScreenState extends State<ItemOthersDetailsScreen> {
  late Map<String, dynamic> itemDetails = {};
  late List<dynamic> history = [];
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _getItemDetails();
  }

  Future<void> _getItemDetails() async {
    final String? token = await storage.read(key: 'token');

    try {
      final http.Response response = await http.get(
        Uri.parse('${Urls.ItemOthersDetails.value}/${widget.itemId}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          final Map<String, dynamic> responseData =
              json.decode(utf8.decode(response.bodyBytes));
          itemDetails = responseData['item'];
          history = responseData['history'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha ao obter as informações do item. Tente novamente.'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao realizar a requisição para obter as informações do item.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Item'),
      ),
      body: itemDetails.isNotEmpty
          ? DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Informações do Item'),
                      Tab(text: 'Histórico de Movimentação'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildBrandTextField(),
                                buildModelTextField(),
                                buildCategoryTextField(),
                                buildPatrimonyTextField(),
                                buildStatusTextField(),
                                buildAcquisitionDateTextField(),
                                buildSupplierTextField(),
                                buildPurchasePriceTextField(),
                                buildProcessNumberTextField(),
                                buildCurrentOwnerTextField(),
                                buildUnitLocationTextField(),
                                buildColorTextField(),
                                buildMaterialTextField(),
                                buildDimensionsTextField(),
                                buildDescriptionTextField(),
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: DataTable(
                              columns: [
                                const DataColumn(
                                    label: Text('Data da Movimentação')),
                                const DataColumn(
                                    label: Text('Local de Origem')),
                                const DataColumn(
                                    label: Text('Local de Destino')),
                                const DataColumn(
                                    label: Text('Antigo Proprietário')),
                                const DataColumn(
                                    label: Text('Novo Proprietário')),
                                const DataColumn(label: Text('Responsável')),
                              ],
                              rows: history.map((dynamic movement) {
                                final Map<String, dynamic> movementData =
                                    movement as Map<String, dynamic>;
                                return DataRow(
                                  cells: [
                                    DataCell(
                                        Text(movementData['movementDateTime'])),
                                    DataCell(Text(
                                        movementData['previousUnitLocation'])),
                                    DataCell(
                                        Text(movementData['newUnitLocation'])),
                                    DataCell(
                                        Text(movementData['previousOwner'])),
                                    DataCell(Text(movementData['newOwner'])),
                                    DataCell(Text(movementData['nameUser'])),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildBrandTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 150,
              child: Text('Marca',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ))),
          const SizedBox(width: 10),
          const SizedBox(width: 8), // Coluna vazia para espaçamento
          Expanded(
            child: TextField(
              controller:
                  TextEditingController(text: itemDetails['brand'] ?? 'N/A'),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildModelTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 150,
              child: Text('Modelo',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller:
                  TextEditingController(text: itemDetails['model'] ?? 'N/A'),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 150,
              child: Text('Categoria',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller:
                  TextEditingController(text: itemDetails['category'] ?? 'N/A'),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPatrimonyTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 150,
              child: Text('Patrimônio',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: TextEditingController(
                  text: itemDetails['patrimony'] ?? 'N/A'),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatusTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 150,
              child: Text('Status',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller:
                  TextEditingController(text: itemDetails['status'] ?? 'N/A'),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAcquisitionDateTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 150,
              child: Text('Data de Aquisição',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: TextEditingController(
                  text: formatarData(itemDetails['acquisitionDate'] ?? 'N/A')),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSupplierTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 150,
              child: Text('Fornecedor',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller:
                  TextEditingController(text: itemDetails['supplier'] ?? 'N/A'),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPurchasePriceTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 150,
              child: Text('Preço de Compra',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: TextEditingController(
                  text: itemDetails['purchasePrice'] != null
                      ? itemDetails['purchasePrice'].toString()
                      : 'N/A'),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProcessNumberTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 150,
              child: Text('Número do Processo',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: TextEditingController(
                  text: itemDetails['processNumber'] ?? 'N/A'),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCurrentOwnerTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 150,
              child: Text('Proprietário Atual',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: TextEditingController(
                  text: itemDetails['currentOwner'] ?? 'N/A'),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUnitLocationTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 150,
              child: Text('Localização',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: TextEditingController(
                  text: itemDetails['unitLocation'] ?? 'N/A'),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildColorTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 150,
              child: Text('Cor',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: TextEditingController(
                  text: itemDetails['color'] ?? 'N/A'),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMaterialTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 150,
              child: Text('Material',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: TextEditingController(
                  text: itemDetails['material'] ?? 'N/A'),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDimensionsTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 150,
              child: Text('Dimensões',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: TextEditingController(
                  text: itemDetails['dimensions'] ?? 'N/A'),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSerialNumberTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 150,
              child: Text('Número de Série',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: TextEditingController(
                  text: itemDetails['serialNumber'] ?? 'N/A'),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDescriptionTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              width: 150,
              child: Text('Descrição',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: TextEditingController(
                  text: itemDetails['description'] ?? 'N/A'),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  String formatarData(String data) {
    DateTime dataDateTime = DateTime.parse(data);
    return DateFormat('dd/MM/yyyy').format(dataDateTime);
  }
}