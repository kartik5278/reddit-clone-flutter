// loggedout routes
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screen/login_screen.dart';
import 'package:reddit_clone/features/community/screens/add_mods_screen.dart';
import 'package:reddit_clone/features/community/screens/community_screen.dart';
import 'package:reddit_clone/features/community/screens/create_community_screen.dart';
import 'package:reddit_clone/features/community/screens/edit_community_screen.dart';
import 'package:reddit_clone/features/community/screens/mod_tools_screen.dart';
import 'package:reddit_clone/features/home/screen/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedoutRoute = RouteMap(
  routes: {
    "/": (_) => const MaterialPage(child: LoginScreen()),
  },
);

// loggedin routes
final loggedinRoute = RouteMap(
  routes: {
    "/": (_) => const MaterialPage(child: HomeScreen()),
    "/create-community": (_) => const MaterialPage(child: CreateCommunity()),
    "/r/:name": (route) => MaterialPage(
          child: CommunityScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    "/mod-tools/:name": (route) => MaterialPage(
          child: ModToolsScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    "/edit-community/:name": (route) => MaterialPage(
          child: EditCommunityScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    "/add-mods/:name": (route) => MaterialPage(
          child: AddModsScreen(
            name: route.pathParameters['name']!,
          ),
        ),
  },
);
