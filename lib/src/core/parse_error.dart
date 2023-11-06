// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

/// A simple exception for any error.
class ParseError implements Exception {
  /// cause of the error
  String cause;
  ParseError(this.cause);

  @override
  String toString() {
    return 'Error: $cause';
  }
}
