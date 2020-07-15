import 'package:flutter/material.dart';
import 'package:crud_materias/services/Data.dart';
import 'package:crud_materias/models/Materia.dart';
import 'package:crud_materias/widgets/Detalle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Data.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: MyHomePage(title: 'Flutter CRUD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Materia> _materias = [];
  TextStyle _style = TextStyle(color: Colors.white, fontSize: 24);

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Row(
        children: <Widget>[
          Text(
            widget.title,
            style: _style,
          ),
          Spacer(),
          FlatButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Detalle()));
              refresh();
            },
          ),
        ],
      )),
      body: Center(child: ListView(children: _items)),
    );
  }

  List<Widget> get _items => _materias.map((item) => format(item)).toList();

  Widget format(Materia item) {
    return Dismissible(
      key: Key((item.id ?? 0).toString()),
      child: Opacity(
        opacity: .9,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            //height: 80,
            //color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(item.nombre ?? ''),
                Text('profesor:\t' + item.profesor ?? ''),
                Text('cuatrimestre:\t' + item.cuatrimestre ?? ''),
                Text('horario:\t' + item.horario ?? ''),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'Eliminar',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Precaucion'),
                                content: Text(
                                    'Estas seguro de eliminar la materia ${item.nombre}?'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Si'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _delete(item);
                                    },
                                  ),
                                  FlatButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('No')),
                                ],
                              );
                            });
                      },
                    ),
                    FlatButton(
                        child: Text('Editar'),
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Detalle(
                                        materia: item,
                                      )));
                          refresh();
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      onDismissed: (DismissDirection direction) => _delete(item),
    );
  }

  void refresh() async {
    List<Map<String, dynamic>> _results = await Data.query(Materia.table);
    _materias = _results.map((item) => Materia.fromMap(item)).toList();
    setState(() {});
  }

  void _delete(Materia item) async {
    Data.delete(Materia.table, item);
    Scaffold.of(this.context)
        .showSnackBar(SnackBar(content: Text('Elemento eliminado')));
    refresh();
  }
}
