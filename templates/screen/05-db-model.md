# Modelo BDA — [ Nombre de Pantalla ]

**Pantalla:** `[ screen-slug ]`  
**Fecha:** YYYY-MM-DD

> Si la pantalla no consume datos, marcar la sección como **N/A**.

---

## Estado: [ Completo | En progreso | N/A ]

---

## Tablas Involucradas

| Tabla | Operación | Campos leidos | Campos escritos |
|-------|-----------|---------------|-----------------|
| `[ tabla ]` | SELECT | `id, name, status` | — |
| `[ tabla ]` | INSERT | — | `name, created_at` |

---

## Queries Principales

```sql
-- Query 1: Descripción
SELECT ...
FROM ...
WHERE ...;

-- Query 2: Descripción
```

---

## API Endpoints Consumidos

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| GET | `/api/[ ]` | [ ] | JWT |
| POST | `/api/[ ]` | [ ] | JWT |

---

## Permisos y Roles

| Rol | Acción permitida |
|-----|------------------|
| `admin` | CRUD completo |
| `user` | Solo lectura |
| `guest` | Sin acceso |

---

## Diagrama de Relaciones

```
[ tabla_a ] ────▶ [ tabla_b ]
    |                  |
    ▼                  ▼
[ tabla_c ]       [ tabla_d ]
```
