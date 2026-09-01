# Compilacion en dos etapas: la primera trae todo el toolchain de Swift, la
# segunda se queda solo con lo necesario para ejecutar. Asi la imagen final
# no arrastra un compilador de 2 GB.
#
# La version 6.3.3 es la misma que el toolchain de Windows y la del runner de
# macOS: un solo Swift en las tres maquinas del libro.

FROM swift:6.3.3-bookworm AS build
WORKDIR /build

# Se copia primero el manifiesto y se resuelven las dependencias aparte, para
# que Docker reutilice esa capa mientras no cambie Package.swift.
COPY Package.swift ./
RUN swift package resolve

COPY Sources ./Sources
RUN swift build -c release --product App

# La imagen de ejecucion es la "slim" del mismo Swift: trae las bibliotecas de
# runtime sin el compilador, y evita tener que enlazar la estandar estaticamente.
FROM swift:6.3.3-bookworm-slim
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates tzdata curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=build /build/.build/release/App ./

EXPOSE 8080
ENTRYPOINT ["./App"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]
