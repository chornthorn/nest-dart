// import 'package:my_project/core/core.dart';
// import 'package:my_project/modules/core_module.dart';
// import 'package:my_project/modules/user_module.dart';

// void main() {
//   print('🚀 Testing NestJS-like Module System with Dart Frog');
//   print('=' * 50);

//   try {
//     // Initialize the container
//     Modular.initialize();
//     print('✅ Container initialized successfully');

//     // Test getting services
//     final config = Modular.get<ConfigService>();
//     print('✅ ConfigService: Environment = ${config.environment}');

//     final logger = Modular.get<LoggerService>();
//     logger.log('Testing logger service');
//     print('✅ LoggerService working');

//     final database = Modular.get<DatabaseService>();
//     print('✅ DatabaseService: ${config.databaseType} database');

//     final userService = Modular.get<UserService>();
//     final users = userService.getAllUsers();
//     print('✅ UserService: Found ${users.length} users');

//     for (final user in users) {
//       print('   - User: ${user.name} (${user.email})');
//     }

//     // Test getting specific user
//     final user1 = userService.getUserById(1);
//     if (user1 != null) {
//       print('✅ Found user by ID: ${user1.name}');
//     }

//     print('\n🎉 All tests passed! Module system working correctly.');
//   } catch (e, stackTrace) {
//     print('❌ Error: $e');
//     print('Stack trace: $stackTrace');
//   }
// }
