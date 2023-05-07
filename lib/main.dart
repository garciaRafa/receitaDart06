import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DataService {
  final ValueNotifier<List> tableStateNotifier = new ValueNotifier([]);
  final ValueNotifier<List<String>> columnNamesNotifier = new ValueNotifier([]);
  final ValueNotifier<List<String>> propertyNamesNotifier =
      new ValueNotifier([]);

  void carregar(index) {
    if (index == 0) carregarCafe();
    if (index == 1) carregarCervejas();
    if (index == 2) carregarNacao();
  }

  void carregarCervejas() {
    tableStateNotifier.value = [
      {"name": "La Fin Du Monde", "style": "Bock", "ibu": "65"},
      {"name": "Sapporo Premiume", "style": "Sour Ale", "ibu": "54"},
      {"name": "Duvel", "style": "Pilsner", "ibu": "82"}
    ];
    columnNamesNotifier.value = ["Nome", "Estilo", "IBU"];
    propertyNamesNotifier.value = ["name", "style", "ibu"];
  }

  void carregarCafe() {
    tableStateNotifier.value = [
      {"name": "Melty Bean", "origin": "Guatemala", "intensifier": "Vibrante"},
      {"name": "Blue Been", "origin": "Nicarágua", "intensifier": "Denso"},
      {"name": "Seattle Forrester", "origin": "Iêmen", "intensifier": "Crocante"}
    ];
    columnNamesNotifier.value = ["Nome", "Origem", "Intensificador"];
    propertyNamesNotifier.value = ["name", "origin", "intensifier"];
  }

  void carregarNacao() {
    tableStateNotifier.value = [
      {"language": "Espanhol", "family": "Românica", "countries": "65"},
      {"language": "Alemão", "family": "Germânica", "countries": "115"},
      {"language": "Mandarim", "family": "Sino-tibetana", "countries": "6"}
    ];
    columnNamesNotifier.value = ["Língua", "Família", "Países"];
    propertyNamesNotifier.value = ["language", "family", "countries"];
  }
}

final dataService = DataService();

void main() {
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Receita 6"),
          ),
          body: ValueListenableBuilder(
              valueListenable: dataService.tableStateNotifier,
              builder: (_, value, __) {
                return DataTableWidget(
                    jsonObjects: value,
                    columnNames: dataService.columnNamesNotifier.value,
                    propertyNames: dataService.propertyNamesNotifier.value);
              }),
          bottomNavigationBar:
              NewNavBar(itemSelectedCallback: dataService.carregar),
        ));
  }
}

class NewNavBar extends HookWidget {
  var itemSelectedCallback;

  NewNavBar({this.itemSelectedCallback}) {
    itemSelectedCallback ??= (_) {};
  }

  @override
  Widget build(BuildContext context) {
    var state = useState(0);
    return BottomNavigationBar(
        onTap: (index) {
          state.value = index;
          itemSelectedCallback(index);
        },
        currentIndex: state.value,
        items: const [
          BottomNavigationBarItem(
            label: "Cafés",
            icon: Icon(Icons.coffee_outlined),
          ),
          BottomNavigationBarItem(
              label: "Cervejas", icon: Icon(Icons.local_drink_outlined)),
          BottomNavigationBarItem(
              label: "Nações", icon: Icon(Icons.flag_outlined))
        ]);
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;

  DataTableWidget(
      {this.jsonObjects = const [],
      this.columnNames = const [],
      this.propertyNames = const []});

  @override
  Widget build(BuildContext context) {
    if (columnNames.isEmpty) {
      return Center(child: Text('Não há colunas disponíveis.'));
    }

    return DataTable(
        columns: columnNames
            .map((name) => DataColumn(
                label: Expanded(
                    child: Text(name,
                        style: TextStyle(fontStyle: FontStyle.italic)))))
            .toList(),
        rows: jsonObjects
            .map((obj) => DataRow(
                cells: propertyNames
                    .map((propName) => DataCell(Text(obj[propName] ?? '')))
                    .toList()))
            .toList());
  }
}
