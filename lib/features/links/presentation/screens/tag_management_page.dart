import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:links/core/service_locator.dart';
import 'package:links/features/links/presentation/bloc/add_tag/add_tag_bloc.dart';
import 'package:links/features/links/presentation/bloc/add_tag/add_tag_event.dart';
import 'package:links/features/links/presentation/bloc/add_tag/add_tag_state.dart';
import 'package:links/features/links/presentation/bloc/delete_tag/delete_tag_bloc.dart';
import 'package:links/features/links/presentation/bloc/delete_tag/delete_tag_event.dart';
import 'package:links/features/links/presentation/bloc/delete_tag/delete_tag_state.dart';
import 'package:links/features/links/presentation/bloc/edit_tag/edit_tag_bloc.dart';
import 'package:links/features/links/presentation/bloc/edit_tag/edit_tag_event.dart';
import 'package:links/features/links/presentation/bloc/edit_tag/edit_tag_state.dart';
import 'package:links/features/links/presentation/bloc/tags/tags_bloc.dart';
import 'package:links/features/links/presentation/bloc/tags/tags_state.dart';
import 'package:links/features/links/widgets/delete_confirmation_dialog.dart';
import 'package:links/features/links/presentation/screens/tag_links_page.dart';
import 'package:links/features/links/presentation/utils/tag_color_utils.dart';

class TagManagementScreen extends StatefulWidget {
  const TagManagementScreen({super.key});

  @override
  State<TagManagementScreen> createState() => _TagManagementScreenState();
}

class _TagManagementScreenState extends State<TagManagementScreen> {
  final TextEditingController _tagNameController = TextEditingController();

  @override
  void dispose() {
    _tagNameController.dispose();
    super.dispose();
  }

  void _showSnack(String message, {Color? backgroundColor}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddTagDialog() {
    _tagNameController.clear();
    final addTagBloc = getIt<AddTagBloc>();

    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<AddTagBloc>.value(
          value: addTagBloc,
          child: AlertDialog(
            title: const Text('Add New Tag'),
            content: TextField(
              controller: _tagNameController,
              inputFormatters: [UpperCaseTextFormatter()],
              decoration: const InputDecoration(
                labelText: 'Tag Name',
                hintText: 'Enter tag name',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              BlocListener<AddTagBloc, AddTagState>(
                listener: (context, state) {
                  if (state is AddTagSuccess) {
                    Navigator.pop(context);
                    _showSnack(state.message, backgroundColor: Colors.green);
                  } else if (state is AddTagError) {
                    _showSnack(state.message, backgroundColor: Colors.red);
                  }
                },
                child: BlocBuilder<AddTagBloc, AddTagState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is AddTagLoading
                          ? null
                          : () {
                              if (_tagNameController.text.isEmpty) {
                                _showSnack(
                                  'Please enter a tag name',
                                  backgroundColor: Colors.orange,
                                );
                                return;
                              }
                              context.read<AddTagBloc>().add(
                                AddTagRequested(
                                  tagName: _tagNameController.text,
                                ),
                              );
                            },
                      child: state is AddTagLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Add Tag'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditTagDialog(String tagId, String tagName) {
    _tagNameController.clear();
    _tagNameController.text = tagName;
    final editTagBloc = getIt<EditTagBloc>();

    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<EditTagBloc>.value(
          value: editTagBloc,
          child: AlertDialog(
            title: const Text('Edit Tag'),
            content: TextField(
              controller: _tagNameController,
              inputFormatters: [UpperCaseTextFormatter()],
              decoration: const InputDecoration(
                labelText: 'New Tag Name',
                hintText: 'Enter new tag name',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              BlocListener<EditTagBloc, EditTagState>(
                listener: (context, state) {
                  if (state is EditTagSuccess) {
                    Navigator.pop(context);
                    _showSnack(state.message, backgroundColor: Colors.green);
                  } else if (state is EditTagError) {
                    _showSnack(state.message, backgroundColor: Colors.red);
                  }
                },
                child: BlocBuilder<EditTagBloc, EditTagState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is EditTagLoading
                          ? null
                          : () {
                              if (_tagNameController.text.isEmpty ||
                                  _tagNameController.text == tagName) {
                                _showSnack(
                                  'Please enter a different tag name',
                                  backgroundColor: Colors.orange,
                                );
                                return;
                              }
                              context.read<EditTagBloc>().add(
                                EditTagRequested(
                                  tagId: tagId,
                                  newTagName: _tagNameController.text,
                                ),
                              );
                            },
                      child: state is EditTagLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Update Tag'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteTagDialog(String tagId, String tagName) {
    final deleteTagBloc = getIt<DeleteTagBloc>();

    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<DeleteTagBloc>.value(
          value: deleteTagBloc,
          child: BlocListener<DeleteTagBloc, DeleteTagState>(
            listener: (context, state) {
              if (state is DeleteTagSuccess) {
                Navigator.pop(context);
                _showSnack(state.message, backgroundColor: Colors.green);
              } else if (state is DeleteTagError) {
                _showSnack(state.message, backgroundColor: Colors.red);
              }
            },
            child: BlocBuilder<DeleteTagBloc, DeleteTagState>(
              builder: (context, state) {
                return DeleteConfirmationDialog(
                  title: 'Delete Tag',
                  message:
                      'Are you sure you want to delete the tag "$tagName"?',
                  isLoading: state is DeleteTagLoading,
                  onConfirm: () {
                    context.read<DeleteTagBloc>().add(
                      DeleteTagRequested(tagId: tagId),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Manage Tags'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTagDialog,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TagsBloc, TagsState>(
        builder: (context, state) {
          if (state is TagsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TagsEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.label_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tags yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create a tag to organize your links',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }

          if (state is TagsError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is TagsSuccess) {
            final tags = [...state.tags];
            tags.sort((a, b) {
              final aIsDefault = a.tagName.toUpperCase() == 'DEFAULT';
              final bIsDefault = b.tagName.toUpperCase() == 'DEFAULT';
              if (aIsDefault && !bIsDefault) return -1;
              if (!aIsDefault && bIsDefault) return 1;
              return a.tagName.compareTo(b.tagName);
            });

            if (tags.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.label_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No tags yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a tag to organize your links',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: tags.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final tag = tags[index];
                final tagColor = TagColorUtils.colorForTag(tag.tagName);
                final isDefaultTag = tag.tagName.toUpperCase() == 'DEFAULT';
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TagLinksPage(tagName: tag.tagName),
                        ),
                      );
                    },
                    leading: Icon(
                      Icons.label_rounded,
                      color: tagColor,
                    ),
                    title: Text(
                      tag.tagName,
                      style: TextStyle(
                        color: tagColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      isDefaultTag
                          ? 'System tag • cannot edit or delete'
                          : 'Tap to view links',
                    ),
                    trailing: isDefaultTag
                        ? Icon(
                            Icons.lock_rounded,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          )
                        : PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showEditTagDialog(tag.id, tag.tagName);
                              } else if (value == 'delete') {
                                _showDeleteTagDialog(tag.id, tag.tagName);
                              }
                            },
                            itemBuilder: (BuildContext context) => [
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
                          ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
