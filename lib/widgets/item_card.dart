import 'package:flutter/material.dart';

Widget buildItemCard(List<Map<String, dynamic>> items) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Detalhes do Item',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('Marca: ${item['brand'] ?? 'N/A'}'),
                Text('Modelo: ${item['model'] ?? 'N/A'}'),
                Text('Patrimônio: ${item['patrimony'] ?? 'N/A'}'),
                Text('Categoria: ${item['category'] ?? 'N/A'}'),
                Text('Proprietário: ${item['currentOwner'] ?? 'N/A'} '),
                Text('Unidade: ${item['unitLocation'] ?? 'N/A'} '),
              ],
            ),
          ),
        );
      },
    );
  }