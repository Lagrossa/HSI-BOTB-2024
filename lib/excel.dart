import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveExcelFile(String text) async {
  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];

  sheetObject.cell(CellIndex.indexByString("A1")).value = "Recognized Text";
  sheetObject.cell(CellIndex.indexByString("A2")).value = text;

  // Save the Excel file
  var fileBytes = excel.save();
  final directory = await getApplicationDocumentsDirectory();
  String filePath = '${directory.path}/output.xlsx';
  File(filePath)
    ..createSync(recursive: true)
    ..writeAsBytesSync(fileBytes!);

  print('Excel file saved at: $filePath');
}
