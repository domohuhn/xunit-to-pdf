// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:xunit_to_pdf/src/output/colors.dart';

pw.Chart createResultsPieChart(dynamic data, dynamic ignore) {
  List<pw.Dataset> dataset = [];
  _addPieDataSet('Passed', data.passed, data.tests, colorPassed, dataset);
  _addPieDataSet('Failed', data.failures, data.tests, colorFailed, dataset);
  _addPieDataSet('Blocked', data.errors, data.tests, colorError, dataset);
  return pw.Chart(grid: pw.PieGrid(), datasets: dataset);
}

pw.Chart createResultsByTypePieChart(dynamic data, dynamic type) {
  List<pw.Dataset> dataset = [];
  _addPieDataSet('Passed', data.passedByType(type), data.testsByType(type),
      colorPassed, dataset);
  _addPieDataSet('Failed', data.failuresByType(type), data.testsByType(type),
      colorFailed, dataset);
  _addPieDataSet('Blocked', data.errorsByType(type), data.testsByType(type),
      colorError, dataset);
  return pw.Chart(grid: pw.PieGrid(), datasets: dataset);
}

void _addPieDataSet(String text, int current, int total, PdfColor color,
    List<pw.Dataset> dataset) {
  if (current > 0 && total > 0) {
    final percent = (100 * current.toDouble() / total).round();
    dataset.add(pw.PieDataSet(
      legend: '$text\n$percent%',
      value: current,
      color: color,
      legendStyle: const pw.TextStyle(fontSize: 10),
    ));
  }
}
