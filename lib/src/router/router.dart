import 'package:go_router/go_router.dart';
import 'package:todocupertino/src/pages/tasks_page.dart';
import 'package:todocupertino/src/router/router_name.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: RouterName.tasks,
    builder: (context, state) => const TasksPages(),
  )
]);
