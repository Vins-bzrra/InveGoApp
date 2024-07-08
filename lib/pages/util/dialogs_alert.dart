import 'package:flutter/material.dart';
import 'package:invego_app/pages/login_page.dart';

void showSessionExpiredDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Sessão Expirada'),
        content: Text('Sua sessão expirou. Por favor, faça o login novamente.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

void showRegisterFailedMesseger(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
          'Falha ao registrar o item. Verifique os dados e tente novamente.'),
    ),
  );
}

void showRegisterRequestErrorMesseger(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Erro durante a requisição de registro do item.'),
    ),
  );
}

void showSearchFailedMesseger(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
          'Falha ao pesquisar pelo item. Verifique os dados e tente novamente'),
    ),
  );
}

void showSearchRequestErrorMesseger(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Erro ao realizar a requisição para pesquisar pelo item.'),
    ),
  );
}

void showTransferFailedMesseger(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
          'Falha ao pesquisar pelo item. Verifique os dados e tente novamente'),
    ),
  );
}

void showTransferRequestErrorMesseger(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Erro ao realizar a requisição para pesquisar pelo item.'),
    ),
  );
}

void showUpdateFailedMesseger(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
          'Falha ao atualizar o item. Verifique os dados e tente novamente'),
    ),
  );
}

void showUpdateRequestErrorMesseger(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Erro ao realizar a requisição para atualizar o item.'),
    ),
  );
}

void showDisposedFailedMesseger(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
          'Falha ao dar baixa no item. Verifique os dados e tente novamente'),
    ),
  );
}

void showDisposedRequestErrorMesseger(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Erro ao realizar a requisição para dar baixa no item.'),
    ),
  );
}

void showPatrimonyEmptyMesseger(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('O campo "Patrimônio" deve estar preenchido.'),
    duration: Duration(seconds: 6),
  ));
}

void showItemNotFoundMesseger(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Item não encontrado. Verifique o patrimônio'),
    ),
  );
}
