class Pair<T1, T2> {
  final T1 left;
  final T2 right;

  const Pair(this.left, this.right);

  @override
  String toString() => 'Pair[$left, $right]';
}
