import Foundation

actor Refugio {
    private var adoptadas = 0
    private var nombres: [String] = []

    func registrarAdopcion(_ nombre: String) {
        adoptadas += 1
        nombres.append(nombre)
    }
    var total: Int { adoptadas }
    func lista() -> [String] { nombres.sorted() }
}

struct MascotaSendable: Sendable {
    let nombre: String
    let edadEnMeses: Int
}

func main() async {
    let refugio = Refugio()

    await withTaskGroup(of: Void.self) { grupo in
        for i in 1...100 {
            grupo.addTask { await refugio.registrarAdopcion("m\(i)") }
        }
    }

    let total = await refugio.total
    print("Actor: \(total) adopciones registradas desde 100 tareas")

    let m = MascotaSendable(nombre: "Kira", edadEnMeses: 14)
    await withTaskGroup(of: String.self) { grupo in
        for _ in 1...3 { grupo.addTask { m.nombre } }
        for await n in grupo { print("Sendable compartido sin riesgo: \(n)") }
    }
}

await main()
