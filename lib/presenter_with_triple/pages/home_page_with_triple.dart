import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:state_management_triple/presenter_with_triple/stores/home_store.dart';

class HomePageWithTriple extends StatelessWidget {
  HomePageWithTriple({super.key});

  final controller = HomeStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('home page com triple'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            ScopedBuilder(
              store: controller,
              onLoading: (context) =>
                  const CircularProgressIndicator(), // widget q sera carregado enquanto o setLoading do metodo for true
              onState: ((context, state) {
                return Text(
                  '${controller.state.counter}',
                  style: Theme.of(context).textTheme.headline4,
                );
              }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.incrementCounter(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
