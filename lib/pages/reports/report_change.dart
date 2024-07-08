import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:invego_app/pages/util/dialogs_alert.dart';

class ReportChangeScreen extends StatefulWidget {
  const ReportChangeScreen({super.key});

  @override
  _ReportChangeScreenState createState() => _ReportChangeScreenState();
}

class _ReportChangeScreenState extends State<ReportChangeScreen> {
  late DateTime _startDate;
  late DateTime _endDate;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now();
  }

  Future<void> _generateReport(BuildContext context) async {
    final String formattedStartDate =
        '${DateFormat('yyyy-MM-dd').format(_startDate)}T00:00:00';
    final String formattedEndDate =
        '${DateFormat('yyyy-MM-dd').format(_endDate)}T00:00:00';
    final String? token = await storage.read(key: 'token');

    try {
      final http.Response response = await http.get(
        Uri.parse(
            'http://10.0.0.107:8080/inveGo/api/item/change-report?startDate=$formattedStartDate&endDate=$formattedEndDate'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);
        String fileName = 'Relatório de Alteração $formattedDate.pdf';
        const downloadsFolderPath = '/storage/emulated/0/Download';
        String path = '$downloadsFolderPath/$fileName';
        final File file = File(path);
        await file.writeAsBytes(response.bodyBytes);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Relatório salvo na Pasta Downloads'),
          ),
        );
      } else if (response.statusCode == 403) {
        showSessionExpiredDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Falha ao gerar relatório. Verifique os dados e tente novamente'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Erro ao realizar a requisição para geração do relatório.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Alteração'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Data de início:"),
                const SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _startDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != _startDate) {
                      setState(() {
                        _startDate = picked;
                      });
                    }
                  },
                  controller: TextEditingController(
                      text: DateFormat('dd-MM-yyyy').format(_startDate)),
                  decoration: const InputDecoration(
                    hintText: 'Data de início',
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Data de fim:"),
                const SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _endDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != _endDate) {
                      setState(() {
                        _endDate = picked;
                      });
                    }
                  },
                  controller: TextEditingController(
                      text: DateFormat('dd-MM-yyyy').format(_endDate)),
                  decoration: const InputDecoration(
                    hintText: 'Data de fim',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                _generateReport(context);
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(300, 45)),
              ),
              child: const Text('Gerar Relatório'),
            ),
          ],
        ),
      ),
    );
  }
}
