import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:collection/collection.dart';

void checkAlphabeticallySorted(
  ErrorCode code,
  ExecutableElement? element,
  ErrorReporter reporter,
) {
  List<ParameterElement>? parameters = element?.parameters;
  List<ParameterElement>? sortedParameters = parameters?.sortedByCompare(
      (element) => element.name, (a, b) => a.compareTo(b));

  if (element != null &&
      parameters != null &&
      sortedParameters != null &&
      !IterableEquality().equals(parameters, sortedParameters)) {
    reporter.reportErrorForElement(code, element);
  }
}
