import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/AppFailure.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/models/community_model.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);

  FutureVoid createCommunity(CommunityModel communityModel) async {
    try {
      var communityDoc = await _communities.doc(communityModel.name).get();
      if (communityDoc.exists) {
        throw 'Community with the same name already exists!';
      }
      return right(
          _communities.doc(communityModel.name).set(communityModel.toMap()));
    } on FirebaseException catch (e) {
      return left(Appfailure(message: e.message!));
    } catch (e) {
      return left(Appfailure(message: e.toString()));
    }
  }

  FutureVoid joinCommunity(String communityName, String userId) async {
    try {
      return right(_communities.doc(communityName).update({
        'members': FieldValue.arrayUnion([userId])
      }));
    } on FirebaseException catch (e) {
      return left(Appfailure(message: e.message!));
    } catch (e) {
      return left(Appfailure(message: e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String userId) async {
    try {
      return right(_communities.doc(communityName).update({
        'members': FieldValue.arrayRemove([userId])
      }));
    } on FirebaseException catch (e) {
      return left(Appfailure(message: e.message!));
    } catch (e) {
      return left(Appfailure(message: e.toString()));
    }
  }

  Stream<List<CommunityModel>> getUserCommunitites(String uid) {
    return _communities.where('members', arrayContains: uid).snapshots().map(
      (event) {
        List<CommunityModel> communities = [];
        for (var doc in event.docs) {
          communities
              .add(CommunityModel.fromMap(doc.data() as Map<String, dynamic>));
        }
        return communities;
      },
    );
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map(
      (event) {
        return CommunityModel.fromMap(event.data() as Map<String, dynamic>);
      },
    );
  }

  Stream<List<CommunityModel>> searchCommunity(String query) {
    return _communities
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(query.codeUnitAt(query.length - 1) + 1),
        )
        .snapshots()
        .map(
      (event) {
        List<CommunityModel> communities = [];
        for (var community in event.docs) {
          communities.add(
              CommunityModel.fromMap(community.data() as Map<String, dynamic>));
        }
        return communities;
      },
    );
  }

  FutureVoid editCommunity(CommunityModel community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      return left(Appfailure(message: e.message!));
    } catch (e) {
      return left(Appfailure(message: e.toString()));
    }
  }
}
