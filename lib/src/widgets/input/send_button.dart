import 'package:flutter/material.dart';

import '../state/inherited_chat_theme.dart';
import '../state/inherited_l10n.dart';

/// A class that represents send button widget.
class SendButton extends StatelessWidget {
  /// Creates send button widget.
  const SendButton({
    super.key,
    required this.onPressed,
    this.padding = EdgeInsets.zero,
    this.enabled = false,
  });

  /// Callback for send button tap event.
  final VoidCallback onPressed;

  /// Padding around the button.
  final EdgeInsets padding;

  final bool enabled;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: !enabled ? Colors.grey.shade400 : Colors.blue,
            shape: BoxShape.circle),
        margin: InheritedChatTheme.of(context).theme.sendButtonMargin ??
            const EdgeInsetsDirectional.fromSTEB(8, 0, 4, 0),
        child: IconButton(
          icon: InheritedChatTheme.of(context).theme.sendButtonIcon ??
              Image.asset(
                'assets/icon-send.png',
                color: enabled ? Colors.white : Colors.white60,
                package: 'chat_ui',
              ),
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          splashRadius: 24,
          tooltip: InheritedL10n.of(context).l10n.sendButtonAccessibilityLabel,
        ),
      );
}
