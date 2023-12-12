import 'package:chat_ui/chat_ui.dart';
import 'package:chat_ui/src/widgets/scroll_to_top_button.dart';
import 'package:diffutil_dart/diffutil.dart';
import 'package:flutter/material.dart';
import '../models/bubble_rtl_alignment.dart';
import 'state/inherited_chat_theme.dart';
import 'typing_indicator.dart';

/// Animated list that handles automatic animations and pagination.
class ChatList extends StatefulWidget {
  /// Creates a chat list widget.
  const ChatList({
    super.key,
    this.bottomWidget,
    required this.bubbleRtlAlignment,
    this.isLastPage,
    required this.itemBuilder,
    required this.items,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.onEndReached,
    this.onEndReachedThreshold,
    required this.scrollController,
    this.scrollPhysics,
    this.typingIndicatorOptions,
    required this.useTopSafeAreaInset,
    this.isManuallyHideKeyboard = false,
    this.contextForKeyboard,
    // required this.physics,
    this.isOwnerAddedMessage = false,
  });

  /// A custom widget at the bottom of the list.
  final Widget? bottomWidget;

  /// Used to set alignment of typing indicator.
  /// See [BubbleRtlAlignment].
  final BubbleRtlAlignment bubbleRtlAlignment;

  /// Used for pagination (infinite scroll) together with [onEndReached].
  /// When true, indicates that there are no more pages to load and
  /// pagination will not be triggered.
  final bool? isLastPage;

  /// Item builder.
  final Widget Function(Object, int? index) itemBuilder;

  /// Items to build.
  final List<Object> items;

  /// Used for pagination (infinite scroll). Called when user scrolls
  /// to the very end of the list (minus [onEndReachedThreshold]).
  final Future<void> Function()? onEndReached;

  /// A representation of how a [ScrollView] should dismiss the on-screen keyboard.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// Used for pagination (infinite scroll) together with [onEndReached]. Can be anything from 0 to 1, where 0 is immediate load of the next page as soon as scroll starts, and 1 is load of the next page only if scrolled to the very end of the list. Default value is 0.75, e.g. start loading next page when scrolled through about 3/4 of the available content.
  final double? onEndReachedThreshold;

  /// Scroll controller for the main [CustomScrollView]. Also used to auto scroll
  /// to specific messages.
  final ScrollController scrollController;

  /// Determines the physics of the scroll view.
  final ScrollPhysics? scrollPhysics;

  /// Used to build typing indicator according to options.
  /// See [TypingIndicatorOptions].
  final TypingIndicatorOptions? typingIndicatorOptions;

  /// Whether to use top safe area inset for the list.
  final bool useTopSafeAreaInset;

  ///
  final bool? isManuallyHideKeyboard;

  final BuildContext? contextForKeyboard;

  // final ScrollPhysics physics;
  final bool isOwnerAddedMessage;

  @override
  State<ChatList> createState() => _ChatListState();
}

/// [ChatList] widget state.
class _ChatListState extends State<ChatList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final bool _indicatorOnScrollStatus = false;
  final ValueNotifier<bool> _isNextPageLoadingNotifier =
      ValueNotifier<bool>(false);
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  late List<Object> _oldData = List.from(widget.items);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );

    didUpdateWidget(widget);
  }

  void _calculateDiffs(List<Object> oldList) async {
    final diffResult = calculateListDiff<Object>(
      oldList,
      widget.items,
      equalityChecker: (item1, item2) {
        if (item1 is Map<String, Object> && item2 is Map<String, Object>) {
          final message1 = item1['message']! as MessageModel;
          final message2 = item2['message']! as MessageModel;

          return message1.id == message2.id;
        } else {
          return item1 == item2;
        }
      },
    );

    for (final update in diffResult.getUpdates(batch: false)) {
      update.when(
        insert: (pos, count) {
          _listKey.currentState?.insertItem(pos);
        },
        remove: (pos, count) {
          final item = oldList[pos];
          _listKey.currentState?.removeItem(
            pos,
            (_, animation) => _removedMessageBuilder(item, animation),
          );
        },
        change: (pos, payload) {},
        move: (from, to) {},
      );
    }

    _scrollToBottomIfNeeded(oldList);

    _oldData = List.from(widget.items);
  }

  Widget _newMessageBuilder(int index, Animation<double> animation) {
    try {
      final item = _oldData[index];

      return SizeTransition(
        key: _valueKeyForItem(item),
        axisAlignment: -1,
        sizeFactor: animation.drive(CurveTween(curve: Curves.decelerate)),
        child: widget.itemBuilder(item, index),
      );
    } catch (e) {
      return const SizedBox();
    }
  }

  Widget _removedMessageBuilder(Object item, Animation<double> animation) =>
      SizeTransition(
        key: _valueKeyForItem(item),
        axisAlignment: -1,
        sizeFactor: animation.drive(CurveTween(curve: Curves.easeInQuad)),
        child: FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.easeInQuad)),
          child: widget.itemBuilder(item, null),
        ),
      );

  // Hacky solution to reconsider.
  void _scrollToBottomIfNeeded(List<Object> oldList) {
    try {
      // Take index 1 because there is always a spacer on index 0.
      final oldItem = oldList[1];
      final item = widget.items[1];

      if (oldItem is Map<String, Object> && item is Map<String, Object>) {
        final oldMessage = oldItem['message']! as MessageModel;
        final message = item['message']! as MessageModel;

        // Compare items to fire only on newly added messages.
        if (oldMessage.id != message.id) {
          // Run only for sent message.
          if (message.isOwner ?? false) {
            // Delay to give some time for Flutter to calculate new
            // size after new message was added.
            Future.delayed(const Duration(milliseconds: 100), () {
              if (widget.scrollController.hasClients) {
                widget.scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInQuad,
                );
              }
            });
          }
        }
      }
    } catch (e) {
      // Do nothing if there are no items.
    }
  }

  Key? _valueKeyForItem(Object item) =>
      _mapMessage(item, (message) => ValueKey(message.id));

  T? _mapMessage<T>(Object maybeMessage, T Function(MessageModel) f) {
    if (maybeMessage is Map<String, Object>) {
      return f(maybeMessage['message'] as MessageModel);
    }
    return null;
  }

  @override
  void didUpdateWidget(covariant ChatList oldWidget) {
    super.didUpdateWidget(oldWidget);

    _calculateDiffs(oldWidget.items);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (widget.onEndReached == null || widget.isLastPage == true) {
            return false;
          }

          if (notification.metrics.pixels >=
              (notification.metrics.maxScrollExtent *
                  (widget.onEndReachedThreshold ?? 0.85))) {
            if (widget.items.isEmpty || _isNextPageLoadingNotifier.value) {
              return false;
            }

            _controller.duration = Duration.zero;
            _controller.forward();

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (mounted) {
                _isNextPageLoadingNotifier.value = true;
              }
            });

            widget.onEndReached!().whenComplete(() {
              _controller.duration = const Duration(milliseconds: 500);
              _controller.reverse();

              WidgetsBinding.instance.addPostFrameCallback((_) async {
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    _isNextPageLoadingNotifier.value = false;
                  }
                });
              });
            });
          }

          return false;
        },
        child: Stack(
          children: [
            CustomScrollView(
              controller: widget.scrollController,
              physics: const BouncingScrollPhysics(),
              reverse: true,
              slivers: [
                if (widget.bottomWidget != null)
                  SliverToBoxAdapter(child: widget.bottomWidget),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 4),
                  sliver: SliverToBoxAdapter(
                    child:
                        widget.typingIndicatorOptions?.customTypingIndicator ??
                            TypingIndicator(
                              bubbleAlignment: widget.bubbleRtlAlignment,
                              options: widget.typingIndicatorOptions!,
                              showIndicator: (widget.typingIndicatorOptions!
                                      .typingUsers.isNotEmpty &&
                                  !_indicatorOnScrollStatus),
                            ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 4),
                  sliver: SliverAnimatedList(
                    findChildIndexCallback: (Key key) {
                      if (key is ValueKey<Object>) {
                        final newIndex = widget.items.indexWhere(
                          (v) => _valueKeyForItem(v) == key,
                        );
                        if (newIndex != -1) {
                          return newIndex;
                        }
                      }
                      return null;
                    },
                    initialItemCount: widget.items.length,
                    key: _listKey,
                    itemBuilder: (_, index, animation) =>
                        _newMessageBuilder(index, animation),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isNextPageLoadingNotifier,
                      builder: (context, value, child) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          child: !value
                              ? const SizedBox.shrink()
                              : Container(
                                  padding: const EdgeInsets.only(top: 8),
                                  alignment: Alignment.center,
                                  height: 32,
                                  width: 32,
                                  child: SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        InheritedChatTheme.of(context)
                                            .theme
                                            .primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            ScrollToTopBtn(
              scrollController: widget.scrollController,
              isShow: true,
            ),
          ],
        ),
      );
}

// class AlwaysScrollableFixedPositionScrollPhysics extends ScrollPhysics {
//   /// Creates scroll physics that always lets the user scroll.
//   const AlwaysScrollableFixedPositionScrollPhysics({ScrollPhysics? parent})
//       : super(parent: parent);

//   @override
//   AlwaysScrollableFixedPositionScrollPhysics applyTo(ScrollPhysics? ancestor) {
//     return AlwaysScrollableFixedPositionScrollPhysics(
//         parent: buildParent(ancestor));
//   }

//   @override
//   double adjustPositionForNewDimensions({
//     required ScrollMetrics oldPosition,
//     required ScrollMetrics newPosition,
//     required bool isScrolling,
//     required double velocity,
//   }) {
//     final pos = super.adjustPositionForNewDimensions(
//       oldPosition: oldPosition,
//       newPosition: newPosition,
//       isScrolling: isScrolling,
//       velocity: velocity,
//     );
//     if (!isScrolling) {
//       return newPosition.maxScrollExtent + oldPosition.extentAfter;
//     } else {
//       return pos;
//     }
//   }

//   @override
//   bool shouldAcceptUserOffset(ScrollMetrics position) => true;
// }

// class PositionRetainedScrollPhysics extends ScrollPhysics {
//   final bool shouldRetain;
//   const PositionRetainedScrollPhysics({super.parent, this.shouldRetain = true});

//   @override
//   PositionRetainedScrollPhysics applyTo(ScrollPhysics? ancestor) {
//     return PositionRetainedScrollPhysics(
//       parent: buildParent(ancestor),
//       shouldRetain: shouldRetain,
//     );
//   }

//   @override
//   double adjustPositionForNewDimensions({
//     required ScrollMetrics oldPosition,
//     required ScrollMetrics newPosition,
//     required bool isScrolling,
//     required double velocity,
//   }) {
//     final position = super.adjustPositionForNewDimensions(
//       oldPosition: oldPosition,
//       newPosition: newPosition,
//       isScrolling: isScrolling,
//       velocity: velocity,
//     );

//     final diff = newPosition.maxScrollExtent - oldPosition.extentAfter;

//     if (oldPosition.pixels > oldPosition.minScrollExtent &&
//         diff > 0 &&
//         shouldRetain &&
//         !isScrolling) {
//       return position + diff;
//     } else {
//       return position;
//     }
//   }
// }

// class CustomScrollPhysics extends ScrollPhysics {
//   const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

//   @override
//   CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
//     return CustomScrollPhysics(parent: buildParent(ancestor));
//   }

//   @override
//   double applyBoundaryConditions(ScrollMetrics position, double value) {
//     final double minScrollExtent = position.minScrollExtent;
//     final double maxScrollExtent = position.maxScrollExtent;

//     // Prevent scrolling beyond the minimum and maximum scroll extents
//     // if(isScro)
//     if (value < minScrollExtent) {
//       return minScrollExtent;
//     }
//     if (value > maxScrollExtent) return maxScrollExtent;
//     return value;
//   }
// }
