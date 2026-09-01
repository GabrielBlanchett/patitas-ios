enum Estado {
    case disponible
    case enProceso
    case adoptada
}

let estado = Estado.disponible
switch estado {
case .disponible: print("Se puede solicitar")
case .enProceso:  print("Alguien la esta tramitando")
case .adoptada:   print("Ya tiene familia")
}

enum Tamano: String, CaseIterable {
    case pequeno = "pequeña"
    case mediano = "mediana"
    case grande  = "grande"
}
print("\nTodos los tamanos: \(Tamano.allCases.map(\.rawValue))")
print("Desde texto: \(Tamano(rawValue: "grande") != nil)")
print("Texto malo:  \(Tamano(rawValue: "gigante") == nil)")

enum EventoAdopcion {
    case solicitada(por: String)
    case aprobada(fecha: String)
    case rechazada(motivo: String)
}

let eventos: [EventoAdopcion] = [
    .solicitada(por: "Ana"),
    .rechazada(motivo: "Faltan documentos"),
    .aprobada(fecha: "2026-09-01"),
]
print("")
for evento in eventos {
    switch evento {
    case .solicitada(let quien):  print("Solicitada por \(quien)")
    case .aprobada(let fecha):    print("Aprobada el \(fecha)")
    case .rechazada(let motivo):  print("Rechazada: \(motivo)")
    }
}

enum Semaforo {
    case rojo, amarillo, verde
    var siguiente: Semaforo {
        switch self {
        case .rojo: .verde
        case .verde: .amarillo
        case .amarillo: .rojo
        }
    }
    var puedePasar: Bool { self == .verde }
}
var luz = Semaforo.rojo
print("\nCiclo:")
for _ in 1...4 {
    print("  \(luz) -> pasar: \(luz.puedePasar)")
    luz = luz.siguiente
}

indirect enum Arbol {
    case hoja(String)
    case nodo(izquierda: Arbol, derecha: Arbol)
}
func contar(_ arbol: Arbol) -> Int {
    switch arbol {
    case .hoja: 1
    case .nodo(let i, let d): contar(i) + contar(d)
    }
}
let arbol = Arbol.nodo(izquierda: .hoja("Kira"),
                       derecha: .nodo(izquierda: .hoja("Balto"), derecha: .hoja("Nube")))
print("\nHojas del arbol: \(contar(arbol))")
