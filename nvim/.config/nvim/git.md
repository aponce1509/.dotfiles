---
tags: []
---

<!-- TODO: añadir como crear un repo en gluon y como crear un token -->

# Guía Completa de Git y GitHub

[[Rebasing Git Branch to Main]]

## Introducción a Git

### ¿Qué es Git?

Git es un sistema de control de versiones distribuido, creado por Linus Torvalds
en 2005. Permite:

- Registrar cambios en archivos a lo largo del tiempo
- Volver a versiones anteriores de archivos o del proyecto completo
- Comparar cambios a lo largo del tiempo
- Trabajar simultáneamente con múltiples personas en el mismo proyecto
- Gestionar diferentes versiones o "ramas" de un proyecto

A diferencia de sistemas centralizados, cada desarrollador tiene una copia
completa del repositorio en su máquina local, lo que permite trabajar offline y
proporciona redundancia.

### Configuración inicial

Antes de comenzar a usar Git, necesitas configurarlo. La configuración mínima
requiere establecer tu nombre de usuario y correo electrónico:

```bash
# Configuración global (para todos los repositorios)
git config --global user.name "Tu Nombre"
git config --global user.email "tu.email@ejemplo.com"

# Configuración solo para un repositorio específico (sin --global)
git config user.name "Tu Nombre"
git config user.email "tu.email@ejemplo.com"
```

Para crear un nuevo repositorio:

```bash
# Inicializar un repositorio nuevo
git init

# O clonar uno existente usando HTTPS
git clone https://github.com/usuario/repositorio.git
```

### Conceptos básicos

![[Pasted image 20250405135448.png]]

#### Áreas de Git

Git maneja tres áreas principales:

1. **Working Directory (Directorio de trabajo)**: Donde modificas tus archivos.
2. **Staging Area (Área de preparación)**: Donde agregas los cambios que quieres
   incluir en el próximo commit.
3. **Repository (Repositorio)**: Donde se almacenan los cambios confirmados.

#### Comandos básicos

**Estado del repositorio**:

```bash
# Ver el estado actual
git status

# Ver historial de commits
git log
git log --oneline --graph --decorate  # Formato más visual
```

**Guardar cambios**:

```bash
# Añadir archivos al staging area
git add archivo.txt        # Añadir un archivo específico
git add carpeta/           # Añadir una carpeta
git add .                  # Añadir todos los cambios

# Confirmar cambios (crear commit)
git commit -m "Mensaje descriptivo del cambio"

# Añadir y confirmar en un solo paso (solo para archivos ya trackeados)
git commit -am "Mensaje descriptivo del cambio"
```

**Deshacer cambios**:

```bash
# Descartar cambios en el working directory
git checkout -- archivo.txt

# Deshacer cambios en staging
git reset HEAD archivo.txt

# Modificar el último commit
git commit --amend -m "Nuevo mensaje"
```

#### Ramas (Branches)

Las ramas permiten trabajar en características, correcciones o experimentos de
forma aislada.

```bash
# Ver ramas
git branch

# Crear una rama
git branch nombre-rama

# Cambiar a una rama
git checkout nombre-rama

# Crear y cambiar a una rama en un solo paso
git checkout -b nombre-rama

# Eliminar una rama
git branch -d nombre-rama  # Solo si está mergeada
git branch -D nombre-rama  # Forzar eliminación
```

## Estrategias de integración

### Merge

El merge es la forma más común de integrar cambios entre ramas. Crea un nuevo
commit que combina los cambios de ambas ramas.

```bash
# Estando en la rama destino (por ejemplo, main)
git merge feature-branch

# Merge sin fast-forward (siempre crea un commit de merge)
git merge --no-ff feature-branch
```

**Ejemplo**:

```bash
# Crear y trabajar en una rama de característica
git checkout -b feature-login
# ... hacer cambios ...
git add .
git commit -m "Implementar sistema de login"

# Volver a main e integrar los cambios
git checkout main
git merge feature-login
```

### Rebase

![[Pasted image 20250405130026.png]]

El rebase reescribe la historia del proyecto, aplicando los commits de una rama
sobre otra, generando un historial lineal.

```bash
# Estando en la rama feature
git rebase main

# O desde cualquier rama
git rebase main feature
```

**Ejemplo**:

```bash
git checkout feature-profile
# ... hacer cambios ...
git add .
git commit -m "Actualizar perfil de usuario"

# Antes de integrar, actualizar con main
git rebase main
# Resolver conflictos si los hay
git add .
git rebase --continue

# Luego, hacer merge en main
git checkout main
git merge feature-profile  # Será un fast-forward
```

### Cherry-pick

Permite seleccionar commits específicos de una rama y aplicarlos en otra.

```bash
# Aplicar un commit específico a la rama actual
git cherry-pick abc123

# Aplicar múltiples commits
git cherry-pick abc123 def456

# Cherry-pick sin hacer commit automáticamente
git cherry-pick -n abc123
```

**Ejemplo**:

```bash
# Identificar el commit que queremos
git log --oneline
# 1a2b3c4 Fix critical security bug
# 5d6e7f8 Add new feature

# Aplicar solo el fix de seguridad a la rama de producción
git checkout production
git cherry-pick 1a2b3c4
```

### Estrategias de merge

Existen varias estrategias para integrar cambios:

1. **Fast-forward (default)**: Si es posible, Git mueve simplemente el puntero
   de la rama sin crear un commit de merge.

```bash
git merge feature-branch
```

2. **Merge commit**: Crea un nuevo commit que une las dos ramas, preservando el
   historial completo.

```bash
git merge --no-ff feature-branch
```

3. **Squash**: Combina todos los commits de la rama en uno solo antes de
   mergearlo.

```bash
git merge --squash feature-branch
git commit -m "Integrar característica X"
```

4. **Rebase y merge**: Primero rebase para obtener historial lineal, luego
   merge.

```bash
git checkout feature-branch
git rebase main
git checkout main
git merge feature-branch  # Será fast-forward
```

## Git: HEAD, Commits Relativos y Estado Detached

### El concepto de HEAD en Git

HEAD es un puntero especial en Git que señala a la confirmación (commit) actual
en la que te encuentras trabajando. Generalmente, HEAD apunta al último commit
de la rama activa y se mueve automáticamente cuando creas nuevos commits.

#### ¿Qué es HEAD?

- Es una referencia simbólica al commit actual
- Normalmente apunta al último commit de tu rama activa
- Se utiliza como punto de referencia para muchas operaciones de Git

```bash
# Ver a qué commit apunta HEAD
git rev-parse HEAD
```

### Commits relativos

Git permite referenciar commits de forma relativa a HEAD o a cualquier otro
punto del historial.

#### Operadores de referencias relativas

- `HEAD~n`: n commits antes de HEAD
  - `HEAD~1` o simplemente `HEAD~`: Commit padre directo (un commit atrás)
  - `HEAD~2`: Dos commits atrás en la historia
- `HEAD^n`: n-ésimo padre de un commit de fusión (merge)
  - `HEAD^` o `HEAD^1`: Primer padre (equivalente a `HEAD~` en commits no merge)
  - `HEAD^2`: Segundo padre (solo en commits de merge)

```bash
# Ver el commit anterior a HEAD
git show HEAD~

# Ver el commit de hace dos commits
git show HEAD~2

# Ver el segundo padre de un commit de merge
git show HEAD^2
```

#### Ejemplos prácticos

```bash
# Deshacer el último commit pero mantener los cambios en staging
git reset --soft HEAD~1

# Comparar con el commit anterior
git diff HEAD~ HEAD

# Volver atrás tres commits
git checkout HEAD~3
```

#### Checkout a un commit específico

Git permite moverse a cualquier commit del historial usando `git checkout`.

```bash
# Checkout a un commit específico usando su hash
git checkout a1b2c3d4

# Checkout a un commit relativo
git checkout HEAD~5

# Volver a la rama después de explorar
git checkout main
```

### Estado "Detached HEAD"

Cuando haces checkout a un commit específico en lugar de una rama, entras en el
estado "detached HEAD" (HEAD desconectado).

#### ¿Qué significa "detached HEAD"?

- HEAD apunta directamente a un commit en lugar de a una rama
- No estás en ninguna rama del repositorio
- Los nuevos commits que crees no pertenecerán a ninguna rama existente

```bash
# Entrar en estado detached HEAD
git checkout 1a2b3c4d

# Git te mostrará un mensaje:
# "You are in 'detached HEAD' state..."
```

#### Trabajando en estado detached HEAD

En este estado puedes:

- Explorar código en versiones anteriores
- Realizar cambios experimentales
- Crear commits temporales

```bash
# Crear un commit en estado detached HEAD
git add .
git commit -m "Cambio experimental"

# Si quieres guardar estos cambios permanentemente:
git branch nueva-rama
# O
git tag version-experimental
```

#### Cómo salir del estado detached HEAD

Para volver a un estado normal:

```bash
# Volver a la rama principal
git checkout main

# O crear una nueva rama desde tu posición actual
git checkout -b nueva-rama-desde-detached
```

#### Advertencias importantes

1. **Los commits en estado detached HEAD pueden perderse** si no los guardas en
   una rama antes de moverte a otro punto.
2. **Git garbage collection** puede eliminar estos commits si no son
   referenciados por ninguna rama o etiqueta.
3. No es recomendable para trabajo de desarrollo normal, pero es útil para
   exploración.

### Casos de uso comunes

1. **Inspección de versiones antiguas**:

   ```bash
   git checkout a1b2c3d
   # Explorar el código
   git checkout main  # Volver después
   ```

2. **Recuperación de archivos antiguos**:

   ```bash
   git checkout a1b2c3d -- path/to/file.js
   # Esto trae el archivo desde ese commit sin cambiar HEAD
   ```

3. **Creación de una rama desde un punto antiguo**:

   ```bash
   git checkout -b nueva-caracteristica a1b2c3d
   # Crea y cambia a una nueva rama desde el commit especificado
   ```

4. **Pruebas y experimentación temporal**:

   ```bash
   git checkout a1b2c3d
   # Hacer cambios experimentales
   git add .
   git commit -m "Experimento"
   git checkout -b guardar-experimento  # Salvar el experimento en una rama
   ```

### Conclusiones

- HEAD es un concepto fundamental en Git para entender dónde estás trabajando
- Los commits relativos proporcionan una manera sencilla de navegar por el
  historial
- El estado detached HEAD es útil para exploración y experimentos temporales
- Siempre crea una rama si quieres conservar los cambios hechos en estado
  detachedj

## Repositorios remotos

### Local, Origin y Remote

- **Local**: Tu copia del repositorio en tu máquina.
- **Origin**: Nombre predeterminado para el repositorio remoto desde donde
  clonaste.
- **Remote**: Cualquier repositorio remoto conectado a tu repositorio local.

```bash
# Ver repositorios remotos
git remote -v

# Añadir un remote
git remote add nombre-remote https://github.com/usuario/repo.git

# Eliminar un remote
git remote remove nombre-remote

# Cambiar URL de un remote
git remote set-url origin https://github.com/usuario/nuevo-repo.git
```

### Trabajando con repositorios remotos

**Obtener cambios remotos**:

```bash
# Descargar cambios sin integrarlos (fetch)
git fetch origin

# Descargar e integrar cambios (pull)
git pull origin main

# Pull con rebase en lugar de merge
git pull --rebase origin main
```

**Enviar cambios al remoto**:

```bash
# Publicar cambios locales
git push origin main

# Publicar una rama nueva
git push -u origin feature-branch

# Forzar push (uso con precaución)
git push --force origin main
```

**Trabajar con múltiples remotos**:

```bash
# Añadir otro remote (fork original)
git remote add upstream https://github.com/original/repo.git

# Mantener tu fork actualizado
git fetch upstream
git checkout main
git merge upstream/main
```

## Flujos de trabajo

### Git Flow

![Rama hotfix dentro del flujo de trabajo de Git](https://wac-cdn.atlassian.com/dam/jcr:cc0b526e-adb7-4d45-874e-9bcea9898b4a/04%20Hotfix%20branches.svg?cdnVersion=2637)

Git Flow es un modelo de ramificación diseñado por Vincent Driessen que define
una estructura estricta para las ramas del proyecto.

**Ramas principales**:

- `main` (o `master`): Código en producción
- `develop`: Código en desarrollo

**Ramas de soporte**:

- `feature/*`: Nuevas características
- `release/*`: Preparación para releases
- `hotfix/*`: Correcciones urgentes
- `bugfix/*`: Correcciones no urgentes

**Ejemplo de flujo de trabajo**:

```bash
# Iniciar una nueva característica
git checkout develop
git checkout -b feature/login

# Completar la característica
git add .
git commit -m "Implementar sistema de login"

# Finalizar la característica
git checkout develop
git merge --no-ff feature/login
git branch -d feature/login

# Preparar un release
git checkout -b release/1.0.0
# ... posibles ajustes finales ...
git commit -m "Bump version to 1.0.0"

# Finalizar release
git checkout main
git merge --no-ff release/1.0.0
git tag -a v1.0.0 -m "Version 1.0.0"

git checkout develop
git merge --no-ff release/1.0.0
git branch -d release/1.0.0
```

### Trunk-Based Development

En Trunk-Based Development, los desarrolladores trabajan en una única rama
principal (trunk o main). Es un enfoque más simple que favorece la integración
continua.

**Características principales**:

- Commits frecuentes al trunk
- Ramas de corta duración (1-2 días)
- Feature flags para funcionalidades incompletas
- Despliegue continuo

**Ejemplo de flujo de trabajo**:

```bash
# Actualizar trunk
git checkout main
git pull

# Crear rama para cambio pequeño
git checkout -b small-feature

# Hacer cambios y commit
git add .
git commit -m "Implementar validación de formulario"

# Integrar cambios rápidamente
git checkout main
git pull
git merge small-feature
git push
git branch -d small-feature
```

### Comparativa

| Aspecto              | Git Flow                               | Trunk-Based                         |
| -------------------- | -------------------------------------- | ----------------------------------- |
| Complejidad          | Alta                                   | Baja                                |
| Ramas                | Múltiples, larga duración              | Pocas, corta duración               |
| CI/CD                | Compatible, pero más complejo          | Optimizado para CI/CD               |
| Equipos              | Grandes equipos, releases planificados | Equipos ágiles, despliegue continuo |
| Curva de aprendizaje | Pronunciada                            | Baja                                |

## Buenas prácticas

### Mensajes de commit

Un buen mensaje de commit debe ser claro, conciso y descriptivo. Un formato
recomendado es el "Conventional Commits":

```
<tipo>(<ámbito>): <descripción>
```

**Tipos comunes**:

- `feat`: Nueva característica
- `fix`: Corrección de bug
- `docs`: Cambios en documentación
- `style`: Cambios de formato (indentación, espacios, etc.)
- `refactor`: Refactorización de código
- `test`: Añadir o modificar tests
- `chore`: Tareas de mantenimiento, cambios en build, etc.

**Ejemplos**:

```
feat(auth): implementar autenticación con Google

fix(api): corregir error 500 en endpoint de usuarios

docs(readme): actualizar instrucciones de instalación
```

**Recomendaciones**:

- Usar verbo en imperativo presente: "add", "fix", "update", no "added",
  "fixed", "updated"
- Primera línea menor a 72 caracteres
- Describir el "qué" y el "por qué", no el "cómo"
- Referenciar issues o tickets cuando sea relevante

### Contenido de un commit

**Principios para buenos commits**:

1. **Atómicos**: Cada commit debe representar un cambio lógico único.
2. **Completos**: El commit debe dejar el código en un estado funcional.
3. **Separados por propósito**: Separar refactorizaciones de nuevas
   características.
4. **Consistentes**: No mezclar múltiples características o correcciones no
   relacionadas.

**Qué incluir**:

- Cambios relacionados entre sí
- Tests que verifican los cambios
- Documentación relevante

**Qué evitar**:

- Cambios no relacionados
- Archivos temporales o de configuración personal
- Código comentado
- Archivos de build o dependencias (usar .gitignore)

**Ejemplo de proceso**:

```bash
# Revisar qué archivos han cambiado
git status

# Ver diferencias para asegurarte de incluir solo lo relevante
git diff

# Añadir archivos relacionados a un mismo cambio
git add src/components/Login.js src/styles/Login.css

# Hacer commit con mensaje descriptivo
git commit -m "feat(auth): implementar formulario de login"

# Luego, en un commit separado, añadir otra característica
git add src/utils/validation.js
git commit -m "feat(validation): añadir validación de campos de formulario"
```

Siguiendo estos principios, mantendrás un historial de Git limpio, comprensible
y útil para todo el equipo.

### Rebase local branches

### tags
