import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:cartalogue/models/product.dart';
import 'package:cartalogue/features/home/home.dart';
import 'package:cartalogue/features/edit_product/edit.dart';
import 'package:cartalogue/features/favorites/favorites.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: EditRoute.page),
    AutoRoute(page: FavoritesRoute.page),
  ];
}
