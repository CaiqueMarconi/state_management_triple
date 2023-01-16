import 'package:flutter_triple/flutter_triple.dart';
import 'package:state_management_triple/presenter_with_triple/stores/home_state.dart';

class HomeStore extends StreamStore<Exception, HomeState> {
  HomeStore() : super(HomeState.init());

  // metodo sem setLoading
  // void incrementCounter() {
  //   final value = state.counter + 1;
  //   update(state.copyWith(counter: value));
  // }

  //metodo com setLoading
  Future<void> incrementCounter() async {
    setLoading(true);
    await Future.delayed(
      const Duration(seconds: 1),
    );
    final value = state.counter + 1;
    update(state.copyWith(counter: value));
    setLoading(false);
  }
}
