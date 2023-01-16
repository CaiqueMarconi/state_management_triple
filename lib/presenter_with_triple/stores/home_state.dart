class HomeState {
  final int counter;
  HomeState({required this.counter});

  factory HomeState.init() => HomeState(
        counter: 0,
      );

  HomeState copyWith({
    int? counter,
  }) {
    return HomeState(
      counter: counter ?? this.counter,
    );
  }
}
