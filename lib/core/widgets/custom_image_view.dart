import 'dart:io';
import 'package:flutter/material.dart';
import '../constants/assets_image.dart';

class CustomImageView extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CustomImageView({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return _buildPlaceholder();
    }

    final trimmedUrl = imageUrl!.trim();

    // 1. Handle Network Images
    if (trimmedUrl.startsWith('http')) {
      return Image.network(
        trimmedUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? _buildLoadingPlaceholder();
        },
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    }

    // 2. Handle File URIs or Absolute Paths
    if (trimmedUrl.startsWith('file://') || trimmedUrl.startsWith('/') || _isWindowsPath(trimmedUrl)) {
      try {
        final path = trimmedUrl.startsWith('file://') 
            ? Uri.parse(trimmedUrl).toFilePath() 
            : trimmedUrl;
            
        return Image.file(
          File(path),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
        );
      } catch (e) {
        return _buildErrorWidget();
      }
    }

    // 3. Handle Assets
    if (trimmedUrl.startsWith('assets/')) {
      return Image.asset(
        trimmedUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    }

    // 4. Fallback to network if scheme is unknown but not local
    return Image.network(
      trimmedUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  bool _isWindowsPath(String path) {
    return path.length > 2 && path[1] == ':' && (path[2] == '\\' || path[2] == '/');
  }

  Widget _buildPlaceholder() {
    return placeholder ?? Image.asset(
      AssetsImage.constantImageForService,
      width: width,
      height: height,
      fit: fit,
    );
  }

  Widget _buildErrorWidget() {
    return errorWidget ?? Image.asset(
      AssetsImage.constantImageForService,
      width: width,
      height: height,
      fit: fit,
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
