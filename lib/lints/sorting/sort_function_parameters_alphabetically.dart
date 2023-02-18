import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:formigas_flutter_lints/lints/sorting/common.dart';

class SortFunctionDeclarationParametersAlphabetically extends DartLintRule {
  const SortFunctionDeclarationParametersAlphabetically() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'sort_function_declaration_parameters_alphabetically',
    problemMessage: 'Sort parameters alphabetically.',
  );

  @override
  void run(
    final CustomLintResolver resolver,
    final ErrorReporter reporter,
    final CustomLintContext context,
  ) {
    context.registry.addMethodDeclaration((final MethodDeclaration node) {
      checkAlphabeticallySorted(code, node.declaredElement, reporter);
    });

    context.registry.addFunctionDeclaration((final FunctionDeclaration node) {
      checkAlphabeticallySorted(code, node.declaredElement, reporter);
    });
  }

  @override
  List<Fix> getFixes() => <Fix>[
        SortFunctionDeclarationParametersAlphabeticallyFix(),
      ];
}

class SortFunctionInvocationParametersAlphabetically extends DartLintRule {
  const SortFunctionInvocationParametersAlphabetically() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'sort_function_invocation_parameters_alphabetically',
    problemMessage: 'Sort parameters alphabetically.',
  );

  @override
  void run(
    final CustomLintResolver resolver,
    final ErrorReporter reporter,
    final CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((final MethodInvocation node) {
      final List<String> namedParams = node.argumentList.arguments
          .whereType<NamedExpression>()
          .map((final NamedExpression n) => n.name.label.name)
          .toList();

      final List<String> sortedParams = List<String>.from(namedParams)..sort();

      if (!const ListEquality<String>().equals(namedParams, sortedParams)) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }

  @override
  List<Fix> getFixes() => <Fix>[
        SortFunctionInvocationParametersAlphabeticallyFix(),
      ];
}

class SortFunctionDeclarationParametersAlphabeticallyFix extends DartFix {
  @override
  void run(
    final CustomLintResolver resolver,
    final ChangeReporter reporter,
    final CustomLintContext context,
    final AnalysisError analysisError,
    final List<AnalysisError> others,
  ) {
    context.registry.addFunctionDeclaration((final FunctionDeclaration node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) {
        return;
      }

      final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
        message: 'Sort parameters alphabetically',
        priority: 1,
      );
      final FormalParameterList? parameterList =
          node.functionExpression.parameters;

      fixParameterSorting(
        changeBuilder: changeBuilder,
        parameterList: parameterList,
      );
    });

    context.registry.addMethodDeclaration((final MethodDeclaration node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) {
        return;
      }

      final ChangeBuilder changeBuilder = reporter.createChangeBuilder(
        message: 'Sort parameters alphabetically',
        priority: 1,
      );
      final FormalParameterList? parameterList = node.parameters;

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
    final CustomLintResolver resolver,
    final ChangeReporter reporter,
    final CustomLintContext context,
    final AnalysisError analysisError,
    final List<AnalysisError> others,
  ) {
    context.registry.addMethodInvocation((final MethodInvocation node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) {
        return;
      }

      reporter
          .createChangeBuilder(
        message: 'Sort parameters alphabetically',
        priority: 1,
      )
          .addDartFileEdit((final DartFileEditBuilder builder) {
        final ArgumentList argumentList = node.argumentList;

        argumentList.arguments
            .sort((final Expression first, final Expression second) {
          if ((first.staticParameterElement?.isPositional ?? false) &&
              (second.staticParameterElement?.isPositional ?? false)) {
            return first.staticParameterElement?.name.compareTo(
                      second.staticParameterElement?.name ?? '',
                    ) ??
                0;
          } else if ((second.staticParameterElement?.isNamed ?? false) &&
              (second.staticParameterElement?.isNamed ?? false)) {
            return first.staticParameterElement?.name.compareTo(
                      second.staticParameterElement?.name ?? '',
                    ) ??
                0;
          } else if (second.staticParameterElement?.isPositional ?? false) {
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
