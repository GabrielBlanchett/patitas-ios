// Capitulo 34 - SOLID en Swift
// Los cinco principios, cada uno con la version rota y la sana, ejecutandose.

// ==================================== S - Responsabilidad unica

// Roto: valida, formatea y "guarda". Tres razones para cambiar.
struct SolicitudTodoEnUno {
    let correo: String
    func procesar() -> String {
        guard correo.contains("@") else { return "correo invalido" }
        let limpio = correo.lowercased()
        return "[GUARDADA] " + limpio
    }
}

// Sano: tres piezas, cada una con un motivo de cambio.
enum ValidadorDeCorreo {
    static func esValido(_ c: String) -> Bool { c.contains("@") && c.contains(".") }
}
enum NormalizadorDeCorreo {
    static func normalizar(_ c: String) -> String { c.lowercased() }
}
final class AlmacenDeSolicitudes {
    private(set) var guardadas: [String] = []
    func guardar(_ c: String) { guardadas.append(c) }
}

// ==================================== O - Abierto/cerrado

// Roto: cada especie nueva obliga a abrir esta funcion.
func tarifaRota(tipo: String) -> Double {
    switch tipo {
    case "perro": return 500
    case "gato":  return 400
    default:      return 0        // y aqui se cuelan los errores
    }
}

// Sano: cada especie trae su tarifa. La funcion no se vuelve a tocar.
protocol Especie {
    var nombre: String { get }
    var tarifaDeAdopcion: Double { get }
}
struct Perro: Especie { let nombre = "perro"; let tarifaDeAdopcion = 500.0 }
struct Gato:  Especie { let nombre = "gato";  let tarifaDeAdopcion = 400.0 }
struct Conejo: Especie { let nombre = "conejo"; let tarifaDeAdopcion = 250.0 }

func tarifa(de especie: Especie) -> Double { especie.tarifaDeAdopcion }

// ==================================== L - Sustitucion de Liskov

class Almacen {
    private(set) var nombres: [String] = []
    func guardar(_ n: String) { nombres.append(n) }
}

// Roto: promete ser un Almacen y no cumple el contrato.
final class AlmacenDeSoloLectura: Almacen {
    override func guardar(_ n: String) { /* se traga el dato en silencio */ }
}

func registrarCenso(en almacen: Almacen) -> Int {
    for n in ["Kira", "Balto", "Nube"] { almacen.guardar(n) }
    return almacen.nombres.count
}

// ==================================== I - Segregacion de interfaces

// Roto: quien solo lee esta obligado a fingir que escribe.
protocol FuenteGorda {
    func leer() -> [String]
    func escribir(_ n: String)
    func borrarTodo()
}
struct CatalogoRemoto: FuenteGorda {
    func leer() -> [String] { ["Kira", "Balto"] }
    func escribir(_ n: String) { /* no se puede: metodo vacio, mentira */ }
    func borrarTodo() { /* tampoco */ }
}

// Sano: dos protocolos pequeños. Cada tipo firma solo lo que cumple.
protocol Legible  { func leer() -> [String] }
protocol Escribible { mutating func escribir(_ n: String) }

struct CatalogoDeSoloLectura: Legible {
    func leer() -> [String] { ["Kira", "Balto"] }
}
struct CacheLocal: Legible, Escribible {
    private var datos: [String] = []
    func leer() -> [String] { datos }
    mutating func escribir(_ n: String) { datos.append(n) }
}

// ==================================== D - Inversion de dependencias

protocol Notificador {
    func avisar(_ mensaje: String)
}

struct NotificadorPush: Notificador {
    func avisar(_ mensaje: String) { print("   [push real] \(mensaje)") }
}

final class NotificadorDePrueba: Notificador {
    // Una clase, para poder anotar lo que se le pidio sin mutar un struct.
    private(set) var enviados: [String] = []
    func avisar(_ mensaje: String) { enviados.append(mensaje) }
}

struct ServicioDeAdopcion {
    let notificador: Notificador          // depende del protocolo, no del push
    func adoptar(_ mascota: String) {
        notificador.avisar("\(mascota) fue adoptada")
    }
}

// ============================================================== SALIDA

print("=== S: responsabilidad unica ===")
print("Todo en uno: \(SolicitudTodoEnUno(correo: "Ana@Refugio.MX").procesar())")
let almacenSolicitudes = AlmacenDeSolicitudes()
let entrada = "Ana@Refugio.MX"
if ValidadorDeCorreo.esValido(entrada) {
    almacenSolicitudes.guardar(NormalizadorDeCorreo.normalizar(entrada))
}
print("Separado:    \(almacenSolicitudes.guardadas)")

print("=== O: abierto/cerrado ===")
print("Roto, conejo: \(tarifaRota(tipo: "conejo"))")
let especies: [Especie] = [Perro(), Gato(), Conejo()]
for e in especies { print("Sano, \(e.nombre): \(tarifa(de: e))") }

print("=== L: sustitucion de Liskov ===")
print("Almacen normal:      \(registrarCenso(en: Almacen()))")
print("Almacen solo lectura: \(registrarCenso(en: AlmacenDeSoloLectura()))")

print("=== I: segregacion de interfaces ===")
var cache = CacheLocal()
cache.escribir("Luna")
print("Solo lectura lee: \(CatalogoDeSoloLectura().leer())")
print("Cache escribe y lee: \(cache.leer())")

print("=== D: inversion de dependencias ===")
ServicioDeAdopcion(notificador: NotificadorPush()).adoptar("Kira")
let espia = NotificadorDePrueba()
ServicioDeAdopcion(notificador: espia).adoptar("Balto")
print("   [en la prueba] se envio: \(espia.enviados)")
