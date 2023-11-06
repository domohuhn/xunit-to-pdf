// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:xunit_to_pdf/src/core/test_case.dart';
import 'package:xunit_to_pdf/src/output/colors.dart';

class BulletPointAndTextBlock extends pw.StatelessWidget {
  BulletPointAndTextBlock(
      {required this.text, required this.color, this.block});

  final String text;
  final PdfColor color;
  final OptionalInformation? block;

  @override
  pw.Widget build(pw.Context context) {
    final children = <pw.Widget>[
      pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: _createBulletPointAndText(context, text, color, 450))
    ];
    if (block != null) {
      final innerChildren = <pw.Widget>[
        pw.Text('Type: "${block!.type}"', softWrap: true),
        pw.Text('Message: "${block!.message}"', softWrap: true),
      ];
      if (block!.text != null) {
        innerChildren.add(pw.Text(block!.text!, softWrap: true));
      }
      children.add(pw.Container(
        decoration: pw.BoxDecoration(
            border: pw.Border(left: pw.BorderSide(color: color, width: 2))),
        padding: const pw.EdgeInsets.only(left: 10, top: 5, bottom: 5),
        margin: const pw.EdgeInsets.only(left: 5),
        width: 440,
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: innerChildren),
      ));
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: children,
    );
  }
}

class BulletPointTextAndFraction extends pw.StatelessWidget {
  BulletPointTextAndFraction({
    required this.text,
    required this.passed,
    required this.total,
  });

  final String text;
  final int passed;
  final int total;

  @override
  pw.Widget build(pw.Context context) {
    final contents = _createBulletPointAndText(context, text, baseColor, 320);
    contents.add(pw.Spacer());
    contents.add(pw.Text("passed: $passed / $total"));
    return pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start, children: contents);
  }
}

List<pw.Widget> _createBulletPointAndText(
    pw.Context context, String text, PdfColor color, int width) {
  return <pw.Widget>[
    pw.Container(
      width: 6,
      height: 6,
      margin: const pw.EdgeInsets.only(top: 5.5, left: 2, right: 5),
      decoration: pw.BoxDecoration(
        color: color,
        shape: pw.BoxShape.circle,
      ),
    ),
    pw.Container(width: width.toDouble(), child: pw.Text(text, softWrap: true))
  ];
}

class BulletPoint extends pw.StatelessWidget {
  BulletPoint({required this.text, required this.color});

  final String text;
  final PdfColor color;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: _createBulletPointAndText(context, text, color, 450));
  }
}

class Heading extends pw.StatelessWidget {
  Heading({required this.title});

  final String title;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        color: baseColor,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      margin: const pw.EdgeInsets.only(bottom: 10, top: 10),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Text(
        title,
        textScaleFactor: 1.5,
      ),
    );
  }
}
