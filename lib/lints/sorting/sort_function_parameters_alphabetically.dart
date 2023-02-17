import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:formigas_flutter_lints/lints/sorting/common.dart';

class SortFunctionParametersAlphabetically extends DartLintRule {
  SortFunctionParametersAlphabetically() : super(code: _code);

  static const _code = LintCode(
    name: 'sort_function_parameters_alphabetically',
    problemMessage: 'Sort function parameters alphabetically.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addFunctionDeclaration((node) {
      checkAlphabeticallySorted(code, node.declaredElement, reporter);
    });
  }

  @override
  List<Fix> getFixes() => [
        SortMethodOrFunctionParametersAlphabeticallyFix(),
      ];
}
