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

class AWithId {
  final int a;
  final int b;
  final int id;

  // expect_lint: sort_constructor_parameters_alphabetically
  AWithId(
    this.id,
    this.b,
    this.a,
  );

  // ignore: unused_element
  // expect_lint: sort_constructor_parameters_alphabetically
  const AWithId.second({
    required this.id,
    required this.b,
    required this.a,
  });

  const AWithId.third({
    required this.id,
    required this.a,
    required this.b,
  });

  const AWithId.fourth(
    this.b, {
    required this.id,
    required this.a,
  });

  // expect_lint: sort_constructor_parameters_alphabetically
  const AWithId.fifth(
    this.id, {
    required this.b,
    required this.a,
  });
}

class B {
  final int id;
  final int anotherOne;
  final int thisHere;

  // expect_lint: sort_constructor_parameters_alphabetically
  const B({
    required this.thisHere,
    required this.id,
    required this.anotherOne,
  });

  const B.first({
    required this.id,
    required this.anotherOne,
    required this.thisHere,
  });

  // expect_lint: sort_constructor_parameters_alphabetically
  const B.second({
    required this.anotherOne,
    required this.id,
    required this.thisHere,
  });
}

class C {
  final int key;
  final int anotherSuperParam;

  C(
    this.anotherSuperParam,
    this.key,
  );
}

class D extends C {
  final int a;
  D(
    super.anotherSuperParam,
    super.key,
    this.a,
  );

  D.second(
    this.a,
    super.anotherSuperParam,
    super.key,
  );
}

class E {
  final int somethingId;
  final int another;
  final int what;

  E(
    this.somethingId,
    this.another,
    this.what,
  );

  E.required({
    required this.somethingId,
    required this.another,
    required this.what,
  });
}
