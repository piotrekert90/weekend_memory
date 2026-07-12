import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/memory_game/presentation/screens/game_history_screen.dart';
import '../../features/memory_game/presentation/screens/memory_game_screen.dart';
import '../../features/memory_game/presentation/screens/home_screen.dart';

/// Declarative route paths used across the application.
abstract final class AppRoutePath {
  static const home = '/home';
  static const game = '/';
  static const history = '/history';
}

/// Typed representation of every route in the app.
sealed class AppRoute {
  const AppRoute(this.path);
  final String path;
}

/// Root route — launches the memory game screen.
final class AppRouteGame extends AppRoute {
  const AppRouteGame() : super(AppRoutePath.game);
}

/// History route — launches the game history screen.
final class AppRouteHistory extends AppRoute {
  const AppRouteHistory() : super(AppRoutePath.history);
}

/// Home route — launches the game configuration screen.
final class AppRouteHome extends AppRoute {
  const AppRouteHome() : super(AppRoutePath.home);
}

/// Parses a [location] string into a concrete [AppRoute].
///
/// Returns [AppRouteHome] for the home path, [AppRouteGame] for the root
/// path, and [AppRouteHistory] for the history path. Unknown paths default
/// to the game route.
AppRoute parseRoute(String location) {
  return switch (location) {
    AppRoutePath.home => const AppRouteHome(),
    AppRoutePath.history => const AppRouteHistory(),
    _ => const AppRouteGame(),
  };
}

/// Builds a [PageRoute] for the given [route].
///
/// Maps each [AppRoute] subtype to its corresponding screen wrapped in a
/// [MaterialPageRoute].
PageRoute<void> buildRoute(AppRoute route) {
  return switch (route) {
    AppRouteHome() => MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    AppRouteGame() => MaterialPageRoute(
        builder: (_) => const MemoryGameScreen(),
      ),
    AppRouteHistory() => MaterialPageRoute(
        builder: (_) => const GameHistoryScreen(),
      ),
  };
}

/// Riverpod provider that exposes the application's [NavigatorKey].
///
/// The key is created once and shared across the widget tree so that
/// imperative navigation (`Navigator.of(key.currentContext!)`) works from
/// anywhere — including from non-widget contexts like services or providers.
final appRouterProvider = Provider<GlobalKey<NavigatorState>>(
  (ref) => GlobalKey<NavigatorState>(),
);
