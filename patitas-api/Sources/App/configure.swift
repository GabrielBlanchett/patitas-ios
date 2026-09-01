import Vapor

func configure(_ app: Application) async throws {
    // 0.0.0.0 y no 127.0.0.1: dentro de un contenedor hay que escuchar en
    // todas las interfaces o el puerto publicado no llega a ninguna parte.
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 8080

    try rutas(app)
}
