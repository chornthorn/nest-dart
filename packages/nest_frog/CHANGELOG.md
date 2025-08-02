# Changelog

All notable changes to the `nest_frog` package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-08-02

### Added
- **Dart Frog middleware integration** with nestFrogMiddleware
- **Unified Modular API** for backend service access
- **Request context service resolution** with ModularContext
- **Automatic container initialization** in middleware
- **Fallback service access** from global container
- **Testing utilities** for backend service testing
- **Error handling** with proper exception management

### Features
- nestFrogMiddleware for automatic dependency injection setup
- Modular class with static methods for service access
- ModularContext for request-scoped service resolution
- Support for both context-based and direct service access
- Seamless integration with Dart Frog's middleware system
- Proper container lifecycle management
- Testing support with container reset functionality

### Middleware Integration
- Automatic container initialization on first request
- Efficient service resolution with minimal overhead
- Proper error handling and service validation
- Support for nested middleware chains

### API Design
- Clean, intuitive API similar to other Nest Dart packages
- Consistent service access patterns
- Type-safe service resolution
- Comprehensive error messages

### Documentation
- Complete Dart Frog integration guide
- REST API examples with authentication
- Testing patterns and utilities
- Performance optimization tips

This is the initial release of nest_frog, providing seamless integration between Nest Dart's dependency injection system and Dart Frog's backend framework.