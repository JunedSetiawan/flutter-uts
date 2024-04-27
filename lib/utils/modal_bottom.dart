import 'package:myapp/models/user.dart';
import 'package:myapp/widgets/form.dart';
import 'package:flutter/material.dart';

class ModalBottomSheet {
  void showModal(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FormWidget(user);
      },
    );
  }
}