import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);

  return CommunityController(
    communityRepository: communityRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunitites();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.searchCommunity(query);
});

class CommunityController extends StateNotifier<bool> {
  final Ref _ref;
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  CommunityController({
    required CommunityRepository communityRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    CommunityModel communityModel = CommunityModel(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(communityModel);
    state = false;
    res.fold(
      (l) {
        showSnackbar(context, l.message);
      },
      (r) {
        showSnackbar(context, "Community created successfully!");
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<CommunityModel>> getUserCommunitites() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunitites(uid);
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  Stream<List<CommunityModel>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void editCommunity({
    required CommunityModel community,
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
  }) async {
    state = true;
    if (profileFile != null) {
      //communities/profile/community-name
      final result = await _storageRepository.storeFile(
          path: "communities/profile", id: community.name, file: profileFile);
      result.fold(
        (l) {
          showSnackbar(context, l.message);
        },
        (r) {
          community = community.copyWith(avatar: r);
        },
      );
    }
    if (bannerFile != null) {
      //communities/banner/community-name
      final result = await _storageRepository.storeFile(
          path: "communities/banner", id: community.name, file: bannerFile);
      result.fold(
        (l) {
          showSnackbar(context, l.message);
        },
        (r) {
          community = community.copyWith(banner: r);
        },
      );
    }

    final result = await _communityRepository.editCommunity(community);
    state = false;

    result.fold(
      (l) => showSnackbar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  void joinCommunity(CommunityModel community, BuildContext context) async {
    final user = _ref.read(userProvider)!.uid;
    if (community.members.contains(user)) {
      await _communityRepository.leaveCommunity(community.name, user);
      // showSnackbar(context, "")
    } else {
      await _communityRepository.joinCommunity(community.name, user);
    }
  }
}
