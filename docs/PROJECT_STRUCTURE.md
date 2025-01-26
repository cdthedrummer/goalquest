# Project Structure

## Directory Layout

```
lib/
├── app/
│   ├── app.dart
│   └── theme.dart
├── core/
│   ├── constants/
│   ├── errors/
│   └── utils/
├── features/
│   ├── quiz/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── character/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── goals/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/
│   ├── widgets/
│   ├── models/
│   └── services/
└── main.dart
```

## Feature Organization

Each feature follows Clean Architecture principles:

### Data Layer
- Repositories
- Data sources
- Models
- DTOs

### Domain Layer
- Entities
- Use cases
- Repository interfaces
- Value objects

### Presentation Layer
- Screens
- Widgets
- View models
- State management

## State Management

Using Riverpod for state management:
- StateNotifier for complex state
- ChangeNotifier for simple state
- Provider for dependency injection

## Navigation

Using Go Router for navigation:
- Type-safe routes
- Deep linking support
- Path parameters
- Nested navigation

## Shared Components

Common widgets and utilities:
- Custom buttons
- Loading indicators
- Error handlers
- Text styles
- Color schemes
- Animations