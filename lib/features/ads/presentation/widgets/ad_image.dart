import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Smart image widget that auto-detects file path vs network URL.
///
/// - Paths starting with `/` or `file://` → [Image.file]
/// - URLs starting with `http` → [Image.network]
/// - Empty / null → fallback icon
class AdImage extends StatelessWidget {
  const AdImage({
    super.key,
    required this.imageSource,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.fallbackIcon = Icons.image_outlined,
    this.borderRadius,
  });

  final String imageSource;
  final BoxFit fit;
  final double? width;
  final double? height;
  final IconData fallbackIcon;
  final BorderRadius? borderRadius;

  bool get _isFile =>
      imageSource.startsWith('/') || imageSource.startsWith('file://');
  bool get _isNetwork => imageSource.startsWith('http');
  bool get _hasImage => imageSource.isNotEmpty && (_isFile || _isNetwork);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget image;
    if (!_hasImage) {
      // Fallback placeholder
      image = Container(
        width: width,
        height: height,
        color: theme.colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            fallbackIcon,
            size: 48.sp,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
        ),
      );
    } else if (_isFile) {
      image = Image.file(
        File(imageSource),
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => _errorPlaceholder(theme),
      );
    } else {
      image = Image.network(
        imageSource,
        fit: fit,
        width: width,
        height: height,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: theme.colorScheme.surfaceContainerHighest,
            child:
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
        errorBuilder: (_, __, ___) => _errorPlaceholder(theme),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _errorPlaceholder(ThemeData theme) {
    return Container(
      width: width,
      height: height,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 40.sp,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
