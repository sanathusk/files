import 'package:files/widgets/context_menu/context_menu_theme.dart';
import 'package:files/widgets/context_menu/context_sub_menu_entry.dart';
import 'package:flutter/material.dart';

abstract class BaseContextMenuEntry<T> extends PopupMenuEntry<T> {
  /// A widget to display before the title.
  /// Typically a [Icon] widget.
  final Widget? leading;

  /// The primary content of the menu entry.
  /// Typically a [Text] widget.
  final Widget title;

  /// bool flag to block gestures from user
  final bool enabled;

  const BaseContextMenuEntry({
    required this.title,
    this.leading,
    this.enabled = true,
    super.key,
  });

  @override
  double get height => 48;

  @override
  bool represents(T? value);
}

/// [ContextSubMenuEntry] is a [PopupMenuEntry] that displays a base menu entry.
class ContextMenuEntry<T> extends BaseContextMenuEntry<T> {
  /// Using for [represents] method.
  final T id;

  /// A tap with a primary button has occurred.
  final VoidCallback? onTap;

  /// Optional content to display keysequence after the title.
  /// Typically a [Text] widget.
  final Widget? shortcut;

  const ContextMenuEntry({
    required this.id,
    required super.title,
    this.onTap,
    super.leading,
    this.shortcut,
    super.enabled = true,
    super.key,
  });

  @override
  _ContextMenuEntryState createState() => _ContextMenuEntryState();

  @override
  bool represents(T? value) => id == value;
}

class _ContextMenuEntryState extends State<ContextMenuEntry> {
  @override
  Widget build(BuildContext context) {
    final ContextMenuTheme menuTheme =
        Theme.of(context).extension<ContextMenuTheme>()!;

    return InkWell(
      onTap: widget.enabled
          ? () {
              Navigator.pop(context);
              widget.onTap?.call();
            }
          : null,
      child: Container(
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (widget.leading != null) ...[
              IconTheme.merge(
                data: IconThemeData(
                  size: menuTheme.iconSize,
                  color: widget.enabled
                      ? menuTheme.iconColor
                      : menuTheme.disabledIconColor,
                ),
                child: widget.leading!,
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: menuTheme.fontSize,
                  color: widget.enabled
                      ? menuTheme.textColor
                      : menuTheme.disabledTextColor,
                ),
                overflow: TextOverflow.ellipsis,
                child: widget.title,
              ),
            ),
            if (widget.shortcut != null)
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: menuTheme.fontSize,
                  color: widget.enabled
                      ? menuTheme.shortcutColor
                      : menuTheme.disabledShortcutColor,
                ),
                overflow: TextOverflow.ellipsis,
                child: widget.shortcut!,
              ),
          ],
        ),
      ),
    );
  }
}

/// A horizontal divider in a Material Design popup menu.
class ContextMenuDivider extends BaseContextMenuEntry<Never> {
  const ContextMenuDivider({super.key}) : super(title: const SizedBox());

  @override
  bool represents(void value) => false;

  @override
  double get height => 8;

  @override
  State<ContextMenuDivider> createState() => _ContextMenuDividerState();
}

class _ContextMenuDividerState extends State<ContextMenuDivider> {
  @override
  Widget build(BuildContext context) => Divider(height: widget.height);
}
