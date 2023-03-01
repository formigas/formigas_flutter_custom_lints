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

void checkAlphabeticallySortedConstructor(
  final ErrorCode code,
  final ExecutableElement? element,
  final ErrorReporter reporter,
) {
  final List<ParameterElement>? namedParameters = element?.parameters
      .where(
        (final ParameterElement element) =>
            element.isNamed && !element.isSuperFormal,
      )
      .toList();
  final List<ParameterElement>? superParameters = element?.parameters
      .where((final ParameterElement element) => element.isSuperFormal)
      .toList();
  final List<ParameterElement>? positionalParameters = element?.parameters
      .where(
        (final ParameterElement element) =>
            element.isPositional && !element.isSuperFormal,
      )
      .toList();

  final List<ParameterElement>? sortedNamedParameters =
      namedParameters?.sortedByCompare(
    (final ParameterElement element) => element.name,
    (final String a, final String b) {
      if (a == 'id') {
        return -1;
      } else if (b == 'id') {
        return 1;
      } else if (a.endsWith('Id')) {
        return -1;
      } else if (b.endsWith('Id')) {
        return 1;
      } else {
        return a.compareTo(b);
      }
    },
  );
  final List<ParameterElement>? sortedSuperParameters =
      superParameters?.sortedByCompare(
    (final ParameterElement element) => element.name,
    (final String a, final String b) => a.compareTo(b),
  );
  final List<ParameterElement>? sortedPositionalParameters =
      positionalParameters
          ?.sortedByCompare((final ParameterElement element) => element.name,
              (final String a, final String b) {
    if (a == 'id') {
      return -1;
    } else if (b == 'id') {
      return 1;
    } else if (a.endsWith('Id')) {
      return -1;
    } else if (b.endsWith('Id')) {
      return 1;
    } else {
      return a.compareTo(b);
    }
  });

  if (element != null &&
      namedParameters != null &&
      sortedSuperParameters != null &&
      sortedNamedParameters != null &&
      (!const IterableEquality<ParameterElement>().equals(
            namedParameters,
            sortedNamedParameters,
          ) ||
          !const IterableEquality<ParameterElement>().equals(
            positionalParameters,
            sortedPositionalParameters,
          ) ||
          !const IterableEquality<ParameterElement>().equals(
            superParameters,
            sortedSuperParameters,
          ))) {
    reporter.reportErrorForElement(code, element);
  }
}

void checkAlphabeticallySortedArguments(
  final ErrorCode code,
  final ArgumentList? arguments,
  final ErrorReporter reporter,
) {
  final List<Expression>? sortedParameters =
      arguments?.arguments.sortedByCompare(
    (final Expression element) => element.staticParameterElement?.name,
    (final String? a, final String? b) => b == null ? 0 : a?.compareTo(b) ?? 0,
  );

  if (arguments != null &&
      sortedParameters != null &&
      !const IterableEquality<Expression>()
          .equals(arguments.arguments, sortedParameters)) {
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
        final String firstName = first.name.toString();
        final String secondName = second.name.toString();

        final bool firstIsId = firstName.endsWith('Id') || firstName == 'id';
        final bool secondIsId = secondName.endsWith('Id') || secondName == 'id';

        if (firstIsId) {
          return -1;
        } else if (secondIsId) {
          return 1;
        } else if (first.isPositional && second.isPositional) {
          return firstName.compareTo(secondName);
        } else if (first.isNamed && second.isNamed) {
          return firstName.compareTo(secondName);
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
