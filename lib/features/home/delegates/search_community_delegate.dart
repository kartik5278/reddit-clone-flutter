import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;

  SearchCommunityDelegate({required this.ref});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return query.isNotEmpty
        ? [
            IconButton(
              onPressed: () {
                query = '';
              },
              icon: const Icon(Icons.close),
            ),
          ]
        : null;
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push("r/$communityName");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(
      data: (communities) {
        return ListView.builder(
          itemCount: communities.length,
          itemBuilder: (context, index) {
            final community = communities[index];
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
        );
      },
      error: (error, stackTrace) {
        return ErrorText(error: error.toString());
      },
      loading: () {
        return const Loader();
      },
    );
  }
}
