import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityList extends ConsumerWidget {
  const CommunityList({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push("/create-community");
  }

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push("r/$communityName");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          ListTile(
            title: const Text("Create a community"),
            leading: const Icon(Icons.add),
            onTap: () {
              navigateToCreateCommunity(context);
            },
          ),
          ref.watch(userCommunitiesProvider).when(
            data: (data) {
              return Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final community = data[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(community.avatar),
                      ),
                      title: Text("r/${community.name}"),
                      onTap: () {
                        navigateToCommunity(context, community.name);
                      },
                    );
                  },
                ),
              );
            },
            error: (error, stackTrace) {
              return ErrorText(error: error.toString());
            },
            loading: () {
              return const Loader();
            },
          )
        ],
      )),
    );
  }
}
