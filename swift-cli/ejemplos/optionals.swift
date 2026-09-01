let edades: [String: Int] = ["Kira": 14, "Balto": 1]

let edadKira: Int? = edades["Kira"]
let edadRex: Int? = edades["Rex"]
print("Kira: \(String(describing: edadKira))")
print("Rex:  \(String(describing: edadRex))")

if let edad = edades["Kira"] {
    print("if let: Kira tiene \(edad) meses")
} else {
    print("if let: Kira no esta")
}

if let edad = edades["Rex"] {
    print("if let: Rex tiene \(edad) meses")
} else {
    print("if let: Rex no esta en el refugio")
}

func describir(_ nombre: String) -> String {
    guard let edad = edades[nombre] else {
        return "\(nombre): sin registro"
    }
    return "\(nombre): \(edad) meses"
}
print(describir("Balto"))
print(describir("Rex"))

print("?? con valor:  \(edades["Kira"] ?? 0)")
print("?? sin valor:  \(edades["Rex"] ?? 0)")

struct Duenio { let telefono: String? }
struct Mascota { let nombre: String; let duenio: Duenio? }

let conDuenio = Mascota(nombre: "Nube", duenio: Duenio(telefono: "555-1234"))
let sinDuenio = Mascota(nombre: "Kira", duenio: nil)

print("Encadenado 1: \(conDuenio.duenio?.telefono ?? "sin telefono")")
print("Encadenado 2: \(sinDuenio.duenio?.telefono ?? "sin telefono")")

let texto = "42"
let numero = Int(texto)
print("Int(\"42\") = \(numero ?? -1)")
let textoMalo = "cuarenta"
print("Int(\"cuarenta\") = \(Int(textoMalo) ?? -1)")

switch edades["Rex"] {
case .some(let edad): print("switch: hay edad \(edad)")
case .none:           print("switch: no hay edad")
}

let listaVacia: [String] = []
let listaNil: [String]? = nil
print("Vacia no es nil: count = \(listaVacia.count)")
print("Nil es otra cosa: \(listaNil?.count ?? -1)")
