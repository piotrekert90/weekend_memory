import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/memory_game/presentation/screens/game_history_screen.dart';
import '../../features/memory_game/presentation/screens/memory_game_screen.dart';
import '../../features/memory_game/presentation/screens/home_screen.dart';

/// Declarative route paths used across the application.
abstract final class AppRoutePath {
  static const home = '/';
  static const game = '/game';
  static const history = '/history';
}

/// Typed representation of every route in the app.
sealed class AppRoute {
  const AppRoute(this.path);
  final String path;
}

/// Route that launches the memory game screen.
final class AppRouteGame extends AppRoute {
  const AppRouteGame() : super(AppRoutePath.game);
}

/// Route that launches the game history screen.
final class AppRouteHistory extends AppRoute {
  const AppRouteHistory() : super(AppRoutePath.history);
}

/// Route that launches the game configuration screen.
final class AppRouteHome extends AppRoute {
  const AppRouteHome() : super(AppRoutePath.home);
}

/// Resolves a route [location] string to a concrete [AppRoute].
AppRoute parseRoute(String location) {
  return switch (location) {
    AppRoutePath.home => const AppRouteHome(),
    AppRoutePath.game => const AppRouteGame(),
    AppRoutePath.history => const AppRouteHistory(),
    _ => const AppRouteHome(),
  };
}

/// Builds a [PageRoute] for the given [route].
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

/// Exposes the application's shared [NavigatorKey].
final appRouterProvider = Provider<GlobalKey<NavigatorState>>(
  (ref) => GlobalKey<NavigatorState>(),
);
