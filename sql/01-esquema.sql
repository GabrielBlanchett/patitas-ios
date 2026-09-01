-- Esquema de Patitas Seguras.
--
-- Es el que usan los capitulos 41 a 43 del libro. Se carga con:
--   docker compose exec -T db psql -U patitas -d patitas < sql/01-esquema.sql
--
-- Cada restriccion esta aqui por una razon concreta que el libro explica:
-- una base de datos sin restricciones es un archivo de texto con pasos extra.

DROP TABLE IF EXISTS solicitudes CASCADE;
DROP TABLE IF EXISTS mascotas CASCADE;
DROP TABLE IF EXISTS personas CASCADE;
DROP TABLE IF EXISTS refugios CASCADE;

-- ---------------------------------------------------------------- refugios
CREATE TABLE refugios (
    id          bigserial PRIMARY KEY,
    nombre      text        NOT NULL,
    ciudad      text        NOT NULL,
    capacidad   integer     NOT NULL CHECK (capacidad > 0),
    creado_en   timestamptz NOT NULL DEFAULT now(),

    -- Dos refugios pueden llamarse igual en ciudades distintas, pero no
    -- en la misma ciudad: eso siempre es un duplicado por captura.
    UNIQUE (nombre, ciudad)
);

-- ---------------------------------------------------------------- personas
CREATE TABLE personas (
    id          bigserial PRIMARY KEY,
    nombre      text        NOT NULL,
    correo      text        NOT NULL UNIQUE,
    telefono    text,
    creada_en   timestamptz NOT NULL DEFAULT now(),

    -- No valida un correo de verdad, y no pretende hacerlo: comprueba que
    -- tenga arroba y un punto despues. El capitulo 30 explica por que las
    -- expresiones regulares "completas" para correos son mala idea.
    CHECK (correo LIKE '%@%.%')
);

-- ---------------------------------------------------------------- mascotas
CREATE TABLE mascotas (
    id              bigserial PRIMARY KEY,
    nombre          text    NOT NULL,
    especie         text    NOT NULL CHECK (especie IN ('perro', 'gato', 'conejo')),
    edad_en_meses   integer NOT NULL CHECK (edad_en_meses >= 0),
    adoptada        boolean NOT NULL DEFAULT false,

    -- Si se borra un refugio, sus mascotas no pueden quedar huerfanas.
    -- RESTRICT obliga a decidir que hacer con ellas primero.
    refugio_id      bigint  NOT NULL REFERENCES refugios(id) ON DELETE RESTRICT,

    ingreso_en      timestamptz NOT NULL DEFAULT now()
);

-- ------------------------------------------------------------- solicitudes
CREATE TABLE solicitudes (
    id          bigserial PRIMARY KEY,
    mascota_id  bigint NOT NULL REFERENCES mascotas(id) ON DELETE CASCADE,
    persona_id  bigint NOT NULL REFERENCES personas(id) ON DELETE CASCADE,
    estado      text   NOT NULL DEFAULT 'pendiente'
                CHECK (estado IN ('pendiente', 'aprobada', 'rechazada')),
    creada_en   timestamptz NOT NULL DEFAULT now(),

    -- La misma persona no puede solicitar dos veces la misma mascota.
    UNIQUE (mascota_id, persona_id)
);
