import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:formigas_flutter_lints/lints/sorting/common.dart';

class SortFunctionDeclarationParametersAlphabetically extends DartLintRule {
  SortFunctionDeclarationParametersAlphabetically() : super(code: _code);

  static const _code = LintCode(
    name: 'sort_function_declaration_parameters_alphabetically',
    problemMessage: 'Sort parameters alphabetically.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodDeclaration((node) {
      checkAlphabeticallySorted(code, node.declaredElement, reporter);
    });

    context.registry.addFunctionDeclaration((node) {
      checkAlphabeticallySorted(code, node.declaredElement, reporter);
    });
  }

  @override
  List<Fix> getFixes() => [
        SortFunctionDeclarationParametersAlphabeticallyFix(),
      ];
}

class SortFunctionInvocationParametersAlphabetically extends DartLintRule {
  SortFunctionInvocationParametersAlphabetically() : super(code: _code);

  static const _code = LintCode(
    name: 'sort_function_invocation_parameters_alphabetically',
    problemMessage: 'Sort parameters alphabetically.',
  );

  @override
  void run(
      CustomLintResolver resolver,
      ErrorReporter reporter,
      CustomLintContext context,
      ) {

    context.registry.addMethodInvocation((node) {
      List<String> namedParams = node.argumentList.arguments
          .whereType<NamedExpression>()
          .map((n) => n.name.label.name)
          .toList();

      final sortedParams = List<String>.from(namedParams)..sort();

      if (!ListEquality().equals(namedParams, sortedParams)) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }

  @override
  List<Fix> getFixes() => [
    SortFunctionInvocationParametersAlphabeticallyFix(),
  ];
}

class SortFunctionDeclarationParametersAlphabeticallyFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addFunctionDeclaration((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Sort parameters alphabetically',
        priority: 1,
      );
      FormalParameterList? parameterList = node.functionExpression.parameters;

      fixParameterSorting(
        changeBuilder: changeBuilder,
        parameterList: parameterList,
      );
    });

    context.registry.addMethodDeclaration((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Sort parameters alphabetically',
        priority: 1,
      );
      FormalParameterList? parameterList = node.parameters;

      fixParameterSorting(
        changeBuilder: changeBuilder,
        parameterList: parameterList,
      );
    });

  }
}

class SortFunctionInvocationParametersAlphabeticallyFix extends DartFix {
  @override
  void run(
      CustomLintResolver resolver,
      ChangeReporter reporter,
      CustomLintContext context,
      AnalysisError analysisError,
      List<AnalysisError> others,
      ) {

    context.registry.addMethodInvocation((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Sort parameters alphabetically',
        priority: 1,
      );

      changeBuilder.addDartFileEdit((builder) {
        ArgumentList argumentList = node.argumentList;

        argumentList.arguments.sort((first, second) {
          if ((first.staticParameterElement?.isPositional ?? false) &&
              (second.staticParameterElement?.isPositional ?? false)) {
            return first.staticParameterElement?.name.toString().compareTo(
                second.staticParameterElement?.name.toString() ?? '') ??
                0;
          } else if ((second.staticParameterElement?.isNamed ?? false) &&
              (second.staticParameterElement?.isNamed ?? false)) {
            return first.staticParameterElement?.name.toString().compareTo(
                second.staticParameterElement?.name.toString() ?? '') ??
                0;
          } else if ((second.staticParameterElement?.isPositional ?? false)) {
            return -1;
          } else {
            return 1;
          }
        });
        builder.addSimpleReplacement(
          SourceRange(argumentList.offset, argumentList.length),
          argumentList.toSource(),
        );
      });
    });
  }
}
