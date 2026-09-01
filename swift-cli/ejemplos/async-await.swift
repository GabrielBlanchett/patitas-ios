import Foundation

func tardar(_ ms: UInt64, _ etiqueta: String) async -> String {
    try? await Task.sleep(nanoseconds: ms * 1_000_000)
    return etiqueta
}

func secuencial() async {
    let inicio = Date()
    let a = await tardar(300, "A")
    let b = await tardar(300, "B")
    let t = Int(Date().timeIntervalSince(inicio) * 1000)
    print("Secuencial: \(a)\(b) en ~\(t / 100 * 100) ms")
}

func enParalelo() async {
    let inicio = Date()
    async let a = tardar(300, "A")
    async let b = tardar(300, "B")
    let r = await (a, b)
    let t = Int(Date().timeIntervalSince(inicio) * 1000)
    print("Paralelo:   \(r.0)\(r.1) en ~\(t / 100 * 100) ms")
}

enum ErrorRed: Error { case sinConexion }

func cargar(_ id: Int) async throws -> String {
    if id < 0 { throw ErrorRed.sinConexion }
    try? await Task.sleep(nanoseconds: 100_000_000)
    return "mascota-\(id)"
}

func conGrupo() async {
    let resultados = await withTaskGroup(of: String.self) { grupo in
        for id in 1...3 { grupo.addTask { (try? await cargar(id)) ?? "fallo" } }
        var salida: [String] = []
        for await r in grupo { salida.append(r) }
        return salida.sorted()
    }
    print("TaskGroup:  \(resultados)")
}

func conError() async {
    do {
        _ = try await cargar(-1)
    } catch {
        print("Capturado:  \(error)")
    }
}

await secuencial()
await enParalelo()
await conGrupo()
await conError()
