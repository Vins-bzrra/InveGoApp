import 'package:flutter/material.dart';

class FieldCleaner {
  static void cleanFields({
    TextEditingController? brandController,
    TextEditingController? modelController,
    TextEditingController? categoryController,
    TextEditingController? patrimonyController,
    TextEditingController? statusController,
    TextEditingController? acquisitionDateController,
    TextEditingController? supplierController,
    TextEditingController? purchasePriceController,
    TextEditingController? processNumberController,
    TextEditingController? currentOwnerController,
    TextEditingController? unitLocationController,
    TextEditingController? materialController,
    TextEditingController? dimensionsController,
    TextEditingController? colorController,
    TextEditingController? serialNumberController,
    TextEditingController? descriptionController,
    TextEditingController? quantityController,
    TextEditingController? receptionDateController,
    TextEditingController? receiverController,
    TextEditingController? invoiceNumberController,
    TextEditingController? userResponsibleController,
  }) {
    brandController?.clear();
    modelController?.clear();
    categoryController?.clear();
    patrimonyController?.clear();
    statusController?.clear();
    acquisitionDateController?.clear();
    supplierController?.clear();
    purchasePriceController?.clear();
    processNumberController?.clear();
    currentOwnerController?.clear();
    unitLocationController?.clear();
    materialController?.clear();
    dimensionsController?.clear();
    colorController?.clear();
    serialNumberController?.clear();
    descriptionController?.clear();
    quantityController?.clear();
    receptionDateController?.clear();
    receiverController?.clear();
    invoiceNumberController?.clear();
    userResponsibleController?.clear();
  }
}
