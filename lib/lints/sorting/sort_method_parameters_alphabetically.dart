import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:formigas_flutter_lints/lints/sorting/common.dart';

class SortMethodDeclarationParametersAlphabetically extends DartLintRule {
  SortMethodDeclarationParametersAlphabetically() : super(code: _code);

  static const _code = LintCode(
    name: 'sort_method_parameters_alphabetically',
    problemMessage: 'Sort method parameters alphabetically.',
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
  }

  @override
  List<Fix> getFixes() => [
        SortMethodDeclarationParametersAlphabeticallyFix(),
      ];
}

class SortMethodInvocationArgumentsAlphabetically extends DartLintRule {
  SortMethodInvocationArgumentsAlphabetically() : super(code: _code);

  static const _code = LintCode(
    name: 'sort_method_arguments_alphabetically',
    problemMessage: 'Sort method arguments alphabetically.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      ArgumentList arguments = node.argumentList;
      List<Expression> sortedParameters = arguments.arguments.sortedByCompare(
          (Expression element) => element.staticParameterElement?.name,
          (String? a, String? b) => b == null ? 0 : a?.compareTo(b) ?? 0);

      if (!IterableEquality()
          .equals(arguments.arguments.toList(), sortedParameters)) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }

  @override
  List<Fix> getFixes() => [
    SortMethodInvocationArgumentsAlphabeticallyFix(),
      ];
}

class SortMethodDeclarationParametersAlphabeticallyFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addMethodDeclaration((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Sort parameters alphabetically',
        priority: 1,
      );
      FormalParameterList? parameterList = node.parameters;

      changeBuilder.addDartFileEdit((builder) {
        if (parameterList != null) {
          parameterList.parameters.sort(
              (FormalParameter first, FormalParameter second) =>
                  first.name.toString().compareTo(second.name.toString()));
          builder.addSimpleReplacement(
            SourceRange(parameterList.offset, parameterList.length),
            parameterList.toSource(),
          );
        }
      });
    });
  }
}

class SortMethodInvocationArgumentsAlphabeticallyFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addMethodInvocation((MethodInvocation node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Sort arguments alphabetically',
        priority: 1,
      );
      ArgumentList argumentList = node.argumentList;
      var offset = argumentList.offset;
      var length = argumentList.length;

      changeBuilder.addDartFileEdit((builder) {
        argumentList.arguments.sort((Expression first, Expression second) {
          return first.staticParameterElement?.name
                  .compareTo(second.staticParameterElement?.name ?? '') ??
              0;
        });
        builder.addSimpleReplacement(
          SourceRange(offset, length),
          argumentList.toSource(),
        );
      });
    });
  }
}
