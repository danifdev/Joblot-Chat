import 'package:chat_ui/chat_ui.dart';
import 'package:chat_ui/src/widgets/state/inherited_l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../util.dart';
import '../state/inherited_chat_theme.dart';

/// A class that represents bottom bar widget with a text field, attachment and
/// send buttons inside. By default hides send button when text field is empty.
class Input extends StatefulWidget {
  /// Creates [Input] widget.
  const Input({
    super.key,
    this.isAttachmentUploading,
    this.onAttachmentPressed,
    required this.onSendPressed,
    this.options = const InputOptions(),
    this.emojis = emojies,
    this.onEmojiTap,
  });

  /// Whether attachment is uploading. Will replace attachment button with a
  /// [CircularProgressIndicator]. Since we don't have libraries for
  /// managing media in dependencies we have no way of knowing if
  /// something is uploading so you need to set this manually.
  final bool? isAttachmentUploading;

  /// See [AttachmentButton.onPressed].
  final VoidCallback? onAttachmentPressed;

  /// Will be called on [SendButton] tap. Has [PartialText] which can
  /// be transformed to [TextMessage] and added to the messages list.
  final void Function(PartialText) onSendPressed;

  /// Customisation options for the [Input].
  final InputOptions options;

  final List<String>? emojis;

  final Function(String emoji)? onEmojiTap;

  @override
  State<Input> createState() => _InputState();
}

/// [Input] widget state.
class _InputState extends State<Input> {
  final _inputFocusNode = FocusNode();

  late TextEditingController _textController;

  final ValueNotifier<bool> _showEmojis = ValueNotifier<bool>(true);

  final ValueNotifier<bool> _sendButtonVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();

    _textController =
        widget.options.textEditingController ?? InputTextFieldController();
    _handleSendButtonVisibilityModeChange();
  }

  void _handleSendButtonVisibilityModeChange() {
    _textController.removeListener(_handleTextControllerChange);
    if (widget.options.sendButtonVisibilityMode ==
        SendButtonVisibilityMode.hidden) {
      _sendButtonVisible.value = false;
    } else if (widget.options.sendButtonVisibilityMode ==
        SendButtonVisibilityMode.editing) {
      _sendButtonVisible.value = _textController.text.trim() != '';
      _textController.addListener(_handleTextControllerChange);
    } else {
      _sendButtonVisible.value = true;
    }
  }

  void _handleSendPressed() {
    final trimmedText = _textController.text.trim();
    if (trimmedText != '') {
      final partialText = PartialText(text: trimmedText);
      widget.onSendPressed(partialText);

      if (widget.options.inputClearMode == InputClearMode.always) {
        _textController.clear();
      }
    }
  }

  void _handleTextControllerChange() {
    _sendButtonVisible.value = _textController.text.trim() != '';
  }

  Widget _inputBuilder() {
    final query = MediaQuery.of(context);
    final buttonPadding = InheritedChatTheme.of(context)
        .theme
        .inputPadding
        .copyWith(left: 16, right: 16);
    final safeAreaInsets = isMobile
        ? EdgeInsets.fromLTRB(
            0,
            0,
            0,
            query.viewInsets.bottom,
          )
        : EdgeInsets.zero;
    final textPadding = InheritedChatTheme.of(context)
        .theme
        .inputPadding
        .copyWith(left: 0, right: 0)
        .add(
          EdgeInsets.fromLTRB(
            widget.onAttachmentPressed != null ? 0 : 24,
            0,
            _sendButtonVisible.value ? 0 : 24,
            0,
          ),
        );

    return Container(
      padding: InheritedChatTheme.of(context).theme.inputMargin,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xffECEBEB)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xffECEBEB)),
                borderRadius:
                    InheritedChatTheme.of(context).theme.inputBorderRadius,
              ),
              padding: safeAreaInsets,
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  const SizedBox(
                    height: 48,
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      enabled: widget.options.enabled,
                      autocorrect: widget.options.autocorrect,
                      enableSuggestions: widget.options.enableSuggestions,
                      controller: _textController,
                      cursorColor: InheritedChatTheme.of(context)
                          .theme
                          .inputTextCursorColor,
                      decoration: InheritedChatTheme.of(context)
                          .theme
                          .inputTextDecoration
                          .copyWith(
                            hintText:
                                InheritedL10n.of(context).l10n.inputPlaceholder,
                          ),
                      focusNode: _inputFocusNode,
                      keyboardType: widget.options.keyboardType,
                      maxLines: 5,
                      minLines: 1,
                      onChanged: widget.options.onTextChanged,
                      onTap: widget.options.onTextFieldTap,
                      style: InheritedChatTheme.of(context)
                          .theme
                          .inputTextStyle
                          .copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _sendButtonVisible,
            builder: (_, isShow, __) {
              return SendButton(
                enabled: isShow,
                onPressed: _handleSendPressed,
                padding: buttonPadding,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _emojiItem(String e, Function(String x) onTap) => GestureDetector(
        onTap: () => onTap.call(e),
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: FittedBox(
            child: Text(
              e,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      );

  @override
  void didUpdateWidget(covariant Input oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options.sendButtonVisibilityMode !=
        oldWidget.options.sendButtonVisibilityMode) {
      _handleSendButtonVisibilityModeChange();
    }
  }

  @override
  void dispose() {
    _inputFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _inputBuilder();
  }
}

@immutable
class InputOptions {
  const InputOptions({
    this.inputClearMode = InputClearMode.always,
    this.keyboardType = TextInputType.multiline,
    this.onTextChanged,
    this.onTextFieldTap,
    this.sendButtonVisibilityMode = SendButtonVisibilityMode.editing,
    this.textEditingController,
    this.autocorrect = true,
    this.autofocus = true,
    this.enableSuggestions = true,
    this.enabled = true,
  });

  /// Controls the [Input] clear behavior. Defaults to [InputClearMode.always].
  final InputClearMode inputClearMode;

  /// Controls the [Input] keyboard type. Defaults to [TextInputType.multiline].
  final TextInputType keyboardType;

  /// Will be called whenever the text inside [TextField] changes.
  final void Function(String)? onTextChanged;

  /// Will be called on [TextField] tap.
  final VoidCallback? onTextFieldTap;

  /// Controls the visibility behavior of the [SendButton] based on the
  /// [TextField] state inside the [Input] widget.
  /// Defaults to [SendButtonVisibilityMode.editing].
  final SendButtonVisibilityMode sendButtonVisibilityMode;

  /// Custom [TextEditingController]. If not provided, defaults to the
  /// [InputTextFieldController], which extends [TextEditingController] and has
  /// additional fatures like markdown support. If you want to keep additional
  /// features but still need some methods from the default [TextEditingController],
  /// you can create your own [InputTextFieldController] (imported from this lib)
  /// and pass it here.
  final TextEditingController? textEditingController;

  /// Controls the [TextInput] autocorrect behavior. Defaults to [true].
  final bool autocorrect;

  /// Whether [TextInput] should have focus. Defaults to [false].
  final bool autofocus;

  /// Controls the [TextInput] enableSuggestions behavior. Defaults to [true].
  final bool enableSuggestions;

  /// Controls the [TextInput] enabled behavior. Defaults to [true].
  final bool enabled;
}
