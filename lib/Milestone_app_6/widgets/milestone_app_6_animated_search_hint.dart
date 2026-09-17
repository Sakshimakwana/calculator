import 'package:flutter/material.dart';

class HomeSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final int searchHintIndex;
  final List<String> searchHints;
  final bool isListening;
  final VoidCallback onMicTap;
  final VoidCallback onClear;

  const HomeSearchBar({
    super.key,
    required this.controller,
    required this.searchHintIndex,
    required this.searchHints,
    required this.isListening,
    required this.onMicTap,
    required this.onClear,
  });

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final FocusNode _focusNode;

  int _oldIndex = 0;
  int _newIndex = 0;

  @override
  void initState() {
    super.initState();

    _oldIndex = widget.searchHintIndex;
    _newIndex = widget.searchHintIndex;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(covariant HomeSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.searchHintIndex != oldWidget.searchHintIndex &&
        widget.searchHints.isNotEmpty &&
        widget.controller.text.trim().isEmpty &&
        !widget.isListening) {
      _oldIndex = _newIndex;
      _newIndex = widget.searchHintIndex;

      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _getHintText(int index) {
    if (widget.searchHints.isEmpty) {
      return 'Search for "Food"';
    }

    final String category =
    widget.searchHints[index % widget.searchHints.length];

    return 'Search for "$category"';
  }

  void _openSearch() {
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = widget.controller.text.trim().isNotEmpty;

    final bool showTextField =
        hasText || _focusNode.hasFocus;

    return Container(
      height: 54,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1E8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),

          // ============================================================
          // SEARCH ICON
          // ============================================================

          const Icon(
            Icons.search_rounded,
            size: 23,
            color: Color(0xFFE87961),
          ),

          const SizedBox(width: 10),

          // ============================================================
          // SEARCH CONTENT
          // ============================================================

          Expanded(
            child: SizedBox(
              height: 24,
              child: widget.isListening
                  ? const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Listening...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF8E6D63),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
                  : showTextField
                  ? TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                autofocus: false,
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.text,
                maxLines: 1,
                cursorColor: const Color(0xFFE87961),
                decoration: const InputDecoration(
                  filled: false,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                style: const TextStyle(
                  color: Color(0xFF3D2924),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              )
                  : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _openSearch,
                child: ClipRect(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final double value = CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeInOutCubic,
                      ).value;

                      return Stack(
                        clipBehavior: Clip.hardEdge,
                        alignment: Alignment.centerLeft,
                        children: [
                          // OLD HINT: CENTER → TOP
                          Transform.translate(
                            offset: Offset(
                              0,
                              -24 * value,
                            ),
                            child: Text(
                              _getHintText(_oldIndex),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF8E6D63),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          // NEW HINT: BOTTOM → CENTER
                          Transform.translate(
                            offset: Offset(
                              0,
                              24 * (1 - value),
                            ),
                            child: Text(
                              _getHintText(_newIndex),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF8E6D63),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // ============================================================
          // CLEAR BUTTON
          // ============================================================

          if (hasText)
            IconButton(
              onPressed: widget.onClear,
              splashRadius: 20,
              tooltip: 'Clear search',
              icon: const Icon(
                Icons.close_rounded,
                size: 20,
                color: Color(0xFF8E6D63),
              ),
            ),

          // ============================================================
          // MICROPHONE
          // ============================================================

          IconButton(
            onPressed: widget.onMicTap,
            splashRadius: 22,
            tooltip: 'Voice search',
            icon: Icon(
              widget.isListening
                  ? Icons.mic_rounded
                  : Icons.mic_none_rounded,
              size: 22,
              color: widget.isListening
                  ? const Color(0xFFE85D5D)
                  : const Color(0xFF8E6D63),
            ),
          ),

          const SizedBox(width: 3),
        ],
      ),
    );
  }
}