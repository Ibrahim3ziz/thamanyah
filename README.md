# Thamanyah - Audio Content Discovery App

## 📱 Project Overview

**Thamanyah** is an iOS application designed to help users discover and explore audio content including podcasts, audiobooks, episodes, and audio articles. The app features a dynamic home screen with multiple section types and a powerful search functionality, providing an engaging and intuitive user experience for audio content enthusiasts.

### Key Features

- **Dynamic Home Feed**: Displays content organized in multiple section types (Queue, Square, Two-Column Grid, Big Square)
- **Pagination Support**: Infinite scrolling for home sections with automatic loading of additional content
- **Hybrid UI Approach**: Combines SwiftUI for the main interface with UIKit for search functionality
- **Advanced Search**: Real-time search with debouncing and categorized results
- **Clean Architecture**: Implements Clean Architecture principles with clear separation of concerns
- **Comprehensive Testing**: Unit tests for ViewModels and Use Cases
- **Network Abstraction**: Custom NetworkKit framework for API communication
- **Modern Swift**: Utilizes Combine framework for reactive programming

---

## 🏗️ Architecture

The project follows **Clean Architecture** principles with clear separation into layers:

### Layers

```
┌─────────────────────────────────────┐
│     Presentation Layer              │
│  (Views, ViewModels, ViewControllers)│
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│        Domain Layer                 │
│   (Use Cases, Entities, Protocols)  │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Data Layer                  │
│   (Repositories, Network Targets)   │
└─────────────────────────────────────┘
```

### Layer Details

#### 1. **Presentation Layer**
- **SwiftUI Views**: `HomeView` - Main content feed with multiple section types
- **UIKit ViewControllers**: `SearchViewController` - Search interface with table view
- **ViewModels**: 
  - `HomeViewModel` - Manages home screen state and pagination
  - `SearchViewModel` - Handles search queries with debouncing
- **UI Components**:
  - `BigSquareCardView` - Large square content cards
  - `SearchContentCell` - Search result cells
  - `SearchEmptyStateView` - Empty state handling
  - Section views for different layout types

#### 2. **Domain Layer**
- **Use Cases**:
  - `HomeUseCase` - Business logic for fetching home content
  - `SearchUseCase` - Business logic for search operations
- **Entities**:
  - `HomeEntity`, `HomeSectionEntity` - Domain models for home content
  - `SearchEntity`, `SearchSectionEntity`, `SearchContentEntity` - Domain models for search
- **Protocols**: Define contracts between layers (`HomeUseCaseProtocol`, `SearchUseCaseProtocol`)

#### 3. **Data Layer**
- **Repositories**:
  - `HomeRepo` - Data source for home content
  - `SearchRepo` - Data source for search results
- **Network Targets**:
  - `HomeTarget` - API endpoint configuration for home feed
  - `SearchTarget` - API endpoint configuration for search
- **DTOs**: Data Transfer Objects for API responses

---

## 🎯 Technical Approach

### 1. **Hybrid UI Framework**

The app strategically uses both SwiftUI and UIKit:

- **SwiftUI** for the home screen:
  - Declarative syntax for complex layouts
  - Easier handling of dynamic sections
  - Native support for lazy loading
  - Better performance for scrollable content

- **UIKit** for search:
  - `UISearchController` integration
  - Table view for search results
  - More control over keyboard and search bar behavior
  - Bridged to SwiftUI via `UIViewControllerRepresentable`

### 2. **Reactive Programming with Combine**

- All ViewModels use `@Published` properties for state management
- Network requests return `AnyPublisher` for composable async operations
- Search query debouncing (200ms) to reduce unnecessary API calls
- Automatic cancellation of previous searches

### 3. **Clean Architecture Benefits**

- **Testability**: Each layer can be tested independently
- **Maintainability**: Clear separation of concerns
- **Scalability**: Easy to add new features without affecting existing code
- **Flexibility**: Can swap implementations (e.g., mock data for testing)

### 4. **Pagination Strategy**

```swift
// Trigger pagination when last section appears
.onAppear {
    if section.id == viewModel.sections.last?.id {
        viewModel.loadMore()
    }
}
```

- Automatic loading when user scrolls to the last section
- Prevents duplicate requests with `isLoadingMore` flag
- Tracks current page and total pages
- Appends new content to existing sections

### 5. **Network Layer Abstraction**

Custom `NetworkKit` framework provides:
- Protocol-based network service (`NetworkServiceProtocol`)
- Generic request execution
- Centralized error handling (`NetworkError`)
- Type-safe API targets (`BaseRequest` protocol)

---

## 🧪 Testing Strategy

### Test Coverage

1. **ViewModel Tests**
   - `HomeViewModelTests`: Tests pagination, error handling, state management
   - `SearchViewModelTests`: Tests search debouncing, error states, query handling

2. **Use Case Tests**
   - `HomeUseCaseTests`: Tests data transformation from DTO to Entity
   - `SearchUseCaseTests`: Tests search logic and entity mapping

3. **Mock Objects**
   - `MockHomeUseCase`: Simulates home data fetching
   - `MockSearchUseCase`: Simulates search operations
   - `MockNetworkService`: Simulates network responses

### Test Principles
- Async testing with Combine and `XCTestExpectation`
- Clear Given-When-Then structure
- Independent test cases with proper setup/teardown
- Edge case coverage (empty results, errors, pagination boundaries)

---

## 📁 Project Structure

```
thamanyah/
├── App/
│   └── thamanyahApp.swift                  # App entry point
│
├── Presentation/
│   ├── Home/
│   │   ├── HomeView.swift                  # Main home screen
│   │   ├── HomeViewModel.swift             # Home screen logic
│   │   └── Components/
│   │       ├── BigSquareCardView.swift     # Card components
│   │       └── [Other section views]
│   │
│   └── Search/
│       ├── SearchViewController.swift       # UIKit search screen
│       ├── SearchViewModel.swift            # Search logic
│       ├── SearchViewControllerRepresentable.swift
│       └── Components/
│           ├── SearchContentCell.swift      # Search result cells
│           └── SearchEmptyStateView.swift   # Empty states
│
├── Domain/
│   ├── UseCases/
│   │   ├── HomeUseCase.swift               # Home business logic
│   │   └── SearchUseCase.swift             # Search business logic
│   │
│   └── Entities/
│       ├── HomeEntity.swift                # Home domain models
│       └── SearchEntity.swift              # Search domain models
│
├── Data/
│   ├── Repositories/
│   │   ├── HomeRepository.swift            # Home data source
│   │   └── SearchRepo.swift                # Search data source
│   │
│   └── Network/
│       ├── Targets/
│       │   ├── HomeTarget.swift            # Home API config
│       │   └── SearchTarget.swift          # Search API config
│       │
│       └── NetworkServiceProtocol.swift
│
├── Utilities/
│   ├── Extensions/
│   │   ├── Font+Extensions.swift
│   │   └── AsyncImage+SwiftUI.swift
│   │
│   └── Modifiers/
│       └── ShimmerModifier.swift
│
└── Tests/
    ├── ViewModelTests/
    ├── UseCaseTests/
    └── Mocks/
```

---

## 🔧 Key Technologies

- **Language**: Swift 5.x
- **UI Frameworks**: SwiftUI, UIKit
- **Reactive Programming**: Combine
- **Architecture Pattern**: Clean Architecture (MVVM + Use Cases)
- **Networking**: Custom NetworkKit framework
- **Testing**: XCTest
- **Dependency Management**: (Framework dependencies)
- **Minimum iOS Version**: iOS 15.0+

---

## 🚀 Getting Started

### Prerequisites
- Xcode 14.0+
- iOS 15.0+ deployment target
- Swift 5.x

### Installation

1. Clone the repository:
```bash
git clone [repository-url]
cd thamanyah
```

2. Open the project:
```bash
open thamanyah.xcodeproj
```

3. Build and run:
- Select a simulator or device
- Press `Cmd + R` to build and run

### Running Tests

```bash
# Run all tests
Cmd + U

# Or via command line
xcodebuild test -scheme thamanyah -destination 'platform=iOS Simulator,name=iPhone 15'
```

---

## 💡 Implementation Approach

### Problem-Solving Strategy

1. **Requirements Analysis**
   - Identified need for dynamic content sections
   - Recognized importance of search functionality
   - Understood pagination requirements

2. **Architecture Design**
   - Chose Clean Architecture for maintainability
   - Separated concerns into distinct layers
   - Created protocols for dependency inversion

3. **Technology Selection**
   - SwiftUI for main UI (modern, declarative)
   - UIKit for search (better integration with UISearchController)
   - Combine for reactive state management

4. **Implementation Order**
   - Network layer (foundation)
   - Domain models and use cases
   - ViewModels with business logic
   - UI components and views
   - Testing infrastructure

5. **Iterative Refinement**
   - Started with basic functionality
   - Added error handling
   - Implemented pagination
   - Polished UI/UX
   - Added comprehensive tests

---

## 🎨 UI/UX Decisions

### Design Patterns

1. **Section Types**
   - Queue: Horizontal scrolling cards
   - Square: Grid of square items
   - Two-Column Grid: Vertical grid layout
   - Big Square: Large featured content

2. **Loading States**
   - Shimmer effects during initial load
   - Progress indicators for pagination
   - Empty states with helpful messages

3. **Search Experience**
   - Real-time search with debouncing
   - Clear empty states (initial, no results, error)
   - Grouped results by section
   - Smooth animations and transitions

---

## 🚧 Challenges & Solutions

### 1. **Hybrid UI Framework Integration**

**Challenge**: Integrating UIKit search controller into SwiftUI app

**Solution**: 
- Created `SearchViewControllerRepresentable` conforming to `UIViewControllerRepresentable`
- Properly managed lifecycle and state synchronization
- Used `@StateObject` for ViewModel to maintain state

### 2. **Pagination Logic**

**Challenge**: Preventing duplicate requests and managing state during pagination

**Solution**:
- Implemented `isLoadingMore` flag to prevent concurrent requests
- Used `onAppear` modifier on last section to trigger loading
- Tracked `currentPage` and `totalPages` for boundary conditions
- Appended new sections rather than replacing them

### 3. **Search Debouncing**

**Challenge**: Avoiding excessive API calls while typing

**Solution**:
```swift
$searchQuery
    .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
    .removeDuplicates()
    .sink { [weak self] query in
        self?.performSearch(query: query)
    }
```

### 4. **Error Handling**

**Challenge**: Gracefully handling network failures at different layers

**Solution**:
- Custom `NetworkError` type with specific error cases
- Error propagation through Combine publishers
- User-friendly error messages in UI
- Retry mechanisms where appropriate

### 5. **Testing Async Code**

**Challenge**: Testing Combine publishers and async operations

**Solution**:
- Used `XCTestExpectation` for async assertions
- Created mock use cases with controllable responses
- Proper setup/teardown to prevent test pollution
- Tested both success and failure paths

### 6. **State Management**

**Challenge**: Managing complex state across views and navigation

**Solution**:
- Used `@Published` properties for reactive updates
- Single source of truth in ViewModels
- Proper dependency injection for testability
- Clear state transitions (loading → loaded/error)

---

## 🔮 Future Improvements

1. **Caching Strategy**
   - Implement local caching for home sections
   - Cache images for offline viewing
   - Use Core Data or Realm for persistence

2. **Enhanced Error Recovery**
   - Automatic retry with exponential backoff
   - Offline mode detection
   - Better error messages with actionable suggestions

3. **Performance Optimization**
   - Image loading optimization with caching
   - Lazy loading for section content
   - Memory management for large lists

4. **Search Enhancements**
   - Search history
   - Search suggestions
   - Advanced filters (language, duration, category)
   - Recent searches

5. **Analytics & Monitoring**
    - User behavior tracking
    - Crash reporting
    - Performance monitoring
    - A/B testing infrastructure

---

## 📊 API Endpoints

### Home Feed
```
GET https://api-v2-b2sit6oh3a-uc.a.run.app/home_sections
Query Parameters:
  - page: Int (pagination)
```

### Search
```
GET https://mock.apidog.com/m1/735111-711675-default/search
Query Parameters:
  - query: String (search term)
```

---

## 🧩 Dependencies

- **NetworkKit**: Custom networking framework
- **Combine**: Reactive programming
- **Foundation**: Core Swift functionality
- **SwiftUI**: Declarative UI framework
- **UIKit**: Search interface components

---

## 👨‍💻 Development Notes

### Code Style
- Swift naming conventions
- Protocol-oriented programming
- Value types preferred over reference types where appropriate
- Explicit type annotations for clarity
- Comprehensive documentation

### Best Practices
- Dependency injection for testability
- Protocol-based abstractions
- Single Responsibility Principle
- Separation of concerns
- Comprehensive error handling

---

## 🙏 Acknowledgments

- Clean Architecture principles by Robert C. Martin
- SwiftUI and Combine best practices from Apple documentation
- iOS development community for inspiration and guidance

---
