import 'package:crud_materias/models/Model.dart';

class Materia extends Model {

  static String table = 'tblMaterias';

  int id;
  String nombre;
  String profesor;
  String cuatrimestre;
  String horario;

    Materia({ this.id, this.nombre, this.profesor,
      this.cuatrimestre, this.horario });

    Map<String, dynamic> toMap() {

        Map<String, dynamic> map = {
            'nombre': nombre,
            'profesor': profesor,
            'cuatrimestre': cuatrimestre,
            'horario': horario
        };

        if (id != null) { map['id'] = id; }
        return map;
    }

    static Materia fromMap(Map<String, dynamic> map) {
        return Materia(
            id: map['id'],
            nombre: map['nombre'].toString(),
            profesor: map['profesor'].toString(),
            cuatrimestre: map['cuatrimestre'].toString(),
            horario: map['horario'].toString()
        );
    }
}