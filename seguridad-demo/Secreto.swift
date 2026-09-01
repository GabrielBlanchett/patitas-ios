// Como NO se guarda una llave. Este archivo existe para ser descompilado.
//
// Se compila y luego se le pasa `strings` encima. La llave aparece completa.
// Es la demostracion del cap. 86: el binario es un archivo de texto con pasos
// intermedios, y el usuario lo tiene en la mano.

import Foundation

enum ConfiguracionMala {
    // Error 1: la llave, tal cual, en el codigo.
    static let llaveAPI = "pk_live_51QsAdopta7mNvMxKiraFirulais99"

    // Error 2: "ofuscarla" invirtiendola. Sigue en el binario, al reves.
    static let llaveInvertida = String("pk_live_ESTA_TAMBIEN_SE_VE".reversed())

    // Error 3: partirla en pedazos. El compilador la vuelve a juntar.
    static let llavePartida = "pk_live_" + "PARTIDA_" + "IGUAL_SE_VE"
}

print("La app arranco. Nada en pantalla revela la llave.")
print("Longitud de la llave: \(ConfiguracionMala.llaveAPI.count) caracteres")
_ = ConfiguracionMala.llaveInvertida
_ = ConfiguracionMala.llavePartida
