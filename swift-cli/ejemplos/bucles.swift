let mascotas = ["Kira", "Balto", "Nube"]

for mascota in mascotas {
    print("- \(mascota)")
}

for (posicion, mascota) in mascotas.enumerated() {
    print("\(posicion): \(mascota)")
}

for i in 1...3 { print("vuelta \(i)") }

for i in stride(from: 0, to: 10, by: 3) { print("stride \(i)") }

var restantes = 3
while restantes > 0 {
    print("quedan \(restantes)")
    restantes -= 1
}

var intentos = 0
repeat {
    intentos += 1
} while intentos < 3
print("intentos: \(intentos)")

for mascota in mascotas {
    if mascota == "Balto" { continue }
    if mascota == "Nube" { break }
    print("procesada: \(mascota)")
}

for mascota in mascotas where mascota.count > 4 {
    print("nombre largo: \(mascota)")
}
