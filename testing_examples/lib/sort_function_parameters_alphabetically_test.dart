// expect_lint: sort_function_parameters_alphabetically
void unsortedFunctionParameters({
  required int c,
  required int b,
  required int a,
}) {}

void unsortedFunctionParameters2(
  int c,
  double d, {
  required int a,
  required int b,
}) {}

// expect_lint: sort_function_parameters_alphabetically
void unsortedFunctionParameters3(
  int c,
  double d, {
  required int b,
  required int a,
}) {}

// expect_lint: sort_function_parameters_alphabetically
void unsortedFunctionParameters4(
  int d,
  double c, {
  required int a,
  required int b,
}) {}

// expect_lint: sort_function_parameters_alphabetically
void unsortedFunctionParameters4(
  double d,
  int c, {
  required int b,
  required int a,
}) {}

void test() {
// expect_lint: sort_method_arguments_alphabetically
  unsortedFunctionParameters(c: 1, b: 1, a: 1);
}
