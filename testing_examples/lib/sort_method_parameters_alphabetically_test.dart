class A {
  // expect_lint: sort_method_parameters_alphabetically
  void unsortedMethodParameters1({
    required int c,
    required int b,
    required int a,
  }) {}

  void unsortedMethodParameters2({
    required int a,
  }) {}

  void unsortedMethodParameters3({
    required int a,
    required int b,
  }) {}

  void invocationCalls() {
    // expect_lint: sort_method_arguments_alphabetically
    unsortedMethodParameters1(b: 1, c: 2, a: 3);
    unsortedMethodParameters2(a: 1);
    // expect_lint: sort_method_arguments_alphabetically
    unsortedMethodParameters3(
      b: 1,
      a: 2,
    );
  }
}
