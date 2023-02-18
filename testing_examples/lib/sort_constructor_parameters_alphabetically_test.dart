class A {
  final int a;
  final int b;
  final int c;

  // expect_lint: sort_constructor_parameters_alphabetically
  A(
    this.c,
    this.b,
    this.a,
  );

  // ignore: unused_element
  // expect_lint: sort_constructor_parameters_alphabetically
  const A.second({
    required this.c,
    required this.b,
    required this.a,
  });

  const A.third({
    required this.a,
    required this.b,
    required this.c,
  });

  const A.fourth(
    this.b, {
    required this.a,
    required this.c,
  });

  // expect_lint: sort_constructor_parameters_alphabetically
  const A.fifth(
    this.c, {
    required this.b,
    required this.a,
  });
}
