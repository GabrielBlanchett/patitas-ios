func procesarAdopcion(idMascota: String?, idAdoptante: String?) {
guard let idMascota, let idAdoptante else {
print("Solicitud invalida: faltan datos")
return
}
// De aqui en adelante ambos son String NO opcionales,
// y el codigo feliz queda sin anidacion
print("Procesando adopcion de \(idMascota) por \(idAdoptante)")
}

procesarAdopcion(idMascota: "M-07", idAdoptante: nil)
procesarAdopcion(idMascota: "M-07", idAdoptante: "Ac-02")
