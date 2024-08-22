import 'package:flutter/material.dart';
import 'criar_editar_tela.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

_MyHomePageState? myHomePageState;

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final BuildContext context;

  MyRouteObserver(this.context);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is MaterialPageRoute && route.builder(context) is SegundaTela) {
      myHomePageState?.setState(() {
        myHomePageState?._isFabExpanded = false;
      });
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {}
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> cardData = [];
  int count = 0;
  bool _isFabExpanded = false;

  @override
  void initState() {
    super.initState();
    myHomePageState = this;
  }

  @override
  Widget build(BuildContext context) {
    final _routeObserver = MyRouteObserver(context);
    return MaterialApp(
      navigatorObservers: [_routeObserver],
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(itemCount: cardData.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        cardData[index]['_isCardExpanded'] =
                        !cardData[index]['_isCardExpanded'];
                      });
                    },
                    title: Text(cardData[index]['titulo']),
                    subtitle: Text(cardData[index]['descricao']),
                    trailing: SizedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _excluiCard(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _irParaSegundaTela(
                                  context,
                                  index: cardData[index]['index'],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          transform: Matrix4.rotationZ(_isFabExpanded ? 0.785 : 0),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _isFabExpanded = !_isFabExpanded;
              });
              _irParaSegundaTela(context);
            },
            child: AnimatedIcon(
              icon: AnimatedIcons.add_event,
              progress: _isFabExpanded
                  ? AlwaysStoppedAnimation(1)
                  : AlwaysStoppedAnimation(0),
            ),
          ),
        ),
      ),
    );
  }

  void _excluiCard(int index) {
    setState(() {
      cardData.removeAt(index);
    });
  }

  void _irParaSegundaTela(BuildContext context, {int? index}) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SegundaTela(
              index: index,
              tituloInicial: index != null ? cardData[index]['titulo'] : '',
              descricaoInicial: index != null
                  ? cardData[index]['descricao']
                  : '',
            ),
      ),
    );

    if (resultado != null) {
      setState(() {
        if (index != null) {
          cardData[index]['titulo'] = resultado['titulo'];
          cardData[index]['descricao'] = resultado['descricao'];
        } else {
          cardData.add({
            'titulo': resultado['titulo'],
            'descricao': resultado['descricao'],
            'index': count,
          });
          count++;
        }
      });
    }
  }
}