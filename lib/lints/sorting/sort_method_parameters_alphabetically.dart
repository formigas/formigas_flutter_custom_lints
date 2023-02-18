import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:formigas_flutter_lints/lints/sorting/common.dart';

class SortMethodParametersAlphabetically extends DartLintRule {
  SortMethodParametersAlphabetically() : super(code: _code);

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
        SortMethodParameterListAlphabeticallyFix(),
      ];
}

class SortMethodParameterListAlphabeticallyFix extends DartFix {
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
