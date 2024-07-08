import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final StringBuffer newText = StringBuffer();

    if (text.length == 1) {
      if (int.tryParse(text)! > 3) {
        return oldValue;
      }
    }

    if (text.length == 2 || text.length == 5) {
      newText.write('$text/');
      return newValue.copyWith(
        text: newText.toString(),
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }

    if (text.length > 10) {
      return oldValue;
    }

    return newValue;
  }
}

class DimensionsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final StringBuffer newText = StringBuffer();

    int xCount = 0;
    for (int i = 0; i < text.length; i++) {
      if (text[i] != ' ') {
        if (text[i] == 'X' && i > 0 && text[i - 1] == ' ') {
          continue;
        }
        newText.write(text[i]);
        if (text[i] == 'X') {
          xCount++;
        }
      } else if (text[i] == ' ' && i > 0 && text[i - 1] != 'X') {
        if (xCount <= 2) {
          newText.write(' X ');
          xCount++;
        }
      }
    }

    if (xCount == 3) {
      return oldValue;
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

String formatDateSend(String date) {
  // Divide a string da data em dia, mês e ano
  List<String> dateParts = date.split('/');
  int day = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int year = int.parse(dateParts[2]);

  // Cria um objeto DateTime
  DateTime dateTime = DateTime(year, month, day);

  // Formata a data no formato desejado
  String formattedDate = dateTime.toIso8601String();

  return formattedDate;
}

String formatDateInput(String date) {
  DateTime dataDateTime = DateTime.parse(date);
  return DateFormat('dd/MM/yyyy').format(dataDateTime);
}

String encodeMapToFormUrlEncoded(Map<String, String> data) {
    return data.entries.map((entry) {
      return '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value)}';
    }).join('&');
  }