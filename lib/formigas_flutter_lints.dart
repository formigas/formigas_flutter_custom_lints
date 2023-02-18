import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:formigas_flutter_lints/lints/sorting/sort_constructor_parameters_alphabetically.dart';

import 'lints/sorting/sort_function_declaration_parameters_alphabetically.dart';

PluginBase createPlugin() => FormigasLint();

class FormigasLint extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        // SortMethodInvocationArgumentsAlphabetically(),
        SortConstructorDeclarationParametersAlphabetically(),
        SortFunctionDeclarationParametersAlphabetically(),
        // SortFunctionInvocationArgumentsAlphabetically(),
      ];

  @override
  List<Assist> getAssists() => [];
}
