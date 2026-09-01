import Foundation

final class ContadorInseguro: @unchecked Sendable {
    var valor = 0
    func incrementar() { valor += 1 }
}

func main() async {
    for intento in 1...3 {
        let c = ContadorInseguro()
        await withTaskGroup(of: Void.self) { grupo in
            for _ in 1...10_000 { grupo.addTask { c.incrementar() } }
        }
        print("Intento \(intento): esperaba 10000, obtuve \(c.valor)")
    }
}
await main()
