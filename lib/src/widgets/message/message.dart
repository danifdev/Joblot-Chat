import 'package:chat_ui/chat_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:visibility_detector/visibility_detector.dart';
import '../../conditional/conditional.dart';
import '../../util.dart';
import '../state/inherited_chat_theme.dart';

/// Base widget for all message types in the chat. Renders bubbles around
/// messages and status. Sets maximum width for a message for
/// a nice look on larger screens.
class Message extends StatelessWidget {
  /// Creates a particular message from any message type.
  const Message({
    super.key,
    this.audioMessageBuilder,
    this.avatarBuilder,
    this.bubbleBuilder,
    this.bubbleRtlAlignment,
    this.customMessageBuilder,
    this.customStatusBuilder,
    required this.emojiEnlargementBehavior,
    this.fileMessageBuilder,
    required this.hideBackgroundOnEmojiMessages,
    this.imageHeaders,
    this.imageMessageBuilder,
    this.imageProviderBuilder,
    required this.message,
    required this.messageWidth,
    this.nameBuilder,
    this.onAvatarTap,
    this.onMessageDoubleTap,
    this.onMessageLongPress,
    this.onMessageStatusLongPress,
    this.onMessageStatusTap,
    this.onMessageTap,
    this.onMessageVisibilityChanged,
    this.onPreviewDataFetched,
    required this.roundBorder,
    required this.showAvatar,
    required this.showName,
    required this.showStatus,
    required this.showUserAvatars,
    this.textMessageBuilder,
    required this.textMessageOptions,
    required this.usePreviewData,
    this.userAgent,
    this.videoMessageBuilder,
  });

  /// Build an audio message inside predefined bubble.
  final Widget Function(AudioMessage, {required int messageWidth})?
      audioMessageBuilder;

  /// This is to allow custom user avatar builder
  /// By using this we can fetch newest user info based on id.
  final Widget Function(String userId)? avatarBuilder;

  /// Customize the default bubble using this function. `child` is a content
  /// you should render inside your bubble, `message` is a current message
  /// (contains `author` inside) and `nextMessageInGroup` allows you to see
  /// if the message is a part of a group (messages are grouped when written
  /// in quick succession by the same author).
  final Widget Function(
    Widget child, {
    required MessageModel message,
    required bool nextMessageInGroup,
  })? bubbleBuilder;

  /// Determine the alignment of the bubble for RTL languages. Has no effect
  /// for the LTR languages.
  final BubbleRtlAlignment? bubbleRtlAlignment;

  /// Build a custom message inside predefined bubble.
  final Widget Function(CustomMessage, {required int messageWidth})?
      customMessageBuilder;

  /// Build a custom status widgets.
  final Widget Function(MessageModel message, {required BuildContext context})?
      customStatusBuilder;

  /// Controls the enlargement behavior of the emojis in the
  /// [TextMessage].
  /// Defaults to [EmojiEnlargementBehavior.multi].
  final EmojiEnlargementBehavior emojiEnlargementBehavior;

  /// Build a file message inside predefined bubble.
  final Widget Function(FileMessageModel, {required int messageWidth})?
      fileMessageBuilder;

  /// Hide background for messages containing only emojis.
  final bool hideBackgroundOnEmojiMessages;

  /// See [Chat.imageHeaders].
  final Map<String, String>? imageHeaders;

  /// Build an image message inside predefined bubble.
  final Widget Function(ImageMessageModel, {required int messageWidth})?
      imageMessageBuilder;

  /// See [Chat.imageProviderBuilder].
  final ImageProvider Function({
    required String uri,
    required Map<String, String>? imageHeaders,
    required Conditional conditional,
  })? imageProviderBuilder;

  /// Any message type.
  final MessageModel message;

  /// Maximum message width.
  final int messageWidth;

  /// See [TextMessage.nameBuilder].
  final Widget Function(UserModel)? nameBuilder;

  /// See [UserAvatar.onAvatarTap].
  final void Function(UserModel)? onAvatarTap;

  /// Called when user double taps on any message.
  final void Function(BuildContext context, MessageModel)? onMessageDoubleTap;

  /// Called when user makes a long press on any message.
  final void Function(BuildContext context, MessageModel)? onMessageLongPress;

  /// Called when user makes a long press on status icon in any message.
  final void Function(BuildContext context, MessageModel)?
      onMessageStatusLongPress;

  /// Called when user taps on status icon in any message.
  final void Function(BuildContext context, MessageModel)? onMessageStatusTap;

  /// Called when user taps on any message.
  final void Function(BuildContext context, MessageModel)? onMessageTap;

  /// Called when the message's visibility changes.
  final void Function(MessageModel, bool visible)? onMessageVisibilityChanged;

  /// See [TextMessage.onPreviewDataFetched].
  final void Function(TextMessageModel, PreviewDataModel)? onPreviewDataFetched;

  /// Rounds border of the message to visually group messages together.
  final bool roundBorder;

  /// Show user avatar for the received message. Useful for a group chat.
  final bool showAvatar;

  /// See [TextMessage.showName].
  final bool showName;

  /// Show message's status.
  final bool showStatus;

  /// Show user avatars for received messages. Useful for a group chat.
  final bool showUserAvatars;

  /// Build a text message inside predefined bubble.
  final Widget Function(
    TextMessageModel, {
    required int messageWidth,
    required bool showName,
  })? textMessageBuilder;

  /// See [TextMessage.options].
  final TextMessageOptions textMessageOptions;

  /// See [TextMessage.usePreviewData].
  final bool usePreviewData;

  /// See [TextMessage.userAgent].
  final String? userAgent;

  /// Build an audio message inside predefined bubble.
  final Widget Function(VideoMessage, {required int messageWidth})?
      videoMessageBuilder;

  // Received time formatted as Hour: minute
  String getReceivedTime(MessageReceivedTime? time) {
    if (time?.timeText != null) return time!.timeText!;
    return intl.DateFormat.Hm().format(time?.timeDate ?? DateTime.now());
  }

  Widget _avatarBuilder() => showAvatar
      ? avatarBuilder?.call(message.author.id) ??
          UserAvatar(
            author: message.author,
            bubbleRtlAlignment: bubbleRtlAlignment,
            imageHeaders: imageHeaders,
            onAvatarTap: onAvatarTap,
          )
      : UserAvatar(
          author: message.author,
          emptyView: true,
        );

  Widget _bubbleBuilder(
    BuildContext context,
    BorderRadius borderRadius,
    bool currentUserIsAuthor,
    bool enlargeEmojis,
  ) =>
      bubbleBuilder != null
          ? bubbleBuilder!(
              _messageBuilder(),
              message: message,
              nextMessageInGroup: roundBorder,
            )
          : enlargeEmojis && hideBackgroundOnEmojiMessages
              ? _messageBuilder()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color: !currentUserIsAuthor
                            ? const Color(0xffE2E2E2)
                            : Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _messageBuilder(),
                            Container(
                              padding: InheritedChatTheme.of(context)
                                  .theme
                                  .statusIconPadding,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    getReceivedTime(message.receivedTime),
                                    style: const TextStyle(
                                      color: Colors.black26,
                                      fontSize: 11,
                                    ),
                                  ),
                                  if (currentUserIsAuthor) ...[
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Container(
                                      child: showStatus
                                          ? GestureDetector(
                                              onTap: () => onMessageTap?.call(
                                                  context, message),
                                              child: customStatusBuilder != null
                                                  ? customStatusBuilder!(
                                                      message,
                                                      context: context)
                                                  : MessageStatus(
                                                      status: message.status,
                                                    ),
                                            )
                                          : null,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );

  Widget _messageBuilder() {
    switch (message.type) {
      case MessageType.audio:
        final audioMessage = message as AudioMessage;
        return audioMessageBuilder != null
            ? audioMessageBuilder!(audioMessage, messageWidth: messageWidth)
            : const SizedBox();
      case MessageType.custom:
        final customMessage = message as CustomMessage;
        return customMessageBuilder != null
            ? customMessageBuilder!(customMessage, messageWidth: messageWidth)
            : const SizedBox();
      case MessageType.file:
        final fileMessage = message as FileMessageModel;
        return fileMessageBuilder != null
            ? fileMessageBuilder!(fileMessage, messageWidth: messageWidth)
            : FileMessage(message: fileMessage);
      case MessageType.image:
        final imageMessage = message as ImageMessageModel;
        return imageMessageBuilder != null
            ? imageMessageBuilder!(imageMessage, messageWidth: messageWidth)
            : ImageMessage(
                imageHeaders: imageHeaders,
                imageProviderBuilder: imageProviderBuilder,
                message: imageMessage,
                messageWidth: messageWidth,
              );
      case MessageType.text:
        final textMessage = message as TextMessageModel;
        return textMessageBuilder != null
            ? textMessageBuilder!(
                textMessage,
                messageWidth: messageWidth,
                showName: showName,
              )
            : TextMessage(
                emojiEnlargementBehavior: emojiEnlargementBehavior,
                hideBackgroundOnEmojiMessages: hideBackgroundOnEmojiMessages,
                message: textMessage,
                nameBuilder: nameBuilder,
                onPreviewDataFetched: onPreviewDataFetched,
                options: textMessageOptions,
                showName: showName,
                usePreviewData: usePreviewData,
                userAgent: userAgent,
              );
      case MessageType.video:
        final videoMessage = message as VideoMessage;
        return videoMessageBuilder != null
            ? videoMessageBuilder!(videoMessage, messageWidth: messageWidth)
            : const SizedBox();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final currentUserIsAuthor = message.isOwner ?? false;
    final enlargeEmojis =
        emojiEnlargementBehavior != EmojiEnlargementBehavior.never &&
            message is TextMessage &&
            isConsistsOfEmojis(
              emojiEnlargementBehavior,
              message as TextMessageModel,
            );
    final messageBorderRadius =
        InheritedChatTheme.of(context).theme.messageBorderRadius;
    final borderRadius = bubbleRtlAlignment == BubbleRtlAlignment.left
        ? BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(
              !currentUserIsAuthor || roundBorder ? messageBorderRadius : 0,
            ),
            bottomStart: Radius.circular(
              currentUserIsAuthor || roundBorder ? messageBorderRadius : 0,
            ),
            topEnd: Radius.circular(messageBorderRadius),
            topStart: Radius.circular(messageBorderRadius),
          )
        : BorderRadius.only(
            bottomLeft: Radius.circular(
              currentUserIsAuthor || roundBorder ? messageBorderRadius : 0,
            ),
            bottomRight: Radius.circular(
              !currentUserIsAuthor || roundBorder ? messageBorderRadius : 0,
            ),
            topLeft: Radius.circular(messageBorderRadius),
            topRight: Radius.circular(messageBorderRadius),
          );

    return Container(
      alignment: bubbleRtlAlignment == BubbleRtlAlignment.left
          ? currentUserIsAuthor
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart
          : currentUserIsAuthor
              ? Alignment.centerRight
              : Alignment.centerLeft,
      margin: bubbleRtlAlignment == BubbleRtlAlignment.left
          ? EdgeInsetsDirectional.only(
              bottom: 4,
              end: isMobile ? query.padding.right : 0,
              start: 12 + (isMobile ? query.padding.left : 0),
            )
          : EdgeInsets.only(
              bottom: 4,
              left: 12 + (isMobile ? query.padding.left : 0),
              right: isMobile ? query.padding.right : 0,
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        textDirection: bubbleRtlAlignment == BubbleRtlAlignment.left
            ? null
            : TextDirection.ltr,
        children: [
          if (!currentUserIsAuthor && showUserAvatars) _avatarBuilder(),
          GestureDetector(
            onTap: () => onMessageTap?.call(context, message),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: messageWidth.toDouble(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  onMessageVisibilityChanged != null
                      ? VisibilityDetector(
                          key: Key(message.id),
                          onVisibilityChanged: (visibilityInfo) =>
                              onMessageVisibilityChanged!(
                            message,
                            visibilityInfo.visibleFraction > 0.1,
                          ),
                          child: _bubbleBuilder(
                            context,
                            borderRadius.resolve(Directionality.of(context)),
                            currentUserIsAuthor,
                            enlargeEmojis,
                          ),
                        )
                      : _bubbleBuilder(
                          context,
                          borderRadius.resolve(Directionality.of(context)),
                          currentUserIsAuthor,
                          enlargeEmojis,
                        ),
                ],
              ),
            ),
          ),
          if (currentUserIsAuthor && showUserAvatars) ...[
            const SizedBox(
              width: 16,
            ),
            // _avatarBuilder(),
          ],
        ],
      ),
    );
  }
}
