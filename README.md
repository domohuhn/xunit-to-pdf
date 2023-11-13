# Create pdf reports from collections of xunit files

[![Dart](https://github.com/domohuhn/xunit-to-pdf/actions/workflows/dart.yml/badge.svg)](https://github.com/domohuhn/xunit-to-pdf/actions/workflows/dart.yml)


![Example for a pdf report](https://raw.githubusercontent.com/domohuhn/xunit-to-pdf/main/example/output.png "Example for a pdf report")

This package contains a library that can parse junit xml documents and creates a pdf report.

## Quick start

You can convert a set of xunit xml documents to a pdf via:


    dart run .\bin\xunit_to_pdf.dart -u .\example\data\example1.xml -i .\example\data\example2.xml -q .\example\data\example3.xml -t "Title of report" -v "1.0.0" -o output.pdf

To see all available options, run

    dart run .\bin\xunit_to_pdf.dart -h

You can also integrate the library into your application to generate the pdf reports:

```dart
import 'package:xunit_to_pdf/xunit_to_pdf.dart';

final converter =
    ConversionContext(title: "Title of report", version: "1.0.0");
converter.addInput(TestTypes.unit, "filename.xml");
converter.convertXunitToPdf("report.pdf");
```

## Output examples

The [examples folder](https://github.com/domohuhn/xunit-to-pdf/tree/main/example) contains input data and potential outputs.

## License
All Code is licensed with the BSD-3-Clause license, see file "LICENSE"

## Issue tracker
You can request features or report bugs using the [issue tracker](https://github.com/domohuhn/xunit-to-pdf/issues) on github.

