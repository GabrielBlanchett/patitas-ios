enum ErrorRefugio: Error {
    case noEncontrada(nombre: String)
    case yaAdoptada(nombre: String)
    case edadInvalida(meses: Int)
}

struct Mascota { let nombre: String; let edadEnMeses: Int; var adoptada: Bool }

var refugio = [
    Mascota(nombre: "Kira", edadEnMeses: 14, adoptada: false),
    Mascota(nombre: "Nube", edadEnMeses: 36, adoptada: true),
]

func adoptar(_ nombre: String) throws -> String {
    guard let mascota = refugio.first(where: { $0.nombre == nombre }) else {
        throw ErrorRefugio.noEncontrada(nombre: nombre)
    }
    guard !mascota.adoptada else {
        throw ErrorRefugio.yaAdoptada(nombre: nombre)
    }
    return "Adopcion registrada: \(mascota.nombre)"
}

for nombre in ["Kira", "Nube", "Rex"] {
    do {
        let mensaje = try adoptar(nombre)
        print("OK   -> \(mensaje)")
    } catch ErrorRefugio.noEncontrada(let n) {
        print("FALLA-> \(n) no esta en el refugio")
    } catch ErrorRefugio.yaAdoptada(let n) {
        print("FALLA-> \(n) ya tiene familia")
    } catch {
        print("FALLA-> error inesperado: \(error)")
    }
}

print("\ntry? convierte el error en nil:")
print("  Kira: \((try? adoptar("Kira")) ?? "sin resultado")")
print("  Rex:  \((try? adoptar("Rex")) ?? "sin resultado")")

func validarEdad(_ meses: Int) -> Result<Int, ErrorRefugio> {
    guard meses >= 0 else { return .failure(.edadInvalida(meses: meses)) }
    return .success(meses)
}

print("\nResult:")
for m in [14, -3] {
    switch validarEdad(m) {
    case .success(let edad): print("  valida: \(edad)")
    case .failure(let error): print("  invalida: \(error)")
    }
}

func conDefer() {
    print("\ndefer:")
    defer { print("  3. esto se ejecuta al final, pase lo que pase") }
    print("  1. inicio")
    print("  2. cuerpo")
}
conDefer()
