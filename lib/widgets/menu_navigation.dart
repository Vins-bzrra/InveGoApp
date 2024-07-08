import 'package:flutter/material.dart';
import 'package:invego_app/pages/acquisition/acquisition_register.dart';
import 'package:invego_app/pages/disposed/disposed_IT.dart';
import 'package:invego_app/pages/disposed/disposed_furniture.dart';
import 'package:invego_app/pages/disposed/disposed_others.dart';
import 'package:invego_app/pages/register/register_IT.dart';
import 'package:invego_app/pages/register/register_furniture.dart';
import 'package:invego_app/pages/register/register_others.dart';
import 'package:invego_app/pages/reports/report_change.dart';
import 'package:invego_app/pages/reports/report_moviment.dart';
import 'package:invego_app/pages/search/search_IT.dart';
import 'package:invego_app/pages/search/search_furniture.dart';
import 'package:invego_app/pages/search/search_others.dart';
import 'package:invego_app/pages/transfer/transfer_IT.dart';
import 'package:invego_app/pages/transfer/transfer_furniture.dart';
import 'package:invego_app/pages/transfer/transfer_others.dart';
import 'package:invego_app/pages/update/update_IT.dart';
import 'package:invego_app/pages/update/update_furniture.dart';
import 'package:invego_app/pages/update/update_others.dart';
import 'package:invego_app/pages/user/manage_user.dart';
import 'package:invego_app/pages/user/register_user.dart';

class MenuNavigation {
  static void navigate(BuildContext context, String title, String subItem) {
    switch (title) {
      case 'Adicionar':
        _navigateAdicionar(context, subItem);
        break;
      case 'Pesquisar':
        _navigatePesquisar(context, subItem);
        break;
      case 'Transferir':
        _navigateTransfer(context, subItem);
        break;
      case 'Atualizar':
        _navigateUpdate(context, subItem);
        break;
      case 'Baixar':
        _navigateDisposed(context, subItem);
        break;
      case 'Registro':
        _navigateAcquisition(context, subItem);
        break;
      case 'Relatórios':
        _navigateReports(context, subItem);
        break;
      case 'Usuários':
        _navigateUsers(context,subItem);
        break;
      default:
        break;
    }
  }

  static void _navigateAdicionar(BuildContext context, String subItem) {
    switch (subItem) {
      case 'Itens de TI':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterITScreen()));
        break;
      case 'Mobiliário':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterFurnitureScreen()));
        break;
      case 'Outros':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterOthersScreen()));
        break;
      default:
        break;
    }
  }

  static void _navigatePesquisar(BuildContext context, String subItem) {
    switch (subItem) {
      case 'Itens de TI':
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchITScreen()));
        break;
      case 'Mobiliário':
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchFurnitureScreen()));
        break;
      case 'Outros':
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchOthersScreen()));
        break;
      default:
        break;
    }
  }
  
  static void _navigateTransfer(BuildContext context, String subItem) {
    switch (subItem) {
      case 'Itens de TI':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TransferITScreen()));
        break;
      case 'Mobiliário':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TransferFurnitureScreen()));
        break;
      case 'Outros':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TransferOthersScreen()));
        break;
      default:
        break;
    }
  }
  
  static void _navigateUpdate(BuildContext context, String subItem) {
    switch (subItem) {
      case 'Itens de TI':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateITScreen()));
        break;
      case 'Mobiliário':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateFurnitureScreen()));
        break;
      case 'Outros':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateOthersScreen()));
        break;
      default:
        break;
    }
  }
  
  static void _navigateDisposed(BuildContext context, String subItem) {
    switch (subItem) {
      case 'Itens de TI':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const DisposedITScreen()));
        break;
      case 'Mobiliário':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const DisposedFurnitureScreen()));
        break;
      case 'Outros':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const DisposedOthersScreen()));
        break;
      default:
        break;
    }
  }
  
  static void _navigateAcquisition(BuildContext context, String subItem) {
    switch (subItem) {
      case 'Registrar Compra':
        Navigator.push(context, MaterialPageRoute(builder: (context) => AcquisitonRegisterScreen()));
        break;
      default:
        break;
    }
  }

  static void _navigateReports(BuildContext context, String subItem) {
    switch (subItem) {
      case 'Relatório de Movimentação':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportMovimentScreen()));
        break;
      case 'Relatório de Alteração':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportChangeScreen()));
        break;
      default:
        break;
    }
  }

  static void _navigateUsers(BuildContext context, String subItem){
    switch (subItem) {
      case 'Cadastro de Usuário':
        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterUserScreen()));
        break;
      case 'Gerenciamento de Usuários':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserManagementScreen()));
        break;
      default:
        break;
    }
  }
}

