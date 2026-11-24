import 'package:material_ui/material_ui.dart';

import '../temas/colores.dart';

const bold = FontWeight.bold;
const regular = FontWeight.normal;
const gabarito = 'Gabarito';
const russo = 'RussoOne';

txtStyle({double? size = 18, color = blanco, weight = bold, fam = gabarito}) {
  return TextStyle(
    fontSize: size,
    color: color,
    fontFamily: fam,
    fontWeight: weight,
  );
}
