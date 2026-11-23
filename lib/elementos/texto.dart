import 'package:material_ui/material_ui.dart';

import '../temas/colores.dart';

const bold = FontWeight.bold;
const regular = FontWeight.normal;

txtStyle({double? size = 18, color = blanco, weight = bold}) {
  return TextStyle(
    fontSize: size,
    color: color,
    fontFamily: 'Gabarito',
    fontWeight: weight,
  );
}
