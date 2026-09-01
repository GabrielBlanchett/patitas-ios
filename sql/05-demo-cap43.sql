-- Demostraciones del capitulo 43 (modelado de datos).
-- Provoca las tres anomalias clasicas en una tabla sin normalizar, y luego
-- ensena como desaparecen al separarla. Se ejecuta con:
--   docker compose exec -T db psql -U patitas -d patitas < sql/05-demo-cap43.sql

\echo '===== A. La tabla plana, como la hace todo el mundo la primera vez ====='
DROP TABLE IF EXISTS todo_junto;
CREATE TABLE todo_junto (
    mascota         text,
    especie         text,
    refugio         text,
    refugio_ciudad  text,
    refugio_tel     text
);

INSERT INTO todo_junto VALUES
    ('Kira',  'perro', 'Patitas Norte',  'Monterrey', '81-1111-1111'),
    ('Balto', 'perro', 'Patitas Norte',  'Monterrey', '81-1111-1111'),
    ('Nube',  'gato',  'Patitas Norte',  'Monterrey', '81-1111-1111'),
    ('Luna',  'gato',  'Patitas Centro', 'Monterrey', '81-2222-2222'),
    ('Copo',  'conejo','Patitas Centro', 'Monterrey', '81-2222-2222');

SELECT * FROM todo_junto;

\echo '===== B. Anomalia de actualizacion ====='
\echo '-- El refugio Norte se muda a Saltillo. Alguien actualiza "algunas" filas:'
UPDATE todo_junto SET refugio_ciudad = 'Saltillo'
WHERE refugio = 'Patitas Norte' AND mascota IN ('Kira', 'Balto');

\echo '-- Ahora el mismo refugio esta en dos ciudades a la vez:'
SELECT DISTINCT refugio, refugio_ciudad FROM todo_junto WHERE refugio = 'Patitas Norte';

\echo '===== C. Anomalia de insercion ====='
\echo '-- Se abre un refugio nuevo que todavia no tiene mascotas.'
\echo '-- No hay donde ponerlo sin inventar una mascota falsa:'
INSERT INTO todo_junto VALUES (NULL, NULL, 'Patitas Sur', 'Queretaro', '44-3333-3333');
SELECT mascota, especie, refugio FROM todo_junto WHERE refugio = 'Patitas Sur';

\echo '===== D. Anomalia de borrado ====='
\echo '-- Se adopta a Luna y a Copo, las dos unicas de Patitas Centro:'
DELETE FROM todo_junto WHERE refugio = 'Patitas Centro';
\echo '-- Y con ellas desaparecio el refugio y su telefono:'
SELECT count(*) AS quedan_filas_de_centro FROM todo_junto WHERE refugio = 'Patitas Centro';

\echo '===== E. Separado, las tres anomalias no existen ====='
\echo '-- El refugio vive en un solo lugar, asi que mudarlo es UNA fila:'
UPDATE refugios SET ciudad = 'Saltillo' WHERE nombre = 'Patitas Norte';
SELECT nombre, ciudad FROM refugios ORDER BY id;
UPDATE refugios SET ciudad = 'Monterrey' WHERE nombre = 'Patitas Norte';

\echo '-- Un refugio sin mascotas se registra sin problema:'
INSERT INTO refugios (nombre, ciudad, capacidad) VALUES ('Patitas Sur', 'Queretaro', 30);
SELECT r.nombre, r.ciudad, count(m.id) AS mascotas
FROM refugios r LEFT JOIN mascotas m ON m.refugio_id = r.id
GROUP BY r.id, r.nombre, r.ciudad ORDER BY r.id;

\echo '===== F. Muchos a muchos: la tabla del medio ====='
\echo '-- Una persona solicita varias mascotas y una mascota recibe varias'
\echo '-- solicitudes. Eso NO cabe en una columna: necesita su propia tabla.'
SELECT p.nombre AS persona, m.nombre AS mascota, s.estado
FROM solicitudes s
JOIN personas p ON p.id = s.persona_id
JOIN mascotas m ON m.id = s.mascota_id
ORDER BY p.nombre, m.nombre;

\echo '===== G. Preguntas que solo se pueden hacer si esta normalizado ====='
SELECT r.nombre AS refugio,
       count(m.id) AS mascotas,
       count(m.id) FILTER (WHERE m.adoptada) AS adoptadas,
       r.capacidad,
       round(100.0 * count(m.id) / r.capacidad, 1) AS ocupacion_pct
FROM refugios r LEFT JOIN mascotas m ON m.refugio_id = r.id
GROUP BY r.id, r.nombre, r.capacidad
ORDER BY ocupacion_pct DESC;

DELETE FROM refugios WHERE nombre = 'Patitas Sur';
DROP TABLE todo_junto;
