import 'package:chitchat/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/select_contact_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
  return selectContactRepository.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
  return SelectContactController(
    ref: ref,
    selectContactRepository: selectContactRepository,
  );
});

final getFirebaseContactsProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactsRepositoryProvider);

  return selectContactRepository.getContacts();
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;
  SelectContactController({
    required this.ref,
    required this.selectContactRepository,
  });

  void selectContact(UserModel userModel, BuildContext context) {
    selectContactRepository.selectUser(userModel, context);
  }
}
