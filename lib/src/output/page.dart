// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:xunit_to_pdf/src/core/report.dart';

pw.Page createPage(Report data, pw.ThemeData theme, PdfPageFormat pageFormat,
    List<pw.Widget> elements) {
  return pw.MultiPage(
      pageFormat: pageFormat,
      theme: theme,
      footer: (pw.Context context) {
        final style = pw.Theme.of(context)
            .defaultTextStyle
            .copyWith(color: PdfColors.grey);
        return pw.Container(
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Row(children: [
              pw.Text('${data.title} / ${data.version} / ${data.timestamp}',
                  style: style),
              pw.Spacer(),
              pw.Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: style)
            ]));
      },
      build: (context) {
        return elements;
      });
}
