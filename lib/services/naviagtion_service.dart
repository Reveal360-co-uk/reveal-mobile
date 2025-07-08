import 'package:flutter/cupertino.dart';

/// A service class for managing navigation in a Flutter application.
class NavigationService {
  /// A global key to access the current [NavigatorState].
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Pushes a new route onto the navigator stack.
  ///
  /// Returns a Future that completes to the result passed to [Navigator.pop] when the popped route is removed from the navigator.
  Future<T?> push<T extends Object?>(Route<T> route) async {
    return navigatorKey.currentState?.push<T>(route);
  }

  /// Pushes a named route onto the navigator stack.
  ///
  /// Returns a Future that completes to the result passed to [Navigator.pop] when the popped route is removed from the navigator.
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    return navigatorKey.currentState?.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Pushes a named route onto the navigator stack and replaces the current route with it.
  ///
  /// Returns a Future that completes to the result passed to [Navigator.pop] when the popped route is removed from the navigator.
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) async {
    return navigatorKey.currentState?.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Pushes a named route onto the navigator stack and then removes all previous routes until a predicate returns true.
  ///
  /// Returns a Future that completes to the result passed to [Navigator.pop] when the popped route is removed from the navigator.
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) async {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate ?? (_) => false,
      arguments: arguments,
    );
  }

  /// Pops the navigator until the route with the given name is on top.
  void popUntil(String route) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(route));
  }

  /// Pops the top-most route off the navigator and returns to the previous screen.
  ///
  /// If a result is provided, it is passed to the previous screen's [Navigator.pop] method.
  void goBack<T extends Object?>({T? result}) {
    navigatorKey.currentState?.pop<T>(result);
  }
}
