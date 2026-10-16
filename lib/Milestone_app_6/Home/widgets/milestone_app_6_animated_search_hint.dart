import 'package:app_matic_tech_flutter_app/Milestone_app_6/theme/milestone_app_6_colors.dart';
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
      duration: const Duration(milliseconds: 500),
    );

    _focusNode = FocusNode()
      ..addListener(() {
        if (mounted) setState(() {});
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
      return 'Search for dishes or restaurants';
    }

    return 'Search for "${widget.searchHints[index % widget.searchHints.length]}"';
  }

  void _openSearch() {
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasText = widget.controller.text.trim().isNotEmpty;
    final showTextField = hasText || _focusNode.hasFocus;

    final background = isDark
        ? MilestoneApp6Colors.red.withOpacity(0.16)
        : MilestoneApp6Colors.red.withOpacity(0.08);

    final foreground = isDark ? Colors.white70 : const Color(0xFF786858);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: MilestoneApp6Colors.red.withOpacity(isDark ? 0.25 : 0.15),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 13),
          Icon(
            Icons.search_rounded,
            size: 21,
            color: foreground,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: SizedBox(
              height: 24,
              child: widget.isListening
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Listening...',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: foreground,
                        ),
                      ),
                    )
                  : showTextField
                      ? TextField(
                          controller: widget.controller,
                          focusNode: _focusNode,
                          textInputAction: TextInputAction.search,
                          maxLines: 1,
                          cursorColor: theme.colorScheme.primary,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurface,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Search for dishes or restaurants',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                        )
                      : GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _openSearch,
                          child: ClipRect(
                            child: AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                final value = Curves.easeInOutCubic.transform(
                                  _animationController.value,
                                );

                                return Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Transform.translate(
                                      offset: Offset(0, -20 * value),
                                      child: _hint(
                                        _getHintText(_oldIndex),
                                        foreground,
                                      ),
                                    ),
                                    Transform.translate(
                                      offset: Offset(
                                        0,
                                        20 * (1 - value),
                                      ),
                                      child: _hint(
                                        _getHintText(_newIndex),
                                        foreground,
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
          if (hasText)
            IconButton(
              onPressed: widget.onClear,
              tooltip: 'Clear search',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 34,
                minHeight: 40,
              ),
              icon: Icon(
                Icons.close_rounded,
                size: 18,
                color: foreground,
              ),
            ),
          IconButton(
            onPressed: widget.onMicTap,
            tooltip: 'Voice search',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 42,
              minHeight: 40,
            ),
            icon: Icon(
              widget.isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
              size: 21,
              color: widget.isListening ? Colors.redAccent : foreground,
            ),
          ),
          const SizedBox(width: 3),
        ],
      ),
    );
  }

  Widget _hint(String text, Color color) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: color,
      ),
    );
  }
}
