import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:formigas_flutter_lints/lints/sorting/sort_constructor_parameters_alphabetically.dart';
import 'package:formigas_flutter_lints/lints/sorting/sort_function_parameters_alphabetically.dart';

PluginBase createPlugin() => FormigasLint();

class FormigasLint extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        SortConstructorDeclarationParametersAlphabetically(),
        SortFunctionDeclarationParametersAlphabetically(),
        SortFunctionInvocationParametersAlphabetically(),
      ];

  @override
  List<Assist> getAssists() => [];
}
