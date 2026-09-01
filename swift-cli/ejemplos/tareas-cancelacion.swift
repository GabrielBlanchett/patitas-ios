import Foundation

func trabajoLargo() async throws -> String {
    for paso in 1...10 {
        try Task.checkCancellation()
        try await Task.sleep(nanoseconds: 100_000_000)
        print("  paso \(paso)")
    }
    return "terminado"
}

func conCancelacion() async {
    let tarea = Task { try await trabajoLargo() }
    try? await Task.sleep(nanoseconds: 350_000_000)
    tarea.cancel()
    do {
        let r = try await tarea.value
        print("Resultado: \(r)")
    } catch is CancellationError {
        print("La tarea fue cancelada")
    } catch {
        print("Otro error: \(error)")
    }
}

func sinExcepcion() async {
    let tarea = Task { () -> Int in
        var cuenta = 0
        while !Task.isCancelled && cuenta < 1_000_000 { cuenta += 1 }
        return cuenta
    }
    tarea.cancel()
    let r = await tarea.value
    print("Con isCancelled paro en: \(r < 1_000_000 ? "antes del final" : "el final")")
}

func conTimeout() async {
    let resultado = await withTaskGroup(of: String?.self) { grupo -> String? in
        grupo.addTask {
            try? await Task.sleep(nanoseconds: 600_000_000)
            return "datos"
        }
        grupo.addTask {
            try? await Task.sleep(nanoseconds: 200_000_000)
            return nil
        }
        let primero = await grupo.next() ?? nil
        grupo.cancelAll()
        return primero
    }
    print("Con limite de tiempo: \(resultado ?? "se agoto el tiempo")")
}

func estructurada() async {
    print("Estructurada: el grupo espera a todas sus hijas")
    await withTaskGroup(of: Void.self) { grupo in
        for i in 1...3 {
            grupo.addTask {
                try? await Task.sleep(nanoseconds: UInt64(i) * 50_000_000)
                print("  hija \(i) termino")
            }
        }
    }
    print("Estructurada: aqui ya terminaron todas")
}

await conCancelacion()
await sinExcepcion()
await conTimeout()
await estructurada()
