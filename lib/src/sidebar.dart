import 'package:animated_sidebar/src/sidebar_item.dart';
import 'package:flutter/material.dart';

/// AnimatedSidebar is a stateful widget that displays a sidebar that can
/// Collapse and Expand.
///
/// see: [git](https://github.com/kesimo/animated_sidebar)
class AnimatedSidebar extends StatefulWidget {
  /// A list of SidebarItem objects. Contains the text and icon for each item.
  final List<SidebarItem> items;

  /// This function is called when a sidebar item is tapped.
  /// It takes the index of the tapped item in [items] as a parameter.
  final void Function(int index) onItemSelected;

  /// The minimum width of the [AnimatedSidebar] when it is collapsed.
  final double minSize;

  /// The maximum width of the [AnimatedSidebar] when it is expanded.
  final double maxSize;

  /// The index of the selected item. based on the index of the element in the [items] list
  /// this is used to highlight the selected item.
  ///
  /// on page change, this value should be updated.
  ///
  /// NOTE:
  ///  * Prefer using [autoSelectedIndex] instead of this. so the selected item changes itself.
  ///    and you don't have to update it manually what causes a rebuild.
  ///  * If [autoSelectedIndex] is true, this value will be used as Initial value.
  final int selectedIndex;

  /// If true, the selected item will be automatically updated based on the last
  /// item that was tapped.
  ///
  /// NOTE:
  /// * If [autoSelectedIndex] is true, [selectedIndex] will be used as Initial value.
  final bool autoSelectedIndex;

  /// Used to determine the initial state of the sidebar.
  final bool expanded;

  /// The margin of the sidebar.
  final EdgeInsets margin;

  /// The duration of the animation.
  /// The default value is 250 milliseconds.
  final Duration duration;

  /// Used to determine the animation curve.
  /// The default value is [Curves.easeInOut].
  final Curve curve;

  /// The size of the [SidebarItem.icon] for all [items] in the sidebar.
  /// The default value is 32.0.
  final double itemIconSize;

  /// The color of the [SidebarItem.icon] for all [items] in the sidebar.
  /// The default value is [Colors.white].
  final Color itemIconColor;

  /// Set the text style of the [SidebarItem.text].
  final TextStyle itemTextStyle;

  /// The space between each item in [items].
  /// The default value is 8.0.
  final double itemSpaceBetween;

  /// The Color of the [SidebarItem] when it is selected
  /// OR: the [selectedIndex] is equal to the index of the item.
  ///
  /// The default value is [Colors.indigoAccent].
  final Color? itemSelectedColor;

  /// The Color of the [SidebarItem] when it is hovered.
  ///
  /// The default value is [Colors.indigoAccent] with 0.3 opacity.
  final Color? itemHoverColor;

  /// The border radius of the overlay on the selected [SidebarItem].
  final BorderRadiusGeometry itemSelectedBorder;

  /// The margin of the [SidebarItem].
  final double itemMargin;

  /// The [switchIconExpanded] that is displayed on the bottom of the sidebar
  /// when the sidebar is expanded.
  /// On tap, the sidebar will be collapsed.
  final IconData? switchIconExpanded;

  /// The [switchIconCollapsed] that is displayed on the bottom of the sidebar
  /// when the sidebar is collapsed.
  /// On tap, the sidebar will be expanded.
  final IconData? switchIconCollapsed;

  /// The decoration of the whole [AnimatedSidebar] frame.
  /// The default value is a [BoxDecoration] with a [BoxShadow] and a [BorderRadius] of 10.
  final BoxDecoration frameDecoration;

  /// The [header] can be used instead of combination of [headerIcon] and [headerText].
  /// for a custom header widget.
  ///
  /// Note:
  ///
  ///   * if [header] is not null, [headerIcon] and [headerText] will be ignored.
  ///   * the [header] should be a responsive widget.
  final Widget? header;

  /// The [headerIcon] is displayed on the top of the sidebar.
  ///
  /// if null, only the [headerText] will be displayed.
  final IconData? headerIcon;

  /// the size of the [headerIcon].
  final double? headerIconSize;

  /// The color of the [headerIcon].
  final Color? headerIconColor;

  /// the style of the [headerText].
  ///
  /// Overflow will be handled by [TextOverflow.fade].
  final TextStyle? headerTextStyle;

  /// The [headerText] is displayed on the top of the sidebar.
  final String? headerText;

  const AnimatedSidebar({
    Key? key,
    required this.items,
    this.selectedIndex = 0,
    this.autoSelectedIndex = true,
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
    this.header,
    this.headerIcon,
    this.headerIconSize = 32,
    this.headerIconColor = Colors.blueAccent,
    this.headerTextStyle = const TextStyle(
        fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
    this.headerText,
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
  int _selectedIndex = 0;
  int _expanedIndex = -1;

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

  void _setSelectedIndex(int index) {
    if (widget.autoSelectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    _expanded = widget.expanded;
    _selectedIndex = widget.selectedIndex;
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
      child: Column(
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
    int index = 0;
    for (int i = 0; i < widget.items.length; i++) {
      if (widget.items[i].children.isNotEmpty) {
        if (_expanded) {
          items.add(
            _buildMultiItem(index, widget.items[i]),
          );
          index += widget.items[i].children.length + 1;
        } else {
          items.add(
            _buildSingleItem(index, widget.items[i], false, false),
          );
          index++;
        }
      } else {
        items.add(
          _buildSingleItem(index, widget.items[i], false, false),
        );
        index++;
      }
      items.add(
        SizedBox(
          height: widget.itemSpaceBetween,
        ),
      );
    }
    return items;
  }

  Widget _buildSingleItem(
      int index, SidebarItem item, bool isChild, bool isHeader) {
    Color? color = index ==
            (widget.autoSelectedIndex ? _selectedIndex : widget.selectedIndex)
        ? widget.itemSelectedColor
        : (index == _onHoverIndex ? widget.itemHoverColor : Colors.transparent);

    bool colorHeader = !_expanded &&
        !_inAnimation &&
        isHeader &&
        index >= _expanedIndex &&
        index <
            _expanedIndex +
                widget.items[index - _expanedIndex].children.length +
                1;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) => _setOnHover(index),
      onExit: (_) => _setExitHover(),
      child: GestureDetector(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 4,
          ),
          decoration: BoxDecoration(
              borderRadius: widget.itemSelectedBorder,
              color: colorHeader ? widget.itemSelectedColor : color),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: _calculateItemOffset(),
              ),
              Icon(
                item.icon,
                color: widget.itemIconColor,
                size: widget.itemIconSize,
              ),
              _expanded || _inAnimation
                  ? const Padding(padding: EdgeInsets.only(left: 8))
                  : const SizedBox.shrink(),
              _expanded || _inAnimation
                  ? Flexible(
                      child: Text(
                        item.text,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: isChild
                            ? widget.itemTextStyle.copyWith(
                                color: widget.itemTextStyle.color
                                    ?.withOpacity(0.6))
                            : widget.itemTextStyle,
                      ),
                    )
                  : const SizedBox.shrink(),
              _expanded && !_inAnimation && isHeader
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: widget.itemIconSize,
                        color: widget.itemIconColor,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
        onTap: () {
          if (isHeader) {
            setState(() {
              _expanedIndex = index;
            });
          } else if (!isChild) {
            setState(() {
              _expanedIndex = -1;
            });
          }
          _setSelectedIndex(index);
          widget.onItemSelected(index);
        },
      ),
    );
  }

  Widget _buildMultiItem(int baseIndex, SidebarItem item) {
    List<Widget> childItems = [];
    for (int i = 0; i < item.children.length; i++) {
      childItems.add(
        SizedBox(
          height: widget.itemSpaceBetween,
        ),
      );
      childItems.add(
        _buildSingleItem(
            baseIndex + i + 1,
            SidebarItem(
              text: item.children[i].text,
              icon: item.children[i].icon,
            ),
            true,
            false),
      );
    }
    return Column(
      children: [
        _buildSingleItem(baseIndex, item, false, true),
        Container(
          margin: const EdgeInsets.only(left: 12),
          child: _expanded &&
                  !_inAnimation &&
                  ((_selectedIndex >= baseIndex &&
                          _selectedIndex <= baseIndex + childItems.length) ||
                      _expanedIndex == baseIndex)
              ? Column(
                  children: childItems,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
