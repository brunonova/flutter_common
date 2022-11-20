// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:flutter/material.dart';

import '../utils/functions.dart';
import 'platform_reorderable_drag_start_listener.dart';

/// Controller for the [AnimatedReorderableListView].
///
/// The items for the [AnimatedReorderableListView] should be provided to this
/// controller.
///
/// To add an item to the list, just add it normally to the provided list.
/// To removed it and animate the removal, please call [hide] or [hideAt] and
/// await it, then remove that item from the list.
class AnimatedListController<T> {
  AnimatedListController(this.items);

  /// Run the animation to hide the given item. The [Future] will complete
  /// when the animation ends.
  Future<void> hide(T item) async {
    await _hideListeners[item]?.call();
  }

  /// Run the animation to hide the given item. The [Future] will complete
  /// when the animation ends.
  Future<void> hideAt(int index) async {
    await hide(items[index]);
  }

  /// Add a listener to be called when the given item is hidden.
  /// Used by [_AnimatedListItem].
  void _addHideListener(T item, Future<void> Function() listener) =>
      _hideListeners[item] = listener;

  /// Remove the listener that was added for the given item.
  void _removeHideListener(T item) => _hideListeners.remove(item);

  /// The list of items.
  final List<T> items;

  /// The listeners for each item called when hiding the respective item.
  final Map<T, Future<void> Function()> _hideListeners = {};
}

/// A [ReorderableListView] that animates insertions and removals.
class AnimatedReorderableListView<T> extends StatefulWidget {
  const AnimatedReorderableListView({
    super.key,
    this.scrollController,
    this.padding,
    this.buildDefaultDragHandles = true,
    required this.controller,
    required this.onReorder,
    this.buildTransition,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationCurve = Curves.easeInOut,
    this.header,
    this.footer,
    required this.buildItem,
  });

  /// [ScrollController] for the [ReorderableListView].
  final ScrollController? scrollController;

  /// Padding for the [ReorderableListView].
  final EdgeInsets? padding;

  /// Whether to add the default drag handles to the [ReorderableListView].
  /// If false, dragging will be handled by a
  /// [PlatformReorderableDragStartListener].
  final bool buildDefaultDragHandles;

  /// Controller for the list. It should contain the items of the list, and
  /// its "hide" or "hideAt" methods should be called and awaited before
  /// removing an item from the list.
  final AnimatedListController controller;

  /// Function to call when an item is dragged to another position in the list.
  final void Function(int oldIndex, int newIndex) onReorder;

  /// Function to call to build the [AnimatedWidget] that does the animation.
  /// By default it builds a [SizeTransition] and a [FadeTransition].
  final AnimatedWidget Function({Animation<double> animation, Widget child})?
      buildTransition;

  /// Duration of the animation.
  final Duration animationDuration;

  /// Curve of the animation.
  final Curve animationCurve;

  /// Widget to show before the list items (not draggable).
  final Widget? header;

  /// Widget to show after the list items (not draggable).
  final Widget? footer;

  /// Function to call to build the given item at the given index.
  final Widget Function(T item, int index) buildItem;

  @override
  State<AnimatedReorderableListView<T>> createState() =>
      _AnimatedReorderableListViewState<T>();
}

class _AnimatedReorderableListViewState<T>
    extends State<AnimatedReorderableListView<T>> {
  bool _animateInsertion = false;

  @override
  void initState() {
    super.initState();

    // Don't animate the insertion for the initial items.
    // Enable the animation only after the next frame.
    // No setState() called here because there's no need to rebuild the tree.
    onNextFrame((timestamp) => _animateInsertion = true);
  }

  @override
  Widget build(BuildContext context) {
    // Build the children
    final children = <Widget>[];
    for (int i = 0; i < widget.controller.items.length; i++) {
      T item = widget.controller.items[i];
      Widget child = widget.buildItem(item, i);

      // Wrap the child in this _AnimatedListItem widget
      child = _AnimatedListItem(
        key: child.key,
        item: item,
        animateInsertion: _animateInsertion,
        controller: widget.controller,
        buildTransition: widget.buildTransition,
        animationCurve: widget.animationCurve,
        child: child,
      );

      if (!widget.buildDefaultDragHandles) {
        // No drag handles: add the child to a
        // PlatformReorderableDragStartListener.
        child = PlatformReorderableDragStartListener(
          // No dragging if there's only 1 item in the list (to avoid a weird
          // animation)
          enabled: widget.controller.items.length > 1,
          index: i,
          key: child.key,
          child: child,
        );
      }

      children.add(child);
    }

    // Build the list view
    return ReorderableListView(
      scrollController: widget.scrollController,
      padding: widget.padding,
      buildDefaultDragHandles: widget.buildDefaultDragHandles,
      onReorder: widget.onReorder,
      header: widget.header,
      footer: widget.footer,
      children: children,
    );
  }
}

/// Each item in the list is wrapped in a widget of this class, which handles
/// the animations.
class _AnimatedListItem<T> extends StatefulWidget {
  const _AnimatedListItem({
    super.key,
    required this.item,
    required this.animateInsertion,
    required this.controller,
    this.buildTransition,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationCurve = Curves.easeInOut,
    required this.child,
  });

  /// The item in the list that this widget refers to.
  final T item;

  /// Whether to animate the insertion of this element.
  final bool animateInsertion;

  /// Controller for the list.
  final AnimatedListController controller;

  /// Function to call to build the [AnimatedWidget] that does the animation.
  /// By default it builds a [SizeTransition] and a [FadeTransition].
  final AnimatedWidget Function({Animation<double> animation, Widget child})?
      buildTransition;

  /// Duration of the animation.
  final Duration animationDuration;

  /// Curve of the animation.
  final Curve animationCurve;

  /// The child widget.
  final Widget child;

  @override
  State<_AnimatedListItem> createState() => _AnimatedListItemState<T>();
}

class _AnimatedListItemState<T> extends State<_AnimatedListItem>
    with TickerProviderStateMixin {
  /// Controller for the animation.
  late final AnimationController _animationController = AnimationController(
    duration: widget.animationDuration,
    vsync: this,
  );

  /// The animation.
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: widget.animationCurve,
  );

  @override
  void initState() {
    super.initState();

    // Start animation (if enabled)
    _animationController.forward(from: widget.animateInsertion ? 0.0 : 1.0);
    widget.controller._addHideListener(widget.item, _onHide);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller._removeHideListener(widget.item);
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buildTransition != null) {
      return widget.buildTransition!(
        animation: _animation,
        child: widget.child,
      );
    } else {
      // Default transitions
      return SizeTransition(
        sizeFactor: _animation,
        axis: Axis.vertical,
        axisAlignment: -1,
        child: FadeTransition(
          opacity: _animation,
          child: widget.child,
        ),
      );
    }
  }

  /// Called to hide the item.
  Future<void> _onHide() async {
    await _animationController.reverse();
  }
}
