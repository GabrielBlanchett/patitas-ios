#!/usr/bin/env bash
# Genera las salidas reales del capitulo 37 (Git en equipo).
#
# Todo se hace en un repositorio desechable, con fechas y autores fijos para
# que los identificadores de commit salgan iguales en cada ejecucion.
set -u

RAIZ="$(dirname "$0")/repo"
rm -rf "$RAIZ"
mkdir -p "$RAIZ"
cd "$RAIZ" || exit 1

export GIT_AUTHOR_NAME="Ana"
export GIT_AUTHOR_EMAIL="ana@patitas.mx"
export GIT_COMMITTER_NAME="Ana"
export GIT_COMMITTER_EMAIL="ana@patitas.mx"
export GIT_AUTHOR_DATE="2026-09-01T10:00:00-06:00"
export GIT_COMMITTER_DATE="2026-09-01T10:00:00-06:00"

git init -q -b main .
git config user.name "Ana"
git config user.email "ana@patitas.mx"
# Sin esto, Git avisa del cambio de LF a CRLF en cada archivo y ensucia la
# salida que va al libro. En el repositorio de verdad esto lo fija .gitattributes.
git config core.autocrlf false

titulo() { printf '\n===== %s =====\n' "$1"; }

# ------------------------------------------------------------------
titulo "A. Base comun"
cat > Tarifas.swift <<'EOF'
enum Tarifas {
    static let iva = 0.16
    static func total(base: Double) -> Double { base * (1 + iva) }
}
EOF
git add . && git commit -q -m "feat(tarifas): calcula el total con IVA"
git log --oneline

# ------------------------------------------------------------------
titulo "B. Dos ramas que tocan la misma linea"
git switch -q -c feat/iva-2027
cat > Tarifas.swift <<'EOF'
enum Tarifas {
    static let iva = 0.18
    static func total(base: Double) -> Double { base * (1 + iva) }
}
EOF
export GIT_AUTHOR_DATE="2026-09-01T11:00:00-06:00"
export GIT_COMMITTER_DATE="2026-09-01T11:00:00-06:00"
git commit -qam "feat(tarifas): sube el IVA al 18 por ciento"

git switch -q main
export GIT_AUTHOR_NAME="Luis"; export GIT_AUTHOR_EMAIL="luis@patitas.mx"
export GIT_COMMITTER_NAME="Luis"; export GIT_COMMITTER_EMAIL="luis@patitas.mx"
export GIT_AUTHOR_DATE="2026-09-01T11:30:00-06:00"
export GIT_COMMITTER_DATE="2026-09-01T11:30:00-06:00"
cat > Tarifas.swift <<'EOF'
enum Tarifas {
    static let iva = 0.16
    static let descuentoRefugio = 0.10
    static func total(base: Double) -> Double { base * (1 + iva) }
}
EOF
git commit -qam "feat(tarifas): agrega el descuento de refugio"
git log --oneline --graph --all

# ------------------------------------------------------------------
titulo "C. El conflicto, tal como aparece"
git switch -q feat/iva-2027
git merge main
echo "--- codigo de salida: $? ---"
echo "--- git status --short ---"
git status --short
echo "--- el archivo con las marcas ---"
cat Tarifas.swift

# ------------------------------------------------------------------
titulo "D. Resolver: quedarse con las dos intenciones"
cat > Tarifas.swift <<'EOF'
enum Tarifas {
    static let iva = 0.18
    static let descuentoRefugio = 0.10
    static func total(base: Double) -> Double { base * (1 + iva) }
}
EOF
git add Tarifas.swift
export GIT_AUTHOR_NAME="Ana"; export GIT_AUTHOR_EMAIL="ana@patitas.mx"
export GIT_COMMITTER_NAME="Ana"; export GIT_COMMITTER_EMAIL="ana@patitas.mx"
export GIT_AUTHOR_DATE="2026-09-01T12:00:00-06:00"
export GIT_COMMITTER_DATE="2026-09-01T12:00:00-06:00"
git commit -q --no-edit
git log --oneline --graph --all

# ------------------------------------------------------------------
titulo "E. La misma historia, pero con rebase"
git switch -q main
git switch -q -c feat/rebase-demo HEAD~1
export GIT_AUTHOR_DATE="2026-09-01T13:00:00-06:00"
export GIT_COMMITTER_DATE="2026-09-01T13:00:00-06:00"
echo "// nota de la rama" >> Notas.swift
git add . && git commit -qm "docs: agrega una nota"
echo "--- antes del rebase ---"
git log --oneline --graph --all --max-count=6
git rebase main >/dev/null 2>&1
echo "--- despues del rebase: la rama queda encima, sin nudo ---"
git log --oneline --graph main feat/rebase-demo

# ------------------------------------------------------------------
titulo "F. Aplastar varios commits en uno (squash)"
git switch -q main
git switch -q -c feat/tres-pasos
for n in 1 2 3; do
  export GIT_AUTHOR_DATE="2026-09-01T14:0${n}:00-06:00"
  export GIT_COMMITTER_DATE="2026-09-01T14:0${n}:00-06:00"
  echo "paso $n" >> Borrador.swift
  git add . && git commit -qm "wip $n"
done
echo "--- tres commits de trabajo en curso ---"
git log --oneline --max-count=4
git switch -q main
export GIT_AUTHOR_DATE="2026-09-01T14:10:00-06:00"
export GIT_COMMITTER_DATE="2026-09-01T14:10:00-06:00"
git merge --squash feat/tres-pasos >/dev/null 2>&1
git commit -qm "feat(borrador): agrega el borrador completo"
echo "--- en main entra uno solo, con un mensaje que se entiende ---"
git log --oneline --max-count=3

# ------------------------------------------------------------------
titulo "G. Borrar trabajo y recuperarlo con reflog"
SHA_ANTES=$(git rev-parse --short HEAD)
git reset --hard HEAD~1 >/dev/null 2>&1
echo "--- despues de un reset --hard: el commit ya no esta ---"
git log --oneline --max-count=2
echo "--- git reflog se acuerda de todo ---"
git reflog --max-count=5
echo "--- se recupera apuntando de vuelta ---"
git reset --hard "$SHA_ANTES" >/dev/null 2>&1
git log --oneline --max-count=2

# ------------------------------------------------------------------
titulo "H. revert: deshacer sin borrar historia"
export GIT_AUTHOR_DATE="2026-09-01T15:00:00-06:00"
export GIT_COMMITTER_DATE="2026-09-01T15:00:00-06:00"
git revert --no-edit HEAD >/dev/null 2>&1
git log --oneline --max-count=3
echo "--- el archivo volvio a su estado anterior ---"
ls

# ------------------------------------------------------------------
titulo "I. bisect: encontrar el commit que rompio la prueba"
git switch -q -c bisect-demo
cat > prueba.sh <<'EOF'
#!/usr/bin/env bash
# "Prueba" del proyecto: el total de 500 tiene que dar 580.
grep -q 'iva = 0.16' Tarifas.swift
EOF
chmod +x prueba.sh
export GIT_AUTHOR_DATE="2026-09-01T16:00:00-06:00"
export GIT_COMMITTER_DATE="2026-09-01T16:00:00-06:00"
git add . && git commit -qm "test: agrega la prueba del total"
BUENO=$(git rev-parse --short HEAD)

for n in 1 2 3 4 5 6; do
  export GIT_AUTHOR_DATE="2026-09-01T16:0${n}:00-06:00"
  export GIT_COMMITTER_DATE="2026-09-01T16:0${n}:00-06:00"
  if [ "$n" = "4" ]; then
    # Aqui se cuela el error, mezclado con un cambio inocente.
    sed -i 's/iva = 0.16/iva = 0.15/' Tarifas.swift
    echo "// ajuste menor $n" >> Notas.swift
    git add . && git commit -qm "refactor: limpieza menor en tarifas"
  else
    echo "// cambio $n" >> Notas.swift
    git add . && git commit -qm "chore: cambio $n"
  fi
done

echo "--- la prueba falla en la punta y nadie sabe desde cuando ---"
./prueba.sh; echo "codigo de salida: $?"
echo "--- git bisect run lo encuentra solo ---"
git bisect start HEAD "$BUENO" >/dev/null 2>&1
git bisect run ./prueba.sh 2>&1 | grep -vE "^(Author|Date|commit [0-9a-f]{40}$)" | head -24
git bisect reset >/dev/null 2>&1

echo
echo "===== FIN ====="
