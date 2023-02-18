import 'package:analyzer/dart/ast/ast.dart';
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
        SortFunctionParametersAlphabeticallyFix(),
      ];
}

class SortFunctionParametersAlphabeticallyFix extends DartFix {
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
