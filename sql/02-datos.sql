-- Datos de ejemplo de Patitas Seguras.
--
-- Son pocos y elegidos: hay un refugio lleno, una mascota adoptada, una
-- persona sin telefono y una solicitud de cada estado. Asi los ejemplos del
-- libro tocan los casos interesantes sin necesitar miles de filas.

INSERT INTO refugios (nombre, ciudad, capacidad) VALUES
    ('Patitas Norte',  'Monterrey',    40),
    ('Patitas Centro', 'Monterrey',    25),
    ('Refugio del Sol', 'Guadalajara', 60);

INSERT INTO personas (nombre, correo, telefono) VALUES
    ('Ana Rivera',   'ana@correo.mx',   '81-1234-5678'),
    ('Luis Ortega',  'luis@correo.mx',  '33-8765-4321'),
    ('Sofia Mendez', 'sofia@correo.mx', NULL);

INSERT INTO mascotas (nombre, especie, edad_en_meses, adoptada, refugio_id) VALUES
    ('Kira',  'perro',  14, false, 1),
    ('Balto', 'perro',   1, false, 1),
    ('Nube',  'gato',   36, true,  1),
    ('Luna',  'gato',   24, false, 2),
    ('Copo',  'conejo',  8, false, 2),
    ('Rocco', 'perro',  60, false, 3),
    ('Mia',   'gato',    3, false, 3);

INSERT INTO solicitudes (mascota_id, persona_id, estado) VALUES
    (1, 1, 'pendiente'),
    (1, 2, 'rechazada'),
    (3, 2, 'aprobada'),
    (4, 1, 'pendiente');
