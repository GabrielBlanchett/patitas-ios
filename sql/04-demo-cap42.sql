-- Demostraciones del capitulo 42 (PostgreSQL).
-- Mide de verdad la diferencia que hace un indice. Se ejecuta con:
--   docker compose exec -T db psql -U patitas -d patitas < sql/04-demo-cap42.sql

\echo '===== A. Una tabla grande de verdad ====='
DROP TABLE IF EXISTS visitas;
CREATE TABLE visitas (
    id          bigserial PRIMARY KEY,
    mascota_id  bigint      NOT NULL,
    correo      text        NOT NULL,
    vista_en    timestamptz NOT NULL
);

-- 500.000 filas generadas por la propia base de datos.
INSERT INTO visitas (mascota_id, correo, vista_en)
SELECT (i % 7) + 1,
       'persona' || (i % 50000) || '@correo.mx',
       now() - (i || ' minutes')::interval
FROM generate_series(1, 500000) AS i;

ANALYZE visitas;
SELECT count(*) AS filas FROM visitas;

\echo '===== B. Buscar SIN indice ====='
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY ON)
SELECT count(*) FROM visitas WHERE correo = 'persona42@correo.mx';

\echo '===== C. Crear el indice ====='
CREATE INDEX idx_visitas_correo ON visitas (correo);
ANALYZE visitas;

\echo '===== D. La misma busqueda, CON indice ====='
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY ON)
SELECT count(*) FROM visitas WHERE correo = 'persona42@correo.mx';

\echo '===== E. Lo que cuesta un indice ====='
SELECT pg_size_pretty(pg_relation_size('visitas'))            AS tabla,
       pg_size_pretty(pg_relation_size('idx_visitas_correo')) AS indice;

\echo '===== F. Un indice que NO se usa ====='
EXPLAIN (COSTS OFF)
SELECT count(*) FROM visitas WHERE lower(correo) = 'persona42@correo.mx';

\echo '===== G. Tipos que conviene conocer ====='
DROP TABLE IF EXISTS ficha;
CREATE TABLE ficha (
    id        uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    datos     jsonb       NOT NULL,
    creada_en timestamptz NOT NULL DEFAULT now()
);
INSERT INTO ficha (datos) VALUES
    ('{"vacunas": ["rabia", "moquillo"], "peso_kg": 8.4}'),
    ('{"vacunas": [], "peso_kg": 2.1}');

SELECT datos->>'peso_kg' AS peso,
       jsonb_array_length(datos->'vacunas') AS num_vacunas
FROM ficha ORDER BY peso;

\echo '-- El uuid se genera solo y no revela cuantas filas hay:'
SELECT length(id::text) AS largo_del_uuid FROM ficha LIMIT 1;
