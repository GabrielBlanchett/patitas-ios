class Mascota {
    let nombre: String
    var duenio: Duenio?
    init(nombre: String) { self.nombre = nombre; print("  + Mascota \(nombre)") }
    deinit { print("  - Mascota \(nombre) liberada") }
}
class Duenio {
    let nombre: String
    var mascota: Mascota?
    init(nombre: String) { self.nombre = nombre; print("  + Duenio \(nombre)") }
    deinit { print("  - Duenio \(nombre) liberado") }
}

print("CASO 1: sin ciclo")
do {
    let m = Mascota(nombre: "Kira")
    _ = m
}
print("(salio del ambito)\n")

print("CASO 2: con ciclo fuerte")
do {
    let m = Mascota(nombre: "Nube")
    let d = Duenio(nombre: "Ana")
    m.duenio = d
    d.mascota = m
}
print("(salio del ambito: no se libero nada)\n")

class MascotaDebil {
    let nombre: String
    weak var duenio: DuenioDebil?
    init(nombre: String) { self.nombre = nombre; print("  + Mascota \(nombre)") }
    deinit { print("  - Mascota \(nombre) liberada") }
}
class DuenioDebil {
    let nombre: String
    var mascota: MascotaDebil?
    init(nombre: String) { self.nombre = nombre; print("  + Duenio \(nombre)") }
    deinit { print("  - Duenio \(nombre) liberado") }
}

print("CASO 3: rompiendo el ciclo con weak")
do {
    let m = MascotaDebil(nombre: "Luna")
    let d = DuenioDebil(nombre: "Luis")
    m.duenio = d
    d.mascota = m
}
print("(salio del ambito)")
