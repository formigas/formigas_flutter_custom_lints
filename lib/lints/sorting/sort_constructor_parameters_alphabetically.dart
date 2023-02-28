import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:formigas_flutter_lints/lints/sorting/common.dart';

class SortConstructorDeclarationParametersAlphabetically extends DartLintRule {
  const SortConstructorDeclarationParametersAlphabetically()
      : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'sort_constructor_parameters_alphabetically',
    problemMessage: 'Sort constructor parameters alphabetically.',
  );

  @override
  void run(
    final CustomLintResolver resolver,
    final ErrorReporter reporter,
    final CustomLintContext context,
  ) {
    context.registry
        .addConstructorDeclaration((final ConstructorDeclaration node) {
      checkAlphabeticallySortedConstructor(
        _code,
        node.declaredElement,
        reporter,
      );
    });
  }

  @override
  List<Fix> getFixes() => <Fix>[
        SortConstructorParameterListAlphabeticallyFix(),
      ];
}

class SortConstructorParameterListAlphabeticallyFix extends DartFix {
  @override
  void run(
    final CustomLintResolver resolver,
    final ChangeReporter reporter,
    final CustomLintContext context,
    final AnalysisError analysisError,
    final List<AnalysisError> others,
  ) {
    context.registry
        .addConstructorDeclaration((final ConstructorDeclaration node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) {
        return;
      }

      final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
        message: 'Sort parameters alphabetically',
        priority: 1,
      );
      final FormalParameterList parameterList = node.parameters;

      changeBuilder.addDartFileEdit((final DartFileEditBuilder builder) {
        fixParameterSorting(
          changeBuilder: changeBuilder,
          parameterList: parameterList,
        );
      });
    });
  }
}
