import 'package:flutter/material.dart';

class ScrollToTopBtn extends StatefulWidget {
  const ScrollToTopBtn({
    required this.scrollController,
    super.key,
    this.isShow,
  });
  final ScrollController scrollController;
  final bool? isShow;

  @override
  State<ScrollToTopBtn> createState() => _ScrollToTopBtnState();
}

class _ScrollToTopBtnState extends State<ScrollToTopBtn> {
  bool isShowScrollToTop = false;
  bool isScrollingTop = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScrollToTop);
  }

  void _onScrollToTop() {
    if (!mounted) return;
    if (_isShowScrollToTop) {
      setState(() {
        isShowScrollToTop = true;
      });
    }
    if (_isHideScrollToTop) {
      setState(() {
        isShowScrollToTop = false;
        isScrollingTop = false;
      });
    }
  }

  bool get _isShowScrollToTop {
    if (!widget.scrollController.hasClients) return false;
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.offset;
    return currentScroll >= (maxScroll * .3);
  }

  bool get _isHideScrollToTop {
    if (!widget.scrollController.hasClients) return false;
    final minScroll = widget.scrollController.position.minScrollExtent;
    final currentScroll = widget.scrollController.offset;
    return currentScroll == minScroll;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      bottom: !((widget.isShow ?? false) && isShowScrollToTop) ? -100 : 25,
      right: 20,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isScrollingTop = true;
          });
          widget.scrollController.animateTo(
            widget.scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 217, 237, 254),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(16),
          child: const Icon(
            Icons.keyboard_double_arrow_down,
            size: 20,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
