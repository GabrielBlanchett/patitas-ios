struct Mascota {
    let nombre: String
    let edad: Int
}

let mascotas = [
    Mascota(nombre: "Firulais", edad: 3),
    Mascota(nombre: "Michi", edad: 2),
    Mascota(nombre: "Rex", edad: 5),
]

let jovenes = mascotas.filter { $0.edad < 4 } .map(\.nombre)

print("Mascotas jóvenes: \(jovenes)")