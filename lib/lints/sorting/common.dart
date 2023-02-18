import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

void checkAlphabeticallySorted(
  final ErrorCode code,
  final ExecutableElement? element,
  final ErrorReporter reporter,
) {
  final List<ParameterElement>? namedParameters = element?.parameters
      .where((final ParameterElement element) => element.isNamed)
      .toList();
  final List<ParameterElement>? positionalParameters = element?.parameters
      .where((final ParameterElement element) => element.isPositional)
      .toList();
  final List<ParameterElement>? sortedNamedParameters =
      namedParameters?.sortedByCompare(
    (final ParameterElement element) => element.name,
    (final String a, final String b) => a.compareTo(b),
  );

  final List<ParameterElement>? sortedPositionalParameters =
      positionalParameters?.sortedByCompare(
    (final ParameterElement element) => element.name,
    (final String a, final String b) => a.compareTo(b),
  );

  if (element != null &&
      namedParameters != null &&
      sortedNamedParameters != null &&
      (!const IterableEquality<ParameterElement>().equals(
            namedParameters,
            sortedNamedParameters,
          ) ||
          !const IterableEquality<ParameterElement>().equals(
            positionalParameters,
            sortedPositionalParameters,
          ))) {
    reporter.reportErrorForElement(code, element);
  }
}

void checkAlphabeticallySortedArguments(
  final ErrorCode code,
  final ArgumentList? arguments,
  final ErrorReporter reporter,
) {
  final List<Expression>? sortedParameters = arguments?.arguments.sortedByCompare(
    (final Expression element) => element.staticParameterElement?.name,
    (final String? a, final String? b) => b == null ? 0 : a?.compareTo(b) ?? 0,
  );

  if (arguments != null &&
      sortedParameters != null &&
      !const IterableEquality<Expression>().equals(arguments.arguments, sortedParameters)) {
    reporter.reportErrorForOffset(code, sortedParameters.first.offset, 1);
  }
}

void fixParameterSorting({
  required final ChangeBuilder changeBuilder,
  required final FormalParameterList? parameterList,
}) {
  changeBuilder.addDartFileEdit((final DartFileEditBuilder builder) {
    if (parameterList != null) {
      parameterList.parameters
          .sort((final FormalParameter first, final FormalParameter second) {
        if (first.isPositional && second.isPositional) {
          return first.name.toString().compareTo(second.name.toString());
        } else if (first.isNamed && second.isNamed) {
          return first.name.toString().compareTo(second.name.toString());
        } else if (first.isPositional) {
          return -1;
        } else {
          return 1;
        }
      });
      builder.addSimpleReplacement(
        SourceRange(parameterList.offset, parameterList.length),
        parameterList.toSource(),
      );
    }
  });
}
