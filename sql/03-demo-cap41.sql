-- Demostraciones del capitulo 41 (SQL y ACID).
-- Se ejecuta con:
--   docker compose exec -T db psql -U patitas -d patitas < sql/03-demo-cap41.sql

\echo '===== A. Consultar ====='
SELECT nombre, especie, edad_en_meses FROM mascotas WHERE adoptada = false
ORDER BY edad_en_meses LIMIT 4;

\echo '===== B. Contar y agrupar ====='
SELECT especie, count(*) AS cuantas, round(avg(edad_en_meses)) AS edad_media
FROM mascotas GROUP BY especie ORDER BY cuantas DESC;

\echo '===== C. Cruzar dos tablas ====='
SELECT m.nombre AS mascota, r.nombre AS refugio, r.ciudad
FROM mascotas m JOIN refugios r ON r.id = m.refugio_id
WHERE r.ciudad = 'Monterrey' ORDER BY m.nombre;

\echo '===== D. Las restricciones defienden los datos ====='
\echo '-- edad negativa:'
INSERT INTO mascotas (nombre, especie, edad_en_meses, refugio_id)
VALUES ('Imposible', 'perro', -5, 1);
\echo '-- especie inventada:'
INSERT INTO mascotas (nombre, especie, edad_en_meses, refugio_id)
VALUES ('Draco', 'dragon', 12, 1);
\echo '-- refugio que no existe:'
INSERT INTO mascotas (nombre, especie, edad_en_meses, refugio_id)
VALUES ('Fantasma', 'gato', 12, 999);
\echo '-- correo repetido:'
INSERT INTO personas (nombre, correo) VALUES ('Otra Ana', 'ana@correo.mx');
\echo '-- borrar un refugio con mascotas dentro:'
DELETE FROM refugios WHERE id = 1;

\echo '===== E. Transaccion que se deshace ====='
SELECT count(*) AS mascotas_antes FROM mascotas;
BEGIN;
INSERT INTO mascotas (nombre, especie, edad_en_meses, refugio_id)
VALUES ('Temporal', 'perro', 5, 1);
SELECT count(*) AS dentro_de_la_transaccion FROM mascotas;
ROLLBACK;
SELECT count(*) AS mascotas_despues FROM mascotas;

\echo '===== F. Atomicidad: o todo, o nada ====='
BEGIN;
UPDATE mascotas SET adoptada = true WHERE nombre = 'Luna';
UPDATE solicitudes SET estado = 'aprobada' WHERE mascota_id = 4;
-- Esta linea falla y tumba la transaccion entera.
UPDATE mascotas SET edad_en_meses = -1 WHERE nombre = 'Luna';
COMMIT;
\echo '-- Luna NO quedo adoptada, aunque ese UPDATE si habia funcionado:'
SELECT nombre, adoptada FROM mascotas WHERE nombre = 'Luna';
SELECT estado FROM solicitudes WHERE mascota_id = 4;
