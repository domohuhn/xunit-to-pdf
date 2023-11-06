// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

import 'package:pdf/pdf.dart';
import 'package:xunit_to_pdf/src/core/report.dart';
import 'package:xunit_to_pdf/src/core/system_interactions.dart';
import 'package:xunit_to_pdf/src/core/test_types.dart';
import 'package:xunit_to_pdf/src/output/create_pdf.dart';
import 'package:xunit_to_pdf/src/parse/parse_xunit.dart';

class ConversionContext {
  String title;
  String version;
  final DateTime _timestamp;

  List<(TestTypes, String)> inputs = [];

  ConversionContext(
      {required this.title,
      required this.version,
      DateTime? timestamp,
      List<(TestTypes, String)>? filenames})
      : _timestamp = timestamp ?? DateTime.now(),
        inputs = filenames ?? [];

  DateTime get timestamp => _timestamp;

  /// Adds an input file to the conversion list.
  /// In the generated report, the test cases read from the file will be added to the category
  /// given vie [type].
  void addInput(TestTypes type, String filename) {
    inputs.add((type, filename));
  }

  /// Reads all XUnit files given via the addInput() method and creates
  /// a pdf report document. The document is written to the given
  /// [filename] on disk.
  ///
  /// You can provide a page format for the report via [format].
  void convertXunitToPdf(String filename,
      [PdfPageFormat format = PdfPageFormat.a4,
      SystemInteractions system = const SystemInteractions()]) async {
    final report = Report(title, version, timestamp);
    for (final (type, path) in inputs) {
      final document = system.readFile(path);
      final parsed = parseXUnit(type, path, document);
      report.reports.add(parsed);
    }
    final pdfContents = await generateReport(report, format);
    system.writeFileAsBytes(filename, pdfContents);
  }
}
