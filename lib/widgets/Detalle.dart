import 'package:flutter/material.dart';
import 'package:crud_materias/models/Materia.dart';
import 'package:crud_materias/services/Data.dart';

//final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class Detalle extends StatefulWidget {
  final Materia materia;
  //Detalle({Key key}) : super(key: key);
  Detalle({this.materia});
  @override
  _DetalleState createState() => _DetalleState();
}

class _DetalleState extends State<Detalle> {
  final _nombreController = TextEditingController();
  final _profesorController = TextEditingController();
  final _cuatrimestreController = TextEditingController();
  final _horarioController = TextEditingController();
  String _titulo = 'Nueva Materia';

  @override
  void initState() {
    if (widget.materia != null) {
      _nombreController.text = widget.materia.nombre;
      _profesorController.text = widget.materia.profesor;
      _cuatrimestreController.text = widget.materia.cuatrimestre;
      _horarioController.text = widget.materia.horario;
      _titulo = 'Actualizar Materia';
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_titulo'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(hintText: 'Nombre de la materia'),
              ),
              TextField(
                controller: _profesorController,
                decoration: InputDecoration(hintText: 'Nombre del profesor'),
              ),
              TextField(
                controller: _cuatrimestreController,
                decoration: InputDecoration(hintText: 'Cuatrimestre'),
              ),
              TextField(
                controller: _horarioController,
                decoration: InputDecoration(hintText: 'Horario'),
              ),
              RaisedButton(
                  child: Text(
                    widget.materia != null ? 'Actualizar' : 'Guardar',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.purple,
                  onPressed: () {
                    final Materia materia = Materia(
                        nombre: _nombreController.text,
                        profesor: _profesorController.text,
                        cuatrimestre: _cuatrimestreController.text,
                        horario: _horarioController.text);
                    if (widget.materia == null) 
                      _save(materia);
                    else {
                      materia.id = widget.materia.id; 
                      _update(materia);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  void _save(Materia item) async {
    await Data.insert(Materia.table, item);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Materia agregada con exito!'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              _nombreController.text = '';
              _profesorController.text = '';
              _cuatrimestreController.text = '';
              _horarioController.text = '';
            },
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  _update(Materia item) async{ 
    Data.update(Materia.table, item);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Materia actualizada con exito!'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              _nombreController.text = '';
              _profesorController.text = '';
              _cuatrimestreController.text = '';
              _horarioController.text = '';
            },
            child: Text('OK'),
          )
        ],
      ),
    ).then((value) => Navigator.pop(context));
  }
}
