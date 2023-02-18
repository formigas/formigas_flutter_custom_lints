void function1(
  int a,
  String b,
  double c,
) {}

// expect_lint: sort_function_declaration_parameters_alphabetically
void function1Unsorted(
  double c,
  String b,
  int a,
) {}

void function2(
  int a,
  String b, {
  required double c,
}) {}

// expect_lint: sort_function_declaration_parameters_alphabetically
void function2unsorted(
  double c,
  String b, {
  required int a,
}) {}

void function3(
  int a, {
  required String b,
  required double c,
}) {}

// expect_lint: sort_function_declaration_parameters_alphabetically
void function3Unsorted(
  double c,
  double d, {
  required String b,
  required int a,
}) {}

// expect_lint: sort_function_declaration_parameters_alphabetically
void function3Unsorted2(
  double d,
  double c, {
  required String a,
  required int b,
}) {}

void function3Unsorted3(
  double c,
  double d, {
  required String a,
  required int b,
}) {}

class A {
  void function1(
    int a,
    String b,
    double c,
  ) {}

  // expect_lint: sort_function_declaration_parameters_alphabetically
  void function1Unsorted(
    double c,
    String b,
    int a,
  ) {}

  void function2(
    int a,
    String b, {
    required double c,
  }) {}

  // expect_lint: sort_function_declaration_parameters_alphabetically
  void function2unsorted(
    double c,
    String b, {
    required int a,
  }) {}

  void function3(
    int a, {
    required String b,
    required double c,
  }) {}

  // expect_lint: sort_function_declaration_parameters_alphabetically
  void function3Unsorted(
    double c,
    double d, {
    required String b,
    required int a,
  }) {}

  // expect_lint: sort_function_declaration_parameters_alphabetically
  void function3Unsorted2(
    double d,
    double c, {
    required String a,
    required int b,
  }) {}

  void function3Unsorted3(
    double c,
    double d, {
    required String a,
    required int b,
  }) {}
}
