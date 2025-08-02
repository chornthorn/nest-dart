// import 'package:my_project/core/core.dart';
// import 'package:my_project/modules/core_module.dart';
// import 'package:my_project/modules/user_module.dart';

// void main() async {
//   print('🎯 Dart Frog + NestJS-like Module System Demo');
//   print('=' * 50);

//   try {
//     // Initialize the container
//     Modular.initialize();
//     print('✅ Application container initialized\n');

//     // Get services
//     final config = Modular.get<ConfigService>();
//     final userService = Modular.get<UserService>();

//     print('📋 Application Info:');
//     print('   App Name: ${config.appName}');
//     print('   Version: ${config.version}');
//     print('   Environment: ${config.environment}');
//     print('   Database: ${config.databaseType}');
//     print('   Port: ${config.port}\n');

//     // Demo CRUD operations
//     print('👥 User Management Demo:');

//     // List all users
//     print('\n1. Listing all users:');
//     var users = userService.getAllUsers();
//     for (final user in users) {
//       print('   - ${user.name} (${user.email})');
//     }
//     print('   Total: ${users.length} users');

//     // Get specific user
//     print('\n2. Getting user by ID (2):');
//     final user2 = userService.getUserById(2);
//     if (user2 != null) {
//       print('   Found: ${user2.name} (${user2.email})');
//     }

//     // Create new user
//     print('\n3. Creating new user:');
//     final newUser = userService.createUser(
//       'Charlie Wilson',
//       'charlie@example.com',
//     );
//     if (newUser != null) {
//       print(
//         '   Created: ${newUser.name} (${newUser.email}) - ID: ${newUser.id}',
//       );
//     }

//     // List users again
//     print('\n4. Updated user list:');
//     users = userService.getAllUsers();
//     for (final user in users) {
//       print('   - ${user.name} (${user.email})');
//     }
//     print('   Total: ${users.length} users');

//     // Update user
//     print('\n5. Updating user (ID: 5):');
//     final updated = userService.updateUser(
//       5,
//       name: 'Charles Wilson',
//       email: 'charles@example.com',
//     );
//     if (updated) {
//       print('   ✅ User updated successfully');
//       final updatedUser = userService.getUserById(5);
//       if (updatedUser != null) {
//         print('   Updated: ${updatedUser.name} (${updatedUser.email})');
//       }
//     }

//     // Delete user
//     print('\n6. Deleting user (ID: 3):');
//     final deleted = userService.deleteUser(3);
//     if (deleted) {
//       print('   ✅ User deleted successfully');
//     }

//     // Final list
//     print('\n7. Final user list:');
//     users = userService.getAllUsers();
//     for (final user in users) {
//       print('   - ${user.name} (${user.email})');
//     }
//     print('   Total: ${users.length} users');

//     print('\n🎉 Demo completed successfully!');
//     print('\n🚀 To start the API server:');
//     print('   dart_frog dev --port 8080');
//     print('\n📡 Available endpoints:');
//     print('   GET  /           - API info');
//     print('   GET  /users      - List all users');
//     print('   POST /users      - Create user');
//     print('   GET  /users/:id  - Get user by ID');
//   } catch (e, stackTrace) {
//     print('❌ Error: $e');
//     print('Stack trace: $stackTrace');
//   }
// }
