import 'package:dart_frog/dart_frog.dart';
import 'package:my_project/modules/core_module.dart';
import 'package:my_project/modules/user_module.dart';
import 'package:nest_frog/nest_frog.dart';

Response onRequest(RequestContext context, String id) {
  final modular = Modular.of(context);
  final userService = modular.get<UserService>();
  final logger = modular.get<LoggerService>();

  logger.log('User detail route accessed for id: $id');

  switch (context.request.method) {
    case HttpMethod.get:
      return _getUserById(userService, id);
    default:
      return Response(statusCode: 405, body: 'Method not allowed');
  }
}

Response _getUserById(UserService userService, String id) {
  final userId = int.tryParse(id);
  if (userId == null) {
    return Response.json(
      statusCode: 400,
      body: {
        'error': 'Invalid user ID',
        'message': 'User ID must be a valid integer',
      },
    );
  }

  final user = userService.getUserById(userId);
  if (user == null) {
    return Response.json(
      statusCode: 404,
      body: {
        'error': 'User not found',
        'message': 'User with ID $userId does not exist',
      },
    );
  }

  return Response.json(
    body: {
      'user': user.toJson(),
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
}
