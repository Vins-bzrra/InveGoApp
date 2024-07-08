import 'package:flutter/material.dart';
import 'package:invego_app/widgets/menu_item.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  String _selectedItem = '';
  final listSubItems = [
    'Itens de TI',
    'Mobiliário',
    'Outros',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 40),
                MenuItem(
                  title: 'Adicionar',
                  onTap: () {
                    setState(() {
                      _selectedItem =
                          _selectedItem == 'Adicionar' ? '' : 'Adicionar';
                    });
                  },
                  isExpanded: _selectedItem == 'Adicionar',
                  subItems: listSubItems,
                ),
                const SizedBox(height: 10),
                MenuItem(
                  title: 'Pesquisar',
                  onTap: () {
                    setState(() {
                      _selectedItem =
                          _selectedItem == 'Pesquisar' ? '' : 'Pesquisar';
                    });
                  },
                  isExpanded: _selectedItem == 'Pesquisar',
                  subItems: listSubItems,
                ),
                const SizedBox(height: 10),
                MenuItem(
                  title: 'Transferir',
                  onTap: () {
                    setState(() {
                      _selectedItem =
                          _selectedItem == 'Transferir' ? '' : 'Transferir';
                    });
                  },
                  isExpanded: _selectedItem == 'Transferir',
                  subItems: listSubItems,
                ),
                const SizedBox(height: 10),
                MenuItem(
                  title: 'Atualizar',
                  onTap: () {
                    setState(() {
                      _selectedItem =
                          _selectedItem == 'Atualizar' ? '' : 'Atualizar';
                    });
                  },
                  isExpanded: _selectedItem == 'Atualizar',
                  subItems: listSubItems,
                ),
                const SizedBox(height: 10),
                MenuItem(
                  title: 'Baixar',
                  onTap: () {
                    setState(() {
                      _selectedItem = _selectedItem == 'Baixar' ? '' : 'Baixar';
                    });
                  },
                  isExpanded: _selectedItem == 'Baixar',
                  subItems: listSubItems,
                ),
                const SizedBox(height: 10),
                MenuItem(
                  title: 'Registro',
                  onTap: () {
                    setState(() {
                      _selectedItem =
                          _selectedItem == 'Registro' ? '' : 'Registro';
                    });
                  },
                  isExpanded: _selectedItem == 'Registro',
                  subItems: const [
                    'Registrar Compra',
                  ],
                ),
                const SizedBox(height: 10),
                MenuItem(
                  title: 'Relatórios',
                  onTap: () {
                    setState(() {
                      _selectedItem =
                          _selectedItem == 'Relatórios' ? '' : 'Relatórios';
                    });
                  },
                  isExpanded: _selectedItem == 'Relatórios',
                  subItems: const [
                    'Relatório de Movimentação',
                    'Relatório de Alteração',
                  ],
                ),
                const SizedBox(height: 10),
                MenuItem(
                  title: 'Usuários',
                  onTap: () {
                    setState(() {
                      _selectedItem =
                          _selectedItem == 'Usuário' ? '' : 'Usuário';
                    });
                  },
                  isExpanded: _selectedItem == 'Usuário',
                  subItems: const [
                    'Cadastro de Usuário',
                    'Gerenciamento de Usuários',
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

