import 'package:dart_frog/dart_frog.dart';
import 'package:nest_frog_backend/modules/core_module.dart';
import 'package:nest_frog_backend/modules/user_module.dart';
import 'package:nest_frog/nest_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  // Using familiar Modular API
  final modular = Modular.of(context);
  final userService = modular.get<UserService>();
  final logger = modular.get<LoggerService>();

  logger.log('Users route accessed');

  switch (context.request.method) {
    case HttpMethod.get:
      return _getUsers(userService);
    case HttpMethod.post:
      return await _createUser(context, userService);
    default:
      return Response(statusCode: 405, body: 'Method not allowed');
  }
}

Response _getUsers(UserService userService) {
  final users = userService.getAllUsers();

  return Response.json(
    body: {
      'users': users.map((user) => user.toJson()).toList(),
      'count': users.length,
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
}

Future<Response> _createUser(
  RequestContext context,
  UserService userService,
) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final name = body['name'] as String?;
    final email = body['email'] as String?;

    if (name == null || email == null) {
      return Response.json(
        statusCode: 400,
        body: {
          'error': 'Missing required fields',
          'message': 'Both name and email are required',
        },
      );
    }

    final user = userService.createUser(name, email);
    if (user == null) {
      return Response.json(
        statusCode: 500,
        body: {
          'error': 'Failed to create user',
          'message': 'An error occurred while creating the user',
        },
      );
    }

    return Response.json(
      statusCode: 201,
      body: {
        'message': 'User created successfully',
        'user': user.toJson(),
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: 400,
      body: {
        'error': 'Invalid request body',
        'message': 'Request body must be valid JSON with name and email fields',
      },
    );
  }
}
