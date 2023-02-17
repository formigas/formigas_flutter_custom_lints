import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:collection/collection.dart';

PluginBase createPlugin() => FormigasLint();

class FormigasLint extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        SortMethodParametersAlphabetically(),
        SortFunctionParametersAlphabetically(),
      ];

  @override
  List<Assist> getAssists() => [];
}

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
      _checkAlphabeticallySorted(code, node.declaredElement, reporter);
    });
  }

  @override
  List<Fix> getFixes() => [SortMethodOrFunctionParametersAlphabeticallyFix()];
}

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
      _checkAlphabeticallySorted(code, node.declaredElement, reporter);
    });
  }

  @override
  List<Fix> getFixes() => [SortMethodOrFunctionParametersAlphabeticallyFix()];
}

void _checkAlphabeticallySorted(
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

class SortMethodOrFunctionParametersAlphabeticallyFix extends DartFix {
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

      changeBuilder.addDartFileEdit((builder) {
        final FormalParameterList? parameterList = node.parameters;

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
