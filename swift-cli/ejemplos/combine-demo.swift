// Cap. 105: Combine, para leerlo y mantenerlo.
// Solo corre en plataformas de Apple: Combine es cerrado y no existe en
// Windows ni en Linux. Se ejecuta en el runner macOS del CI.

import Foundation
import Combine

var guardados = Set<AnyCancellable>()

func separador(_ t: String) { print(""); print("--- \(t) ---") }

// 1. Lo mas basico: un publisher que emite y termina.
separador("Un publisher que emite tres valores y termina")
["Kira", "Balto", "Nube"].publisher
    .sink(receiveCompletion: { print("   fin: \($0)") },
          receiveValue: { print("   valor: \($0)") })
    .store(in: &guardados)

// 2. Operadores: la cadena que se ve en toda app con Combine.
separador("Operadores encadenados")
[1, 2, 3, 4, 5, 6].publisher
    .filter { $0 % 2 == 0 }
    .map { $0 * 10 }
    .collect()
    .sink { print("   pares por diez: \($0)") }
    .store(in: &guardados)

// 3. Un sujeto: lo que usa un modelo de vista para publicar cambios.
separador("CurrentValueSubject: guarda el ultimo valor")
let busqueda = CurrentValueSubject<String, Never>("")
busqueda
    .sink { print("   busqueda = '\($0)'") }
    .store(in: &guardados)
busqueda.send("ki")
busqueda.send("kira")
print("   valor actual: '\(busqueda.value)'")

// 4. Errores: el publisher se TERMINA al fallar, y no vuelve a emitir.
separador("Un error termina el publisher para siempre")
enum ErrorDeRed: Error { case sinConexion }
let conFallo = PassthroughSubject<String, ErrorDeRed>()
conFallo
    .sink(receiveCompletion: { print("   completion: \($0)") },
          receiveValue: { print("   valor: \($0)") })
    .store(in: &guardados)
conFallo.send("primero")
conFallo.send(completion: .failure(.sinConexion))
conFallo.send("segundo")            // no se recibe: ya termino
print("   (el 'segundo' no aparece arriba: por eso importa)")

// 5. La fuga: sin guardar el AnyCancellable, la suscripcion muere al instante.
separador("Sin guardar el cancellable, no llega nada")
let subject = PassthroughSubject<Int, Never>()
_ = subject.sink { print("   recibido \($0)") }   // no se guarda
subject.send(1)
subject.send(2)
print("   (arriba no aparecio ningun 'recibido': la suscripcion murio)")

// 6. El puente a async/await, que es como se migra.
separador("De Combine a async/await")
let unoSolo = Just(42)
Task {
    for await v in unoSolo.values {
        print("   por async/await: \(v)")
    }
    exit(0)
}
RunLoop.main.run(until: Date().addingTimeInterval(2))
