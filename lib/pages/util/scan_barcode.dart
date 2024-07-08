import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BarcodeUtils {
  static Future<String?> scanBarcode(BuildContext context) async {
    try {
      var barcode = await BarcodeScanner.scan();
      var cod = barcode.rawContent;
      print("Código de barras lido: $cod");
      return cod;
    } catch (e) {
      if (e is FormatException) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'A operação foi cancelada.'),
        ),
      );
      } else if(e is PlatformException){
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Ocorreu um erro com a plataforma, por favor, verifique as permissões.'),
        ),
      );
      }else {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'A operação não pode ser concluída.'),
        ),
      );
      }
      return null;
    }
  }
}
      