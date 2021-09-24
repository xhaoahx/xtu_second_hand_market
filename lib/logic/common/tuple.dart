

class Tuple<T>{
  const Tuple(this.value);

  final T value;
  @override
  bool operator ==(other) => identical(this,other);

  @override
  int get hashCode => identityHashCode(this);
}


class Tuple2<A,B>{
  const Tuple2(this.valueA,this.valueB);

  final A valueA;
  final B valueB;
}
