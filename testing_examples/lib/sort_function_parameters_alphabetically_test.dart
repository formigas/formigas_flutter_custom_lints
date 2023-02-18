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

// expect_lint: sort_function_declaration_parameters_alphabetically
void function4Unsorted({
  required int c,
  required double b,
  required String a,
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

  // expect_lint: sort_function_declaration_parameters_alphabetically
  void function4Unsorted({
    required int c,
    required double b,
    required String a,
  }) {}
}

void invokeAllFunctions() {
  function1(1, 'test', 3.14);
  function1Unsorted(3.14, 'test', 1);
  function2(1, 'test', c: 3.14);
  function2unsorted(3.14, 'test', a: 1);
  function3(1, b: 'test', c: 3.14);
  // expect_lint: sort_function_invocation_parameters_alphabetically
  function3(1, c: 3.14, b: 'test');
  // expect_lint: sort_function_invocation_parameters_alphabetically
  function3Unsorted(3.14, 2.72, b: 'test', a: 1);
  function3Unsorted2(2.72, 3.14, a: 'test', b: 1);
  // expect_lint: sort_function_invocation_parameters_alphabetically
  function3Unsorted3(3.14, 2.72, b: 1, a: 'test');
  function4Unsorted(a: 'test', b: 3.14, c: 1);
  // expect_lint: sort_function_invocation_parameters_alphabetically
  function4Unsorted(b: 3.14, c: 1, a: 'test');
  var a = A();
  a.function1(1, 'test', 3.14);
  a.function1Unsorted(3.14, 'test', 1);
  a.function2(1, 'test', c: 3.14);
  a.function2unsorted(3.14, 'test', a: 1);
  // expect_lint: sort_function_invocation_parameters_alphabetically
  a.function3(1, c: 3.14, b: 'test');
  // expect_lint: sort_function_invocation_parameters_alphabetically
  a.function3Unsorted(3.14, 2.72, b: 'test', a: 1);
  a.function3Unsorted2(2.72, 3.14, a: 'test', b: 1);
  // expect_lint: sort_function_invocation_parameters_alphabetically
  a.function3Unsorted3(3.14, 2.72, b: 1, a: 'test');
  a.function4Unsorted(a: 'test', b: 3.14, c: 1);
  // expect_lint: sort_function_invocation_parameters_alphabetically
  a.function4Unsorted(b: 3.14, c: 1, a: 'test');
}
