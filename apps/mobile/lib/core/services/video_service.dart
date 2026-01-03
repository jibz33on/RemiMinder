import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Service for handling video operations (medical consultations, etc.)
///
/// Ensures video files are created in app-controlled storage and provides
/// safe cleanup methods to prevent unauthorized persistence of medical video content.
///
/// IMPORTANT: Future video recording implementations should:
/// - Use getVideoStorageDirectory() for file storage (not gallery)
/// - Call deleteVideo() after successful upload
/// - Never auto-save to device gallery for medical content
class VideoService {
  static final VideoService _instance = VideoService._internal();
  factory VideoService() => _instance;
  VideoService._internal();

  /// Delete a video file
  Future<bool> deleteVideo(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      // Silent failure to avoid disrupting user flow
      return false;
    }
  }

  /// Get list of saved video files for cleanup operations
  Future<List<File>> getSavedVideos() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory
          .listSync()
          .where((entity) {
            return entity is File && entity.path.endsWith('.mp4');
          })
          .cast<File>()
          .toList();

      // Sort by modification time (newest first)
      files
          .sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      return files;
    } catch (e) {
      return [];
    }
  }

  /// Get temporary directory for video storage (app-controlled, not gallery)
  Future<Directory> getVideoStorageDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// Generate safe video filename with timestamp
  String generateVideoFilename() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'video_$timestamp.mp4';
  }

  /// Generate full video file path in app-controlled storage
  Future<String> generateVideoFilePath() async {
    final directory = await getVideoStorageDirectory();
    final filename = generateVideoFilename();
    return '${directory.path}/$filename';
  }

  /// Check if a file path is in app-controlled video storage
  bool isVideoFileInSafeStorage(String filePath) {
    // Ensure video files are stored in app documents directory, not gallery
    return filePath.contains('Documents') ||
        filePath.contains('Library/Application Support');
  }
}
