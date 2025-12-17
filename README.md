# Next Organics - Flutter Grocery Delivery App

A production-ready grocery delivery mobile app built with Flutter following clean architecture principles.

## Features

✅ **Product Browsing**

- Home screen with banner carousel
- Category-based navigation
- Product grid with search
- Product details with Hero animations

✅ **Shopping Cart**

- Add/remove products
- Update quantities
- Swipe-to-delete
- Price calculations with tax

✅ **User Experience**

- Smooth animations (Hero, AnimatedContainer, AnimatedSwitcher)
- Haptic feedback
- Light/Dark theme toggle
- Empty states
- Loading indicators

✅ **Search & Discovery**

- Live search filtering
- Category filtering
- Popular search suggestions

## Tech Stack

**Framework:** Flutter (Dart)  
**State Management:** Riverpod  
**Routing:** GoRouter  
**Architecture:** Clean Architecture (UI → State → Domain → Data)  
**Design:** Custom widgets, ThemeData, Google Fonts  
**Animations:** Hero, AnimatedContainer, AnimatedOpacity, AnimatedSwitcher  
**Images:** cached_network_image

## Project Structure

```
lib/
├── core/
│   ├── theme/          # App colors, typography, theme
│   ├── router/         # GoRouter configuration
│   ├── widgets/        # Shared widgets (bottom nav, product card, etc.)
│   └── providers/      # Theme provider
├── features/
│   ├── onboarding/     # Onboarding screens
│   ├── home/           # Home screen with banners
│   ├── products/       # Product listing & details
│   ├── cart/           # Shopping cart
│   ├── search/         # Search functionality
│   └── profile/        # User profile & settings
└── main.dart           # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK

### Installation

1. **Install dependencies:**

   ```bash
   flutter pub get
   ```

2. **Run the app:**

   ```bash
   flutter run
   ```

3. **Build for production:**

   ```bash
   # Android
   flutter build apk --release

   # iOS
   flutter build ios --release
   ```

## Features Overview

### Clean Architecture

- **Domain Layer:** Entities and repository interfaces
- **Data Layer:** Mock data sources and repository implementations
- **Presentation Layer:** Riverpod providers and UI screens

### Mock Data

Currently uses mock data for all products, categories, and banners. The repository pattern makes it easy to swap in a real backend later.

### Animations

- **Hero Animations:** Product images transition smoothly between screens
- **Micro-animations:** Button states, cart badge updates
- **Haptic Feedback:** Light impacts on interactions
- **Smooth Transitions:** Page transitions with custom curves

## Backend Integration (Future)

The app is architected to easily connect to a REST API:

1. Replace mock data sources with API clients
2. Add authentication provider
3. Implement real-time updates
4. Add payment gateway integration

## License

This project is for demonstration purposes.
