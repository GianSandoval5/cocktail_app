<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Material%20Design-757575?style=for-the-badge&logo=material-design&logoColor=white" alt="Material Design">
</div>

# 🍹 Cocktail Master App

<div align="center">
  <h3>La aplicación definitiva para explorar el mundo de los cócteles</h3>
  <p><em>Descubre, aprende y disfruta de miles de recetas de cócteles con una experiencia visual excepcional</em></p>
  
  <img src="https://img.shields.io/badge/version-1.0.0-blue?style=flat-square" alt="Version">
  <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="License">
  <img src="https://img.shields.io/badge/platform-iOS%20%7C%20Android-lightgrey?style=flat-square" alt="Platform">
</div>

---

## ✨ Características Destacadas

### 🎨 **Diseño Premium**
- **Material Design 3**: Interfaz moderna y elegante con animaciones fluidas
- **Animaciones Avanzadas**: Transiciones suaves, efectos de escalado y animaciones de entrada escalonadas
- **Modo Responsivo**: Adaptación perfecta a diferentes tamaños de pantalla
- **Tema Personalizado**: Paleta de colores ámbar con gradientes y sombras profesionales

### 🔍 **Búsqueda Inteligente**
- **Búsqueda Múltiple**: Por nombre, ingrediente o primera letra
- **Resultados Instantáneos**: API calls optimizadas con indicadores de carga
- **Filtros Avanzados**: Navegación por categorías y tipos de bebida
- **Autocompletado Visual**: Sugerencias contextuales según el tipo de búsqueda

### 📱 **Experiencia de Usuario Superior**
- **Carga Inteligente**: Los detalles completos se cargan automáticamente cuando faltan
- **Caché de Imágenes**: Rendimiento optimizado con `cached_network_image`
- **Estados de Carga**: Indicadores visuales elegantes durante las operaciones
- **Manejo de Errores**: Fallbacks informativos y mensajes de error descriptivos

### 🌟 **Funcionalidades Avanzadas**
- **Cóctel Aleatorio**: Descubre nuevas recetas con animaciones sorpresa
- **Sistema de Favoritos**: Guarda y gestiona tus cócteles preferidos
- **Detalles Completos**: Ingredientes, instrucciones, tipo de vaso y categorización
- **Imágenes HD**: Visualización de alta calidad para cócteles e ingredientes

---

## � Tecnologías y Arquitectura

### **Stack Tecnológico**
```yaml
Frontend: Flutter 3.24+ / Dart 3.5+
UI/UX: Material Design 3
HTTP Client: http ^1.1.0
Image Caching: cached_network_image ^3.3.0
Internationalization: flutter_localizations + intl ^0.20.2
API: TheCocktailDB REST API
```

### **Patrones de Diseño**
- **StatefulWidget**: Gestión avanzada de estado con múltiples controladores de animación
- **Future/Async**: Programación asíncrona para llamadas a API
- **AnimationController**: Animaciones complejas con múltiples transiciones
- **Hero Widgets**: Transiciones compartidas entre pantallas

### **Arquitectura de la App**
```
lib/
├── 📱 main.dart                 # Configuración principal y tema
├── 📊 models/
│   └── cocktail.dart           # Modelos de datos tipados
├── 🌐 services/
│   └── cocktail_service.dart   # Cliente API con manejo de errores
├── 🖥️ screens/
│   ├── home_screen.dart        # Navegación principal
│   ├── search_screen.dart      # Búsqueda avanzada
│   ├── categories_screen.dart  # Exploración por categorías
│   ├── random_screen.dart      # Cóctel aleatorio
│   ├── favorites_screen.dart   # Gestión de favoritos
│   └── cocktail_detail_screen.dart # Detalles con carga inteligente
└── 🧩 widgets/
    └── cocktail_card.dart      # Componentes reutilizables animados
```

---

## 🎯 API Integration

### **TheCocktailDB API**
Integración completa con la API más completa de cócteles disponible:

| Endpoint | Funcionalidad | Implementación |
|----------|---------------|----------------|
| `search.php?s={name}` | Búsqueda por nombre | ✅ Con validación |
| `search.php?f={letter}` | Búsqueda alfabética | ✅ Con filtro de letra única |
| `search.php?i={ingredient}` | Búsqueda de ingredientes | ✅ Con autocompletado |
| `lookup.php?i={id}` | Detalles completos | ✅ **Carga automática inteligente** |
| `random.php` | Cóctel aleatorio | ✅ Con animaciones |
| `filter.php?i={ingredient}` | Filtro por ingrediente | ✅ Con resolución de detalles |
| `filter.php?c={category}` | Filtro por categoría | ✅ Con iconos personalizados |
| `list.php?c=list` | Lista de categorías | ✅ Con mapeo de iconos |

### **🔧 Características Técnicas Avanzadas**
- **Resolución Automática**: Cuando un cóctel tiene datos incompletos (común en búsquedas por ingrediente), la app automáticamente obtiene los detalles completos
- **Caché Inteligente**: Las imágenes se cachean localmente para acceso offline
- **Manejo de Estados**: Loading, error y estados vacíos con UI específica
- **Localización**: Textos en español con formato de fecha/hora local

---

## 📋 Instalación y Configuración

### **Prerrequisitos**
- Flutter SDK 3.24.0 o superior
- Dart SDK 3.5.0 o superior
- Android Studio / VS Code con extensiones de Flutter
- Dispositivo/emulador iOS o Android

### **🛠️ Instalación Paso a Paso**

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/GianSandoval5/cocktail_app.git

   cd cocktail_app
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Verificar instalación**
   ```bash
   flutter doctor
   ```

4. **Ejecutar en modo desarrollo**
   ```bash
   flutter run
   ```

5. **Build para producción**
   ```bash
   # Android
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   ```

---

## 🎨 Capturas de Pantalla y Características

### **🏠 Pantalla Principal**
- Navegación por pestañas con indicadores animados
- Transiciones suaves entre secciones
- Tema coherente en toda la aplicación

### **🔍 Búsqueda Avanzada**
- Segmented buttons para diferentes tipos de búsqueda
- Campo de texto con sugerencias contextuales
- Grid responsivo con animaciones de entrada escalonadas
- Estados vacíos informativos y atractivos

### **📂 Exploración por Categorías**
- Lista de categorías con iconos personalizados
- Animaciones de carga y transición
- Contador de cócteles por categoría
- Navegación fluida entre categorías y resultados

### **🎲 Cóctel Aleatorio**
- Animaciones de sorpresa con efectos de escalado
- Información resumida con opción de ver detalles
- Botón flotante para obtener otro cóctel
- Transiciones Hero entre pantallas

### **❤️ Sistema de Favoritos**
- Gestión local de cócteles favoritos
- Animaciones de agregar/quitar favoritos
- Estado vacío elegante con call-to-action
- Grid consistente con otras pantallas

### **� Detalles del Cóctel**
- **SliverAppBar** expandible con imagen del cóctel
- **Carga Inteligente**: Obtiene automáticamente detalles faltantes
- Chips informativos con traducciones al español
- Lista detallada de ingredientes con imágenes
- Instrucciones de preparación formateadas
- Animaciones de contenido con fade y slide

---

## 🌐 Internacionalización

### **Soporte Multiidioma**
- **Español (es_ES)**: Idioma principal con localizaciones completas
- **Formato de Fecha**: Adaptado al formato español
- **Traducciones Contextuales**: 
  - "Alcoholic" → "Con alcohol"
  - "Non Alcoholic" → "Sin alcohol"
  - Mensajes de error y estado en español

---

## 🚀 Optimizaciones de Rendimiento

### **� Optimizaciones Implementadas**
- **Lazy Loading**: Carga de imágenes bajo demanda
- **Image Caching**: Caché persistente de imágenes
- **Animation Controllers**: Gestión eficiente de memoria para animaciones
- **API Call Optimization**: Evita llamadas duplicadas innecesarias
- **State Management**: Gestión eficiente del estado de la aplicación

### **📊 Métricas de Rendimiento**
- Tiempo de inicio: < 3 segundos
- Carga de imágenes: Progresiva con placeholders
- Uso de memoria: Optimizado con dispose automático
- Tamaño de la app: ~15MB (release build)

---

## 🔮 Roadmap Futuro

### **🎯 Versión 1.1 (Próximamente)**
- [ ] **🌙 Modo Oscuro**: Tema dark completo
- [ ] **💾 Persistencia Local**: SQLite para favoritos offline
- [ ] **🔍 Búsqueda Avanzada**: Múltiples ingredientes simultáneos
- [ ] **⭐ Sistema de Calificaciones**: Puntuación personal de cócteles

### **🎯 Versión 1.2 (Futuro)**
- [ ] **📱 Compartir**: Share de recetas en redes sociales
- [ ] **🛒 Lista de Compras**: Generación automática de ingredientes
- [ ] **⏱️ Temporizador**: Para preparación paso a paso
- [ ] **🎥 Videos**: Integración con videos de preparación

### **🎯 Versión 2.0 (Visión a Largo Plazo)**
- [ ] **🤖 IA Recommendation**: Sugerencias basadas en preferencias
- [ ] **👥 Social Features**: Comunidad de bartenders
- [ ] **📊 Analytics**: Estadísticas de uso personal
- [ ] **🎨 Themes**: Múltiples temas visuales

---

## 🤝 Contribución

### **💡 Cómo Contribuir**
1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

### **📝 Guías de Contribución**
- Mantén el estilo de código consistente
- Añade tests para nuevas funcionalidades
- Actualiza la documentación según corresponda
- Respeta las convenciones de nomenclatura

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE.md](LICENSE.md) para más detalles.

---

## 🙏 Agradecimientos

- **[TheCocktailDB](https://www.thecocktaildb.com/)** - Por proporcionar la API gratuita más completa de cócteles
- **[Flutter Team](https://flutter.dev/)** - Por el increíble framework multiplataforma
- **[Material Design](https://material.io/)** - Por las guías de diseño y componentes

---

<div align="center">
  <h3>🍹 ¡Salud! Disfruta explorando el mundo de los cócteles 🍹</h3>
  <p><em>Hecho con ❤️ y mucho Flutter por Gian Sandoval</em></p>
  
  <a href="#top">⬆️ Volver arriba</a>
</div>
