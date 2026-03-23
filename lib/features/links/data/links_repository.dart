import 'links_data_provider.dart';
import '../models/link.dart';
import '../models/tag.dart';

/// Repository Layer - Business Logic wrapper
/// SIMPLIFIED: Only reads tags and links
class LinksRepository {
  final LinksDataProvider dataProvider;

  LinksRepository(this.dataProvider);

  /// Get stream of user's tags
  Stream<List<Tag>> getUserTags() {
    return dataProvider.getUserTagsStream();
  }

  /// Get stream of user's links
  Stream<List<Link>> getUserLinks() {
    return dataProvider.getUserLinksStream();
  }

  /// Add a new link
  Future<void> addLink({
    required String title,
    required String url,
    required String tag,
  }) async {
    return dataProvider.addLink(title: title, url: url, tag: tag);
  }

  /// Update an existing link
  Future<void> updateLink({
    required String linkId,
    required String title,
    required String url,
    required String tag,
  }) async {
    return dataProvider.updateLink(
      linkId: linkId,
      title: title,
      url: url,
      tag: tag,
    );
  }

  /// Delete a link
  Future<void> deleteLink({required String linkId}) async {
    return dataProvider.deleteLink(linkId: linkId);
  }

  /// Add a new tag
  Future<void> addTag({required String tagName}) async {
    return dataProvider.addTag(tagName: tagName);
  }

  /// Edit a tag (rename)
  Future<void> editTag({
    required String tagId,
    required String newTagName,
  }) async {
    return dataProvider.editTag(tagId: tagId, newTagName: newTagName);
  }

  /// Delete a tag
  Future<void> deleteTag({required String tagId}) async {
    return dataProvider.deleteTag(tagId: tagId);
  }
}
