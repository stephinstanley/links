import 'package:flutter/material.dart';
import 'package:links/features/links/models/link.dart';

class LinkCard extends StatefulWidget {
  final Link link;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;
  final VoidCallback? onOpen;

  const LinkCard({
    super.key,
    required this.link,
    this.onEdit,
    this.onDelete,
    this.onShare,
    this.onOpen,
  });

  @override
  State<LinkCard> createState() => _LinkCardState();
}

class _LinkCardState extends State<LinkCard> {
  bool _isHovered = false;

  // Use default icon and color for all cards
  static const IconData defaultIcon = Icons.link_rounded;
  static const Color defaultColor = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const categoryIcon = defaultIcon;
    const categoryColor = defaultColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Dismissible(
        key: Key(widget.link.url),
        direction: widget.onDelete == null
            ? DismissDirection.none
            : DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.red.withOpacity(0.9),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(
            Icons.delete_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        onDismissed: (_) {
          widget.onDelete?.call();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Link deleted'),
              duration: const Duration(milliseconds: 2000),
            ),
          );
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isHovered
                    ? categoryColor.withOpacity(0.3)
                    : colorScheme.outlineVariant.withOpacity(0.2),
                width: 0.5,
              ),
              color: _isHovered
                  ? categoryColor.withOpacity(0.03)
                  : colorScheme.surface,
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: categoryColor.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: InkWell(
              onTap: widget.onOpen,
              borderRadius: BorderRadius.circular(12),
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    // Category Icon - Large visual indicator
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: categoryColor.withOpacity(0.2),
                          width: 1.2,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          categoryIcon,
                          color: categoryColor,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Content - Title and URL
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title
                          Text(
                            widget.link.title,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.2,
                                  height: 1.3,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          // URL
                          Text(
                            widget.link.url,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.1,
                                  height: 1.3,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: categoryColor.withOpacity(0.3),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              widget.link.tag,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: categoryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // More menu button
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          widget.onEdit?.call();
                        } else if (value == 'delete') {
                          widget.onDelete?.call();
                        } else if (value == 'share') {
                          widget.onShare?.call();
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        if (widget.onEdit != null)
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_rounded, size: 18),
                                SizedBox(width: 12),
                                Text('Edit'),
                              ],
                            ),
                          ),
                        if (widget.onShare != null)
                          const PopupMenuItem<String>(
                            value: 'share',
                            child: Row(
                              children: [
                                Icon(Icons.share_rounded, size: 18),
                                SizedBox(width: 12),
                                Text('Share'),
                              ],
                            ),
                          ),
                        if (widget.onDelete != null)
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_rounded,
                                  size: 18,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                      ],
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.more_vert_rounded,
                          size: 18,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
