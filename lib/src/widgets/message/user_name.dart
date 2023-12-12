import 'package:chat_ui/chat_ui.dart';
import 'package:flutter/material.dart';
import '../../util.dart';

/// Renders user's name as a message heading according to the theme.
class UserName extends StatelessWidget {
  /// Creates user name.
  const UserName({
    super.key,
    required this.author,
  });

  /// Author to show name from.
  final UserModel author;

  @override
  Widget build(BuildContext context) {
    // final theme = InheritedChatTheme.of(context).theme;
    // final color = getUserAvatarNameColor(author, theme.userAvatarNameColors);
    final name = getUserName(author);

    return name.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
  }
}
