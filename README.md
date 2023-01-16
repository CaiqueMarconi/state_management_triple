# state_management_triple

# Controle de estado no Flutter com Triple.

# Oque é gerenciamento de estado

Gerenciamento de estado, ou State Management, se resume a obtenção de  dados para transformar  o estado da sua aplicação. Vou explicar melhor.

O Flutter vai 'desenhar' a tela e vai tentar fazer isso apenas uma vez para economizar processamento. Para desenhar uma tela de listagem, por exemplo, você irá precisar de informações vindas de algum lugar, seja por api, firebase, entre outros, porém essas informações podem não ser estáticas. Se essas informações mudarem, o Flutter precisa ser notificado que houve uma mudança para poder redesenhar essa parte da tela.

O foco do gerenciamento de estado é como notificar o Flutter sobre o que ele precisa redesenhar e como fazer isso de forma performática, custando pouco processamento.

Nativamente o Flutter já possui um 'notificador' chamado Set State, mas às vezes ele pode não ser a melhor opção.

# controle de estado com o setState

com o setState podemos notificar o flutter quando queremos que ele redesenhe a tela, para que o setState funcione,
precisamos que nossa page extenda de StatefulWidget, o StatefulWidget que nos permite a utilização do setState
para utilizar o setState precisamos apenas estar dentro do escopo de algum metodo como no exemplo abaixo.

 void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

// neste metodo que incrementa uma variavel o setState engloba toda a regra de negocio e assim sempre que este metodo
é chamado o setState notifica o flutter para redesenhar a tela e assim o valor mostrado na tela é alterado.

# controle de estado com triple

# O que é Triple

Triple é um apelido para SSP (Padrão de Estado Segmentado). Alguns pacotes foram criados para facilitar o início do uso do padrão pelos desenvolvedores. Vamos chamá-lo de extensão.

O SSP segmenta o estado em 3 partes reativas, o valor do estado (estado), o objeto de erro (erro) e a ação de carregamento do estado (carregamento).

Esses segmentos são observados em um ouvinte ou ouvintes separados. Também podem ser combinados para obter um novo segmento, partindo sempre dos 3 segmentos principais.

# Sobre a forma como ele realiza a reatividade

O pacote flutter_triple implementa o SSP usando duas reatividades: Streams e ValueNotifier/RxNotifier, onde temos o StreamNotifier(para Streams) e NotifierStore(para ValueNotifier).

# Diferenças do stream e do Notifier Store

Os fluxos funcionam sem valor distinto, portanto, você pode despachar o mesmo estado quantas vezes quiser. No StreamStore você pode forçar uma atualização, setLoading ou setError;
ValueNotifier é a mesma implementação ChangeNotifier (classe Escutável). O pacote flutter_triple também usa RxNotifier (pacote rx_notifier). Uma de suas características padrão é impedir que um mesmo estado seja disparado (distinto); NotifierStore não suporta atualização forçada, setLoading ou setError.

Vamos começar no triple geralmente criamos uma classe State para abrigar nossas variaveis que sofreram reatividade,
e uma classe Store para nossos metodos 'regra de negocio', abaixo temos os exemplos da nossa classe state com a variavel counter,
e logo apos nossa classe store com o metodo que vai dar um update 'atualizar' o valor da nossa variavel.

# classe State

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

criada a variavel, depois inicializamos e criamos um copyWith para podermos alterar o seu valor.

# classe Store

class HomeStore extends StreamStore<Exception, HomeState> {
  HomeStore() : super(HomeState.init());

  void incrementCounter() {
    final value = state.counter + 1;
    update(state.copyWith(counter: value));
  }
}

criamos o metodo para incrementar nossa variavel e passamos nosso copyWith dentro de um update,
para que assim a variavel seja atualizada.

agora que criamos nossa variavel e criamos o metodo que vai incrementar ela temos que notificar o flutter
que widget queremos acrescentar reatividade e isso fazemos envolvendo nosso widget com um ScopedBuilder,
como abaixo.


 ScopedBuilder(
              store: controller,
              onState: ((context, state) {
                return Text(
                  '${controller.state.counter}',
                  style: Theme.of(context).textTheme.headline4,
                );
              }),
            )

como demonstrado no exemplo acima o widget ScopedBuilder retorna o widget ao qual você deseja que seja redesenhado na tela,
ao chamar o ScopedBuilder ele é requerido uma store, a store ao qual esta sua regra de negocio utilizada no widget,
no onState, você passa um context e um state e atraves do state você pode recuperar as variaveis da sua classe state
este metodo onState por sua vez retorna o widget que você quer que seja redesenhado.

o widget ScopedBuilder tambem possui um outro atributo muito interessante chamado onLoading, muitas das vezes temos metodos
asynchronos e não sabemos exatamente quando nossa variavel tera o valor esperado então podemos passar um setLoading em nosso metodo
para que assim o triple saiba quando chamar o onLoading e o widget de carregamento e quando chamar de volta o widget principal
no onState. exemplo abaixo de uso

 Future<void> incrementCounter() async {
    setLoading(true);
    await Future.delayed(
      const Duration(seconds: 1),
    );
    final value = state.counter + 1;
    update(state.copyWith(counter: value));
    setLoading(false);
  }

colocamos um setLoading como true quando queremos notificar o triple, para que ele use o widget de retorno no onLoading do
ScopedBuilder e quando queremos que ele passe para o retorno do widget do onState apenas colocamo setLoading como false.