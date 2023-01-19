/*
TODO :
- Add a stacked sidebar for mobile view
- Add a drawer for mobile view
- add scrollable sidebar for many items
 */

import 'package:animated_sidebar/src/sidebar_item.dart';
import 'package:flutter/material.dart';

// mark as not immutable
class AnimatedSidebar extends StatefulWidget {
  //functionality
  final List<SidebarItem> items;
  final void Function(int index) onItemSelected;
  final double minSize;
  final double maxSize;
  final int selectedIndex;
  final bool expanded;
  final EdgeInsets margin;
  final Duration duration;
  final Curve curve;
  //item style
  final double itemIconSize;
  final Color itemIconColor;
  final TextStyle itemTextStyle;
  final double itemSpaceBetween;
  final Color? itemSelectedColor;
  final Color? itemHoverColor;
  final BorderRadiusGeometry itemSelectedBorder;
  final double itemMargin;
  final IconData? switchIconExpanded;
  final IconData? switchIconCollapsed;
  //frame
  final BoxDecoration frameDecoration;
  final EdgeInsetsGeometry frameMargin;
  //header
  final Widget? header;
  final IconData? headerIcon;
  final double? headerIconSize;
  final Color? headerIconColor;
  final TextStyle? headerTextStyle;
  final String? headerText;
  //footer
  final Widget? footer;

  const AnimatedSidebar({
    Key? key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.expanded = true,
    this.margin = const EdgeInsets.all(16),
    this.minSize = 90,
    this.maxSize = 250,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOut,
    this.itemIconSize = 32,
    this.itemIconColor = Colors.white,
    this.itemTextStyle = const TextStyle(
        fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
    this.itemSpaceBetween = 8,
    this.itemSelectedColor =
        const Color.fromRGBO(48, 79, 254, 1), //MaterialIndigo
    this.itemHoverColor =
        const Color.fromRGBO(48, 79, 254, 0.3), //MaterialIndigo
    this.itemSelectedBorder = const BorderRadius.all(Radius.circular(5)),
    this.itemMargin = 16,
    this.switchIconExpanded = Icons.arrow_back_rounded,
    this.switchIconCollapsed = Icons.arrow_forward_rounded,
    this.frameDecoration = const BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(66, 66, 66, 0.75),
          spreadRadius: 0,
          blurRadius: 20,
          offset: Offset(0, 10),
        ),
      ],
    ),
    this.frameMargin = EdgeInsets.zero,
    this.header,
    this.headerIcon,
    this.headerIconSize = 32,
    this.headerIconColor = Colors.blueAccent,
    this.headerTextStyle = const TextStyle(
        fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
    this.headerText,
    this.footer,
  })  : assert((headerIcon != null && headerText != null) ^ (header != null)),
        super(key: key);

  @override
  State<AnimatedSidebar> createState() => _AnimatedSidebarState();
}

class _AnimatedSidebarState extends State<AnimatedSidebar>
    with TickerProviderStateMixin {
  bool _inAnimation = false;
  bool _expanded = true;
  int _onHoverIndex = -1;

  void _resize() {
    setState(() {
      _expanded = !_expanded;
      _inAnimation = true;
    });
  }

  void _setInAnimation(bool value) {
    setState(() {
      _inAnimation = value;
    });
  }

  void _setOnHover(int index) {
    setState(() {
      _onHoverIndex = index;
    });
  }

  void _setExitHover() {
    setState(() {
      _onHoverIndex = -1;
    });
  }

  double _calculateItemOffset() {
    return (widget.minSize - widget.itemMargin * 2 - widget.itemIconSize) / 2;
  }

  double _calculateHeaderItemOffset() {
    return (widget.minSize -
            widget.itemMargin * 2 -
            (widget.headerIconSize ?? 0)) /
        2;
  }

  @override
  void initState() {
    _expanded = widget.expanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: widget.margin,
      width: _expanded ? widget.maxSize : widget.minSize,
      duration: widget.duration,
      curve: widget.curve,
      onEnd: () => _setInAnimation(false),
      child: _buildFrame(),
    );
  }

  Widget _buildFrame() {
    return Container(
      margin: widget.frameMargin,
      height: double.infinity,
      decoration: widget.frameDecoration,
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    return Container(
      margin: EdgeInsets.all(widget.itemMargin),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget.header != null ? _buildCustomHeader() : _buildIconTextHeader(),
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            height: 1,
            color: Colors.grey,
          ),
          Expanded(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return ConstrainedBox(
                constraints: constraints,
                child: SingleChildScrollView(
                  child: Column(
                    children: _buildMenuItems(),
                  ),
                ),
              );
            }),
          ),
          _buildSwitchButton(),
        ],
      ),
    );
  }

  IconButton _buildSwitchButton() {
    return IconButton(
        onPressed: () {
          setState(() {
            if (_inAnimation) return;
            _resize();
          });
        },
        icon: Icon(
            _expanded ? widget.switchIconExpanded : widget.switchIconCollapsed,
            color: _inAnimation ? Colors.transparent : widget.itemIconColor));
  }

  Widget _buildIconTextHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _calculateHeaderItemOffset()),
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.headerIcon,
            color: widget.headerIconColor,
            size: widget.headerIconSize,
          ),
          _expanded || _inAnimation
              ? Flexible(
                  child: Text(
                    widget.headerText ?? 'missing',
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                    style: widget.headerTextStyle,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildCustomHeader() {
    return widget.header ?? Container();
  }

  List<Widget> _buildMenuItems() {
    List<Widget> items = [];
    for (int i = 0; i < widget.items.length; i++) {
      items.add(
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onHover: (_) => _setOnHover(i),
          onExit: (_) => _setExitHover(),
          child: GestureDetector(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              decoration: BoxDecoration(
                  borderRadius: widget.itemSelectedBorder,
                  color: i == widget.selectedIndex
                      ? widget.itemSelectedColor
                      : (i == _onHoverIndex
                          ? widget.itemHoverColor
                          : Colors.transparent)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: _calculateItemOffset(),
                  ),
                  Icon(
                    widget.items[i].icon,
                    color: widget.itemIconColor,
                    size: widget.itemIconSize,
                  ),
                  _expanded || _inAnimation
                      ? const Padding(padding: EdgeInsets.only(left: 8))
                      : const SizedBox.shrink(),
                  _expanded || _inAnimation
                      ? Flexible(
                          child: Text(
                            widget.items[i].text,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style: widget.itemTextStyle,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            onTap: () => widget.onItemSelected(i),
          ),
        ),
      );
      items.add(
        SizedBox(
          height: widget.itemSpaceBetween,
        ),
      );
    }
    return items;
  }
}
