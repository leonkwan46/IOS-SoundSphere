# SoundSphere iOS App

SoundSphere is a modern iOS application built with SwiftUI that provides an immersive audio experience. The app follows the MVVM (Model-View-ViewModel) architecture pattern and is designed with a clean, modular structure.

# ⚠️ Project Status  
> **🚨 Important:**  
> I've decided to pivot away from the SoundSphere iOS app. While the initial idea was to leverage SwiftUI for a polished, native experience, I've realised that my priority is to ship the product faster, which requires focusing on familiar technologies rather than learning a new stack. This will allow me to deliver value to users more quickly and iterate on feedback efficiently.

## Features

- Modern SwiftUI-based user interface
- MVVM architecture for clean separation of concerns
- Modular design with reusable components
- Audio services integration (future feature)

## Project Structure

```
SoundSphere/
├── Main/           # Main app entry point and core setup
├── View/           # SwiftUI views and UI components
├── ViewModel/      # View models for business logic
├── Model/          # Data models and entities
├── Services/       # Service layer for external integrations
├── Theme/          # UI theming and styling
├── Navigation/     # Navigation-related components
├── Utils/          # Utility functions and helpers
├── Shared/         # Shared components and extensions
├── Config/         # Configuration files
└── Assets.xcassets # App assets and resources
```

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Views**: SwiftUI views in the View directory
- **ViewModels**: Business logic and state management in the ViewModel directory
- **Models**: Data models and entities in the Model directory
