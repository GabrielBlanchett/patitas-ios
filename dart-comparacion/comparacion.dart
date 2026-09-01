// Las cuatro cosas que un desarrollador de Flutter tiene que DESAPRENDER
// al pasar a Swift. Este archivo y su gemelo en Swift imprimen lo mismo
// para que la diferencia se vea, no se explique.
//
// Se ejecuta en el CI con `dart run comparacion.dart`.

// ---------------------------------------------------------------- 1. Copias

class PuntoDart {
  double x;
  double y;
  PuntoDart(this.x, this.y);
  @override
  String toString() => '($x, $y)';
}

void copias() {
  print('--- 1. Que pasa al copiar ---');
  final a = PuntoDart(1, 2);
  final b = a; // NO es una copia: es otro nombre para lo mismo.
  b.x = 99;
  print('a = $a');
  print('b = $b');
  print('identical(a, b) = ${identical(a, b)}');
}

// ------------------------------------------------------------- 2. Enums

// Dart 3 permite enums con campos, pero TODOS los casos comparten la misma
// forma. No hay un caso con dos valores y otro con ninguno.
enum EstadoDart {
  cargando(descripcion: 'cargando'),
  listo(descripcion: 'listo'),
  fallo(descripcion: 'fallo');

  const EstadoDart({required this.descripcion});
  final String descripcion;
}

// Para tener datos DISTINTOS por caso hay que usar clases selladas.
sealed class ResultadoDart {}

class Exito extends ResultadoDart {
  final List<String> mascotas;
  Exito(this.mascotas);
}

class Error extends ResultadoDart {
  final int codigo;
  final String mensaje;
  Error(this.codigo, this.mensaje);
}

class Vacio extends ResultadoDart {}

String describir(ResultadoDart r) => switch (r) {
      Exito(mascotas: final m) => 'exito con ${m.length} mascotas',
      Error(codigo: final c, mensaje: final msg) => 'error $c: $msg',
      Vacio() => 'sin resultados',
    };

void enums() {
  print('');
  print('--- 2. Enums y datos por caso ---');
  print('enum simple: ${EstadoDart.listo.descripcion}');
  print(describir(Exito(['Kira', 'Firulais'])));
  print(describir(Error(404, 'no encontrado')));
  print(describir(Vacio()));
  print('cuantos tipos hizo falta declarar: 4 (1 sellada + 3 hijas)');
}

// ------------------------------------------------------------ 3. Nulos

void nulos() {
  print('');
  print('--- 3. Nulos ---');
  String? nombre;
  print('sin valor: ${nombre ?? "(sin nombre)"}');
  nombre = 'Kira';
  print('largo con ?. = ${nombre?.length}');

  // `late` es la valvula de escape de Dart: promete que se asignara antes
  // de leerse. Si no, revienta en tiempo de ejecucion.
  late String tardio;
  try {
    print(tardio);
  } catch (e) {
    print('leer un late sin asignar: ${e.runtimeType}');
  }
}

// ------------------------------------------------- 4. Cascada y constantes

class Refugio {
  String nombre = '';
  String ciudad = '';
  int cupo = 0;
  @override
  String toString() => '$nombre ($ciudad), cupo $cupo';
}

void cascadaYConstantes() {
  print('');
  print('--- 4. Cascada y constantes ---');
  final r = Refugio()
    ..nombre = 'Patitas'
    ..ciudad = 'Guadalajara'
    ..cupo = 40;
  print('con cascada: $r');

  const enCompilacion = 3 * 14; // se calcula al compilar
  final enEjecucion = DateTime.now().year; // se calcula al correr
  print('const = $enCompilacion, final = $enEjecucion');

  const lista = [1, 2, 3];
  try {
    (lista as List<int>).add(4);
  } catch (e) {
    print('modificar una lista const: ${e.runtimeType}');
  }
}

void main() {
  print('=== DART ${_version()} ===');
  copias();
  enums();
  nulos();
  cascadaYConstantes();
}

String _version() {
  // La version completa la imprime el CI aparte; aqui solo el canal.
  return 'estable';
}
