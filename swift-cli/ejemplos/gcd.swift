// Cap. 104: GCD, el mundo antes de async/await.
// Colas serie y concurrentes, sync frente a async, y la carrera que
// aparece cuando dos hilos tocan lo mismo.

import Foundation
import Dispatch

func separador(_ titulo: String) {
    print("")
    print("--- \(titulo) ---")
}

// 1. Una cola SERIE: las tareas entran de una en una, en orden.
separador("Cola serie: una detras de otra, en orden")
let serie = DispatchQueue(label: "refugio.serie")
let grupo1 = DispatchGroup()
for i in 1...5 {
    serie.async(group: grupo1) { print("   tarea \(i)") }
}
grupo1.wait()

// 2. Una cola CONCURRENTE: entran varias a la vez y el orden no se promete.
separador("Cola concurrente: a la vez, orden no garantizado")
let concurrente = DispatchQueue(label: "refugio.concurrente", attributes: .concurrent)
let grupo2 = DispatchGroup()
for i in 1...5 {
    concurrente.async(group: grupo2) {
        Thread.sleep(forTimeInterval: Double.random(in: 0...0.05))
        print("   tarea \(i)")
    }
}
grupo2.wait()

// 3. La carrera de datos: dos hilos sumando sobre la misma variable.
separador("Carrera de datos: mil sumas sin proteger")
final class Contador: @unchecked Sendable {
    var valor = 0
}
let sinProteger = Contador()
let grupo3 = DispatchGroup()
DispatchQueue.concurrentPerform(iterations: 1000) { _ in
    sinProteger.valor += 1          // sin proteccion
}
grupo3.wait()
print("   esperado: 1000")
print("   obtenido: \(sinProteger.valor)")

// 4. La misma suma, protegida por una cola serie.
separador("La misma suma, protegida por una cola serie")
let protegido = Contador()
let candado = DispatchQueue(label: "refugio.candado")
DispatchQueue.concurrentPerform(iterations: 1000) { _ in
    candado.sync { protegido.valor += 1 }
}
print("   esperado: 1000")
print("   obtenido: \(protegido.valor)")

// 5. DispatchGroup: esperar a que terminen varias tareas.
separador("DispatchGroup: esperar a que acaben todas")
let grupo = DispatchGroup()
for mascota in ["Kira", "Balto", "Nube"] {
    grupo.enter()
    concurrente.async {
        Thread.sleep(forTimeInterval: 0.02)
        print("   descargada la foto de \(mascota)")
        grupo.leave()
    }
}
grupo.wait()
print("   las tres estan listas")
