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
}