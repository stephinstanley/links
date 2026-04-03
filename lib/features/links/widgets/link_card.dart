import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:links/features/links/models/link.dart';
import 'package:links/features/links/presentation/utils/tag_color_utils.dart';
import 'package:shimmer/shimmer.dart';

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
  static const double _avatarSize = 58;
  bool _isHovered = false;
  late Future<String?> _previewImageFuture;
  static final Map<String, String?> _previewImageCache = {};
  static final Map<String, Future<String?>> _inFlightPreviewRequests = {};

  @override
  void initState() {
    super.initState();
    _previewImageFuture = _resolvePreviewImage(widget.link.url);
  }

  @override
  void didUpdateWidget(covariant LinkCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.link.url != widget.link.url) {
      _previewImageFuture = _resolvePreviewImage(widget.link.url);
    }
  }

  Future<String?> _resolvePreviewImage(String rawUrl) {
    final normalizedUrl = rawUrl.trim();
    if (normalizedUrl.isEmpty) return Future.value(null);

    if (_previewImageCache.containsKey(normalizedUrl)) {
      return Future.value(_previewImageCache[normalizedUrl]);
    }

    final existingRequest = _inFlightPreviewRequests[normalizedUrl];
    if (existingRequest != null) return existingRequest;

    final request = () async {
      try {
        final previewData = await getLinkPreviewData(
          normalizedUrl,
          requestTimeout: const Duration(seconds: 4),
        );
        final imageUrl = previewData?.image?.url;
        _previewImageCache[normalizedUrl] = imageUrl;
        return imageUrl;
      } catch (_) {
        _previewImageCache[normalizedUrl] = null;
        return null;
      } finally {
        _inFlightPreviewRequests.remove(normalizedUrl);
      }
    }();

    _inFlightPreviewRequests[normalizedUrl] = request;
    return request;
  }

  void _showLinkDetailsSheet(
    BuildContext context,
    Color tagColor,
    String? titleInitial,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Action buttons row (top right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.onEdit != null) ...[
                      _buildSheetActionButton(
                        context: context,
                        icon: Icons.edit_rounded,
                        tooltip: 'Edit',
                        color: const Color(0xFFE6A817),
                        bgColor: Colors.white,
                        onTap: () {
                          Navigator.pop(context);
                          widget.onEdit?.call();
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (widget.onDelete != null)
                      _buildSheetActionButton(
                        context: context,
                        icon: Icons.delete_rounded,
                        tooltip: 'Delete',
                        color: Theme.of(context).colorScheme.error,
                        bgColor: Colors.white,
                        onTap: () {
                          Navigator.pop(context);
                          widget.onDelete?.call();
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // Title below the buttons
                Text(
                  widget.link.title.isEmpty ? 'Untitled Link' : widget.link.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                    letterSpacing: -0.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // Hero preview image or color banner
                FutureBuilder<String?>(
                  future: _previewImageFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildBannerShimmer(context);
                    }
                    final imageUrl = snapshot.data;
                    if (imageUrl != null && imageUrl.isNotEmpty) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return _buildBannerShimmer(context);
                          },
                          errorBuilder: (_, __, ___) =>
                              _buildColorBanner(context, titleInitial, tagColor),
                        ),
                      );
                    }
                    return _buildColorBanner(context, titleInitial, tagColor);
                  },
                ),
                const SizedBox(height: 14),

                // URL row
                Row(
                  children: [
                    Icon(
                      Icons.link_rounded,
                      size: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.link.url,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Tag chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: tagColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: tagColor.withOpacity(0.3), width: 0.8),
                  ),
                  child: Text(
                    widget.link.tag,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: tagColor,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Open + Share buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: widget.onOpen == null
                            ? null
                            : () {
                                Navigator.pop(context);
                                widget.onOpen?.call();
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.open_in_new_rounded, size: 18),
                        label: const Text(
                          'Open Link',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildSheetActionButton(
                      context: context,
                      icon: Icons.ios_share_rounded,
                      tooltip: 'Share',
                      color: Colors.white,
                      bgColor: const Color(0xFF0EA5E9),
                      onTap: widget.onShare == null
                          ? () {}
                          : () {
                              Navigator.pop(context);
                              widget.onShare?.call();
                            },
                      size: 52,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tagColor = TagColorUtils.colorForTag(widget.link.tag);
    final trimmedTitle = widget.link.title.trim();
    final titleInitial = trimmedTitle.isNotEmpty
        ? trimmedTitle.substring(0, 1).toUpperCase()
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? tagColor.withOpacity(0.3)
                  : colorScheme.outlineVariant.withOpacity(0.2),
              width: 0.5,
            ),
            color: _isHovered ? tagColor.withOpacity(0.03) : colorScheme.surface,
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: tagColor.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: InkWell(
            onTap: () => _showLinkDetailsSheet(context, tagColor, titleInitial),
            borderRadius: BorderRadius.circular(12),
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: _avatarSize,
                    height: _avatarSize,
                    decoration: BoxDecoration(
                      color: tagColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: tagColor.withOpacity(0.2),
                        width: 1.2,
                      ),
                    ),
                    child: FutureBuilder<String?>(
                      future: _previewImageFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return _buildAvatarLoadingShimmer(context);
                        }
                        final imageUrl = snapshot.data;
                        if (imageUrl != null && imageUrl.isNotEmpty) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Image.network(
                              imageUrl,
                              width: _avatarSize,
                              height: _avatarSize,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return _buildAvatarLoadingShimmer(context);
                              },
                              errorBuilder: (_, __, ___) =>
                                  _buildFallbackAvatar(
                                    context,
                                    titleInitial,
                                    tagColor,
                                  ),
                            ),
                          );
                        }
                        return _buildFallbackAvatar(context, titleInitial, tagColor);
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.link.title.isEmpty
                              ? 'Untitled Link'
                              : widget.link.title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.link.url,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.1,
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: tagColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: tagColor.withOpacity(0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            widget.link.tag,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: tagColor,
                                  fontWeight: FontWeight.w500,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSheetActionButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
    String? tooltip,
    Color? color,
    Color? bgColor,
    double size = 38,
  }) {
    final defaultBg = Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.6);
    final defaultFg = Theme.of(context).colorScheme.onSurfaceVariant;
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bgColor ?? defaultBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: color ?? defaultFg),
        ),
      ),
    );
  }

  Widget _buildColorBanner(
    BuildContext context,
    String? titleInitial,
    Color tagColor,
  ) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tagColor.withOpacity(0.22), tagColor.withOpacity(0.07)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tagColor.withOpacity(0.18), width: 1),
      ),
      child: Center(
        child: titleInitial != null
            ? Text(
                titleInitial,
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.w800,
                  color: tagColor.withOpacity(0.4),
                  height: 1,
                ),
              )
            : Icon(Icons.label_rounded, size: 64, color: tagColor.withOpacity(0.4)),
      ),
    );
  }

  Widget _buildBannerShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF303030) : const Color(0xFFE0E0E0);
    final highlightColor = isDark ? const Color(0xFF4A4A4A) : const Color(0xFFF2F2F2);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Shimmer.fromColors(
        period: const Duration(milliseconds: 1100),
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(width: double.infinity, height: 160, color: baseColor),
      ),
    );
  }

  Widget _buildFallbackAvatar(
    BuildContext context,
    String? titleInitial,
    Color tagColor,
  ) {
    return Center(
      child: titleInitial != null
          ? Text(
              titleInitial,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: tagColor,
                fontWeight: FontWeight.w700,
              ),
            )
          : Icon(
              Icons.label_rounded,
              color: tagColor,
              size: 24,
            ),
    );
  }

  Widget _buildAvatarLoadingShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF303030) : const Color(0xFFE0E0E0);
    final highlightColor = isDark
        ? const Color(0xFF4A4A4A)
        : const Color(0xFFF2F2F2);
    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: Shimmer.fromColors(
        period: const Duration(milliseconds: 1100),
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          width: _avatarSize,
          height: _avatarSize,
          color: baseColor,
        ),
      ),
    );
  }
}
