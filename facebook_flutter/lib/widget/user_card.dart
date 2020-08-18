import 'package:faceboot_flutter/models/models.dart';
import 'package:faceboot_flutter/widget/widgets.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileAvatar(
            imageUrl: user.imageUrl,
          ),
          const SizedBox(
            width: 6.0,
          ),
          Text(
            user.name,
            style: TextStyle(
              fontSize: 16.0,
            ),
          )
        ],
      ),
    );
  }
}
