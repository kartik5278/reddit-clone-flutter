import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_clone/features/home/drawers/community_list_drawer.dart';
import 'package:reddit_clone/features/home/drawers/profile_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    void displayDrawer(BuildContext context) {
      Scaffold.of(context).openDrawer();
    }

    void displayEndDrawer(BuildContext context) {
      Scaffold.of(context).openEndDrawer();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
                onPressed: () {
                  return displayDrawer(context);
                },
                icon: const Icon(Icons.menu));
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SearchCommunityDelegate(ref: ref));
            },
            icon: const Icon(Icons.search),
          ),
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  return displayEndDrawer(context);
                },
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                ),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Text(user.name),
      ),
      drawer: const CommunityList(),
      endDrawer: const ProfileDrawer(),
    );
  }
}
