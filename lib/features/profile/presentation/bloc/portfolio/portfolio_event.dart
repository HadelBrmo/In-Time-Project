import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

abstract class PortfolioEvent {}

class FetchPortfolio extends PortfolioEvent {
  final int userId;
  FetchPortfolio(this.userId);
}

class UploadPortfolioImage extends PortfolioEvent {
  final int userId;
  final XFile image;
  final String title;
  UploadPortfolioImage({
    required this.userId,
    required this.image,
    required this.title,
  });
}

class UploadPortfolioFile extends PortfolioEvent {
  final int userId;
  final PlatformFile file;
  final String title;
  UploadPortfolioFile({
    required this.userId,
    required this.file,
    required this.title,
  });
}

class UploadPortfolioLink extends PortfolioEvent {
  final int userId;
  final String url;
  final String title;
  UploadPortfolioLink({
    required this.userId,
    required this.url,
    required this.title,
  });
}
