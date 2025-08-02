/// Dart Frog integration for Nest Dart - bringing dependency injection and modular architecture to Dart Frog backend applications.
///
/// This library provides Dart Frog-specific middleware and utilities for the Nest Dart framework,
/// and re-exports all core functionality from nest_core for convenience.
library;

// Re-export nest_core for convenience
export 'package:nest_core/nest_core.dart';

// Export Dart Frog-specific functionality
export 'src/nest_frog.dart';
export 'src/middleware.dart';
