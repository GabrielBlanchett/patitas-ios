// Cap. 40: por que el ciclo de retencion se escapa en una revision.
// Los dos objetos hacen lo mismo y ninguno falla. La diferencia solo se ve
// mirando quien se libera al salir del alcance.

final class ConCiclo {
    var segundos = 0
    var alTic: (() -> Void)?

    init() {
        // El closure retiene a self, y self retiene al closure.
        alTic = { self.segundos += 1 }
    }
    deinit { print("   ConCiclo:  liberado") }
}

final class SinCiclo {
    var segundos = 0
    var alTic: (() -> Void)?

    init() {
        alTic = { [weak self] in self?.segundos += 1 }
    }
    deinit { print("   SinCiclo:  liberado") }
}

func usarConCiclo() {
    let objeto = ConCiclo()
    objeto.alTic?()
    objeto.alTic?()
    print("   ConCiclo:  segundos = \(objeto.segundos)")
}

func usarSinCiclo() {
    let objeto = SinCiclo()
    objeto.alTic?()
    objeto.alTic?()
    print("   SinCiclo:  segundos = \(objeto.segundos)")
}

print("Los dos cuentan bien y ninguno falla:")
usarConCiclo()
usarSinCiclo()

print("")
print("Al salir del alcance, solo uno se libera:")
usarConCiclo()
usarSinCiclo()
print("(si arriba falta una linea, ese objeto sigue en memoria)")
