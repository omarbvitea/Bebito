import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/memories/presentation/memories_screen.dart';
import '../../features/timeline/presentation/timeline_screen.dart';
import '../../features/auth/data/auth_repository.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/memories',
        builder: (context, state) => const MemoriesScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final memory = state.extra as dynamic; // Cast to Memory?
              // Need to import Memory model to cast properly or just pass dynamic
              return TimelineScreen(memoryId: id, memory: memory);
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      // If auth state is loading, don't redirect yet
      if (authState.isLoading) return null;

      final session = authState.valueOrNull?.session;
      final isAuthenticated = session != null;

      final isLoggingIn =
          state.uri.path == '/login' || state.uri.path == '/signup';

      if (!isAuthenticated && !isLoggingIn) return '/login';
      if (isAuthenticated && isLoggingIn) return '/memories';

      return null;
    },
  );
}
