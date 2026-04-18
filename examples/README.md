# Ejemplos — argo-web

Esta carpeta contiene implementaciones de referencia del workflow completo.

## Estructura de un ejemplo

```
examples/
└── <nombre-ejemplo>/
    ├── design/
    │   └── screens/
    │       └── <pantalla>/
    │           ├── 01-pencil.pen
    │           ├── 02-approval.md
    │           ├── 03-flow-ascii.md
    │           ├── 04-components.md
    │           ├── 05-db-model.md
    │           └── 06-motion-plan.md
    └── src/
        └── <componentes implementados>
```

## Cómo contribuir un ejemplo

1. Crear la carpeta `examples/<nombre>/`
2. Completar TODA la documentación antes del código
3. El código debe ser 1:1 con el diseño
4. PR con ambas cosas: diseño + implementación
