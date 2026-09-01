import Refugio

print("Refugio Patitas Seguras")
for mascota in Mascota.refugioDeEjemplo {
    let estado = mascota.estaDisponible ? "disponible" : "adoptada"
    print("- \(mascota.descripcionCorta) [\(estado)]")
}
