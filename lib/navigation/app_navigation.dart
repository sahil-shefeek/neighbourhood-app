import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neighbourhood/models/product.dart';
import 'package:neighbourhood/views/community/community_view.dart';
import 'package:neighbourhood/views/home/home_view.dart';
import 'package:neighbourhood/views/login/loginpage.dart';
import 'package:neighbourhood/views/search/search_view.dart';
import 'package:neighbourhood/views/share/share_view.dart';
import 'package:neighbourhood/views/wrapper/main_wrapper.dart';
import 'package:neighbourhood/views/cart/cart_view.dart';
import 'package:neighbourhood/views/buy/buy_view.dart';
import 'package:neighbourhood/views/product/product_view.dart';
import 'package:neighbourhood/views/profile/profile_view.dart';
import 'package:neighbourhood/views/signup/signup_page.dart';

class AppNavigation {
  AppNavigation._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _shellNavigatorSettings =
      GlobalKey<NavigatorState>(debugLabel: 'shellSettings');
  static final _shellNavigatorSearch =
      GlobalKey<NavigatorState>(debugLabel: 'shellSearch');
  static final _shellNavigatorShare =
      GlobalKey<NavigatorState>(debugLabel: 'shellShare');
  static final _shellNavigatorCart =
      GlobalKey<NavigatorState>(debugLabel: 'shellCart');

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/login',
        name: 'Login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'SignUp',
        builder: (BuildContext context, GoRouterState state) =>
            const SignUpPage(),
      ),
      GoRoute(
        path: '/product',
        name: 'Product',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            ProductPage(product: state.extra as Product),
      ),
      GoRoute(
        path: '/profile',
        name: 'Profile',
        builder: (BuildContext context, GoRouterState state) =>
            const ProfileView(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainWrapper(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: [
              GoRoute(
                path: '/home',
                name: 'Home',
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeView(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettings,
            routes: [
              GoRoute(
                path: '/community',
                name: 'Community',
                builder: (BuildContext context, GoRouterState state) =>
                    const CommunityView(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSearch,
            routes: [
              GoRoute(
                path: '/search',
                name: 'Search',
                builder: (BuildContext context, GoRouterState state) =>
                    const SearchView(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorShare,
            routes: [
              GoRoute(
                path: '/share',
                name: 'Share',
                builder: (BuildContext context, GoRouterState state) =>
                    const ShareView(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorCart,
            routes: [
              GoRoute(
                path: '/cart',
                name: 'Cart',
                builder: (BuildContext context, GoRouterState state) =>
                    const CartView(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/buy',
        name: 'Buy',
        builder: (BuildContext context, GoRouterState state) =>
            BuyView(items: state.extra),
      ),
    ],
  );
}
