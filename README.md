# TaskBoard - Aplicación de Gestión de Tareas

## Descripción
TaskBoard es una aplicación móvil desarrollada en Flutter que permite gestionar tareas de manera eficiente, con funcionalidades de crear, editar, marcar como completadas y filtrar tareas.

## Características Implementadas

### Funcionalidades Principales
- ✅ Lista de tareas con título, descripción y estado
- ✅ Agregar nueva tarea con validación de formulario
- ✅ Editar tareas existentes
- ✅ Marcar tareas como completadas/pendientes
- ✅ Filtros: Todas, Pendientes, Completadas
- ✅ Persistencia local con SQL Lite
- ✅ Búsqueda por título (extra)
- ✅ Pantalla de detalles de tarea (extra)
- ✅ Animaciones al agregar/eliminar (extra)
- ✅ Pruebas unitarias y de widget (extra)

### Arquitectura y Buenas Prácticas
- Arquitectura por capas (models, screens, widgets, services)
- Manejo de estado con Provider
- Código limpio y organizado
- Widgets reutilizables
- Manejo adecuado de asincronía
- Validación de formularios
- Diseño responsivo

## Requisitos Técnicos

- Flutter 3.x o superior
- Dart SDK 3.0+
- Android Studio, VS Code o IntelliJ IDEA
- Emulador o dispositivo físico


## Instalación y Ejecución

### 1. Clonar el repositorio
```bash
git clone 
cd task_board
```

### 2. Instalar dependencias
```bash
flutter pub get
```

### 3. Ejecutar la aplicación
```bash
flutter run
```

### 4. Ejecutar pruebas
```bash
flutter test
```

## Funcionalidades Detalladas

### Pantalla Principal (Home)
- Lista de todas las tareas
- Barra de búsqueda
- Filtros por estado (Todas/Pendientes/Completadas)
- Botón flotante para agregar nueva tarea
- Swipe para eliminar tareas
- Tap para ver detalles

### Formulario de Tarea
- Campo título (obligatorio)
- Campo descripción (opcional)
- Validación en tiempo real
- Guardado automático con persistencia
- Modo creación y edición

### Detalles de Tarea
- Vista completa de la información
- Botón para editar
- Botón para eliminar
- Toggle de estado completado

### Filtros y Búsqueda
- Filtro por estado (All/Pending/Completed)
- Búsqueda en tiempo real por título
- Combinación de filtros y búsqueda

## Decisiones de Diseño

### 1. Manejo de Estado
Se utilizó Provider por:
- Simplicidad y curva de aprendizaje suave
- Integración nativa con Flutter
- Excelente rendimiento
- Código boilerplate mínimo

### 2. Persistencia

Se utilizó **SQLite** como mecanismo de almacenamiento local debido a que permite manejar datos estructurados de forma eficiente dentro de la aplicación.


### 3. UI/UX
- Material Design 3
- Colores consistentes
- Animaciones suaves
- Feedback visual al usuario
- Diseño responsivo

## Pruebas Implementadas

### Pruebas Unitarias
- TaskDAO: operaciones de base de datos (insertar, obtener, actualizar y eliminar tareas)
- Modelo Task: serialización y deserialización de datos

### Pruebas de Widget
- TaskListItem: renderizado correcto de cada tarea en la lista


## Notas de Implementación

### Manejo de Errores
- Try-catch en operaciones de persistencia
- Mensajes de error al usuario mediante SnackBar
- Validación de datos antes de guardar

### Performance
- ListView.builder para listas eficientes
- Const constructors donde es posible
- Evitar rebuilds innecesarios



## Licencia

Este proyecto es una prueba técnica para evaluación de conocimientos en Flutter.




