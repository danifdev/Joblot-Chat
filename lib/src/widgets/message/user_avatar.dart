import 'package:chat_ui/chat_ui.dart';
import 'package:flutter/material.dart';
import '../../models/bubble_rtl_alignment.dart';
import '../../util.dart';
import '../state/inherited_chat_theme.dart';

/// Renders user's avatar or initials next to a message.
class UserAvatar extends StatelessWidget {
  /// Creates user avatar.
  const UserAvatar({
    super.key,
    required this.author,
    this.bubbleRtlAlignment,
    this.imageHeaders,
    this.onAvatarTap,
    this.emptyView = false,
  });

  /// Author to show image and name initials from.
  final UserModel author;

  /// See [Message.bubbleRtlAlignment].
  final BubbleRtlAlignment? bubbleRtlAlignment;

  /// See [Chat.imageHeaders].
  final Map<String, String>? imageHeaders;

  /// Called when user taps on an avatar.
  final void Function(UserModel)? onAvatarTap;

  final bool emptyView;

  @override
  Widget build(BuildContext context) {
    const color = Color(0xffE2E2E2);
    final hasImage = author.imageUrl != null;
    final initials = getUserInitials(author);

    return Container(
      margin: bubbleRtlAlignment == BubbleRtlAlignment.left
          ? const EdgeInsetsDirectional.only(end: 8)
          : const EdgeInsets.only(right: 8),
      child: emptyView
          ? Container(
              constraints: const BoxConstraints(maxHeight: 28, maxWidth: 28),
            )
          : GestureDetector(
              onTap: () => onAvatarTap?.call(author),
              child: author.isBase64UrlOfAvatar && hasImage
                  ? CircleAvatar(
                      backgroundColor: color,
                      backgroundImage:
                          hasImage ? MemoryImage(author.bytes) : null,
                      radius: 14,
                      child: !hasImage
                          ? Text(
                              initials,
                              style: InheritedChatTheme.of(context)
                                  .theme
                                  .userAvatarTextStyle,
                            )
                          : const SizedBox.shrink(),
                    )
                  : CircleAvatar(
                      backgroundColor: color,
                      backgroundImage: hasImage
                          ? NetworkImage(author.imageUrl!,
                              headers: imageHeaders)
                          : null,
                      radius: 14,
                      child: !hasImage
                          ? Text(
                              initials,
                              style: InheritedChatTheme.of(context)
                                  .theme
                                  .userAvatarTextStyle,
                            )
                          : const SizedBox.shrink(),
                    ),
            ),
    );
  }
}
