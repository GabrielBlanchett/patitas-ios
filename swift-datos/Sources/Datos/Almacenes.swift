import Foundation
import Security

// MARK: - UserDefaults

/// Envoltorio con tipos sobre `UserDefaults`.
///
/// `UserDefaults` acepta cualquier cosa bajo cualquier cadena, y ahí empiezan
/// los problemas: una clave mal escrita no falla, simplemente devuelve nil
/// para siempre. Concentrar las claves en un solo sitio lo evita.
///
/// El `@unchecked Sendable` es necesario y está justificado: Apple documenta
/// `UserDefaults` como seguro entre hilos, pero la clase no está marcada
/// `Sendable` porque viene de Objective-C. Sin la anotación, Swift 6 rechaza
/// guardarla dentro de un `struct` que sí lo es.
public struct Preferencias: @unchecked Sendable {
    private let defaults: UserDefaults

    /// Las claves, en un solo lugar y escritas una sola vez.
    public enum Clave: String, CaseIterable, Sendable {
        case ultimoFiltro = "patitas.ultimoFiltro"
        case vecesAbierta = "patitas.vecesAbierta"
        case aceptoTerminos = "patitas.aceptoTerminos"
    }

    public init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    /// Una suite propia para pruebas: no toca las preferencias de nadie.
    public static func paraPruebas(nombre: String = UUID().uuidString) -> Preferencias {
        guard let suite = UserDefaults(suiteName: nombre) else {
            fatalError("No se pudo crear la suite de pruebas")
        }
        return Preferencias(defaults: suite)
    }

    public func texto(_ clave: Clave) -> String? {
        defaults.string(forKey: clave.rawValue)
    }

    public func guardar(_ valor: String, en clave: Clave) {
        defaults.set(valor, forKey: clave.rawValue)
    }

    public func entero(_ clave: Clave) -> Int {
        defaults.integer(forKey: clave.rawValue)
    }

    public func guardar(_ valor: Int, en clave: Clave) {
        defaults.set(valor, forKey: clave.rawValue)
    }

    public func bandera(_ clave: Clave) -> Bool {
        defaults.bool(forKey: clave.rawValue)
    }

    public func guardar(_ valor: Bool, en clave: Clave) {
        defaults.set(valor, forKey: clave.rawValue)
    }

    public func borrar(_ clave: Clave) {
        defaults.removeObject(forKey: clave.rawValue)
    }
}

// MARK: - Keychain

/// Guarda un secreto en el llavero del sistema.
///
/// La API es de C y se maneja con diccionarios sin tipar, así que conviene
/// envolverla una sola vez y no volver a mirarla.
public enum Llavero {
    public enum ErrorLlavero: Error, Equatable {
        case fallo(OSStatus)
        case datosCorruptos
    }

    private static func consulta(cuenta: String, servicio: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: servicio,
            kSecAttrAccount as String: cuenta,
        ]
    }

    public static func guardar(
        _ valor: String,
        cuenta: String,
        servicio: String = "mx.gabrielblanchet.patitas"
    ) throws {
        guard let datos = valor.data(using: .utf8) else { throw ErrorLlavero.datosCorruptos }

        // Se borra antes de escribir: SecItemAdd falla con errSecDuplicateItem
        // si la entrada ya existe, y "actualizar" es la operación que de
        // verdad se quiere el 99 % de las veces.
        SecItemDelete(consulta(cuenta: cuenta, servicio: servicio) as CFDictionary)

        var atributos = consulta(cuenta: cuenta, servicio: servicio)
        atributos[kSecValueData as String] = datos
        // Sin esto, el secreto se puede leer con el teléfono bloqueado.
        atributos[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock

        let estado = SecItemAdd(atributos as CFDictionary, nil)
        guard estado == errSecSuccess else { throw ErrorLlavero.fallo(estado) }
    }

    public static func leer(
        cuenta: String,
        servicio: String = "mx.gabrielblanchet.patitas"
    ) throws -> String {
        var consultaDeLectura = consulta(cuenta: cuenta, servicio: servicio)
        consultaDeLectura[kSecReturnData as String] = true
        consultaDeLectura[kSecMatchLimit as String] = kSecMatchLimitOne

        var resultado: CFTypeRef?
        let estado = SecItemCopyMatching(consultaDeLectura as CFDictionary, &resultado)
        guard estado == errSecSuccess else { throw ErrorLlavero.fallo(estado) }
        guard let datos = resultado as? Data,
              let texto = String(data: datos, encoding: .utf8)
        else { throw ErrorLlavero.datosCorruptos }
        return texto
    }

    public static func borrar(
        cuenta: String,
        servicio: String = "mx.gabrielblanchet.patitas"
    ) throws {
        let estado = SecItemDelete(consulta(cuenta: cuenta, servicio: servicio) as CFDictionary)
        guard estado == errSecSuccess || estado == errSecItemNotFound else {
            throw ErrorLlavero.fallo(estado)
        }
    }
}
