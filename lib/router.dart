// loggedout routes
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screen/login_screen.dart';
import 'package:reddit_clone/features/community/screens/community_screen.dart';
import 'package:reddit_clone/features/community/screens/create_community_screen.dart';
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
  },
);
