import 'package:chat_ui/chat_ui.dart';
import 'package:flutter/material.dart';
import '../state/inherited_chat_theme.dart';

/// A class that represents a message status.
class MessageStatus extends StatelessWidget {
  /// Creates a message status widget.
  const MessageStatus({
    super.key,
    required this.status,
  });

  /// Status of the message.
  final Status? status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case Status.delivered:
      case Status.sent:
        return InheritedChatTheme.of(context).theme.deliveredIcon != null
            ? InheritedChatTheme.of(context).theme.deliveredIcon!
            : Image.asset(
                'assets/icon-delivered.png',
                color: Colors.blue.shade300,
                package: 'chat_ui',
              );
      case Status.error:
        return InheritedChatTheme.of(context).theme.errorIcon != null
            ? InheritedChatTheme.of(context).theme.errorIcon!
            : Image.asset(
                'assets/icon-error.png',
                color: InheritedChatTheme.of(context).theme.errorColor,
                package: 'chat_ui',
              );
      case Status.seen:
        return InheritedChatTheme.of(context).theme.seenIcon != null
            ? InheritedChatTheme.of(context).theme.seenIcon!
            : Image.asset(
                'assets/icon-seen.png',
                color: Colors.blue.shade300,
                package: 'chat_ui',
              );
      case Status.sending:
        return InheritedChatTheme.of(context).theme.sendingIcon != null
            ? InheritedChatTheme.of(context).theme.sendingIcon!
            : Image.asset(
                'assets/icon-delivered.png',
                color: Colors.blue.shade100,
                package: 'chat_ui',
              );
      default:
        return const SizedBox(width: 8);
    }
  }
}
