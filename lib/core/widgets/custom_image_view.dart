import 'dart:io';
import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
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

    String trimmedUrl = imageUrl!.trim();

    // 1. Handle Network Images (starting with http)
    if (trimmedUrl.startsWith('http')) {
      return _buildNetworkImage(trimmedUrl);
    }

    // 2. Handle Relative Server Paths (e.g., /storage/... or storage/...)
    if (trimmedUrl.startsWith('/storage') || trimmedUrl.startsWith('storage/')) {
      final String fullUrl = trimmedUrl.startsWith('/')
          ? '${ApiStringConstants.baseStorageUrl.replaceAll('/storage/', '')}$trimmedUrl'
          : '${ApiStringConstants.baseStorageUrl}$trimmedUrl';
      return _buildNetworkImage(fullUrl);
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

    // 4. Handle Local Files
    if (trimmedUrl.startsWith('file://') || trimmedUrl.startsWith('/') || _isWindowsPath(trimmedUrl)) {
      try {
        final path = trimmedUrl.startsWith('file://') 
            ? Uri.parse(trimmedUrl).toFilePath() 
            : trimmedUrl;
            
        final file = File(path);
        if (file.existsSync()) {
          return Image.file(
            file,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
          );
        }
      } catch (e) {
        debugPrint("Error loading local file: $e");
      }
    }

    // 5. Final Fallback: try as network image if it looks like a path, otherwise placeholder
    if (trimmedUrl.contains('/') || trimmedUrl.contains('.')) {
      return _buildNetworkImage(trimmedUrl);
    }

    return _buildPlaceholder();
  }

  Widget _buildNetworkImage(String url) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? _buildLoadingPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint("Image.network error for URL: $url - Error: $error");
        return _buildErrorWidget();
      },
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
