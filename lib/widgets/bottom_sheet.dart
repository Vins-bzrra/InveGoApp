import 'package:flutter/material.dart';
import 'package:invego_app/pages/details%20item/detail_item_IT.dart';
import 'package:invego_app/pages/details%20item/detail_item_furniture.dart';
import 'package:invego_app/pages/details%20item/detail_item_others.dart';


void showBottomSheetSearch(BuildContext context, List<dynamic> itens, String type) {
   late int selectedItemID;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
            itemCount: itens.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> item = itens[index];
              String marca = item['brand'] ?? 'N/A';
              String modelo = item['model'] ?? 'N/A';
              String patrimonio = item['patrimony'] ?? 'N/A';
              String categoria = item['category'] ?? 'N/A';
              return GestureDetector(
                onTap: () {
                  selectedItemID = item['id'];
                  Navigator.pop(context);
                  if(type == "IT"){
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ItemITDetailsScreen(itemId: selectedItemID),
                    ),
                  );
                  }else if(type == "Furniture"){
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ItemFurnitureDetailsScreen(itemId: selectedItemID),
                    ),
                  );
                  }else if(type == "Others"){
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ItemOthersDetailsScreen(itemId: selectedItemID),
                    ),
                  );
                  }
                },
                child: Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('Marca: $marca'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Modelo: $modelo'),
                        Text('Patrimônio: $patrimonio'),
                        Text('Categoria: $categoria'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }