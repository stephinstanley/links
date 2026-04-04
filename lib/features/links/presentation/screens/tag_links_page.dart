import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:links/features/links/models/link.dart';
import 'package:links/features/links/presentation/bloc/add_link/add_link_bloc.dart';
import 'package:links/features/links/presentation/bloc/add_link/add_link_event.dart';
import 'package:links/features/links/presentation/bloc/add_link/add_link_state.dart';
import 'package:links/features/links/presentation/bloc/delete_link/delete_link_bloc.dart';
import 'package:links/features/links/presentation/bloc/delete_link/delete_link_event.dart';
import 'package:links/features/links/presentation/bloc/delete_link/delete_link_state.dart';
import 'package:links/features/links/presentation/bloc/edit_link/edit_link_bloc.dart';
import 'package:links/features/links/presentation/bloc/edit_link/edit_link_event.dart';
import 'package:links/features/links/presentation/bloc/edit_link/edit_link_state.dart';
import 'package:links/features/links/presentation/bloc/links/links_bloc.dart';
import 'package:links/features/links/presentation/bloc/links/links_state.dart';
import 'package:links/features/links/presentation/bloc/tags/tags_bloc.dart';
import 'package:links/features/links/presentation/bloc/tags/tags_state.dart';
import 'package:links/features/links/widgets/delete_confirmation_dialog.dart';
import 'package:links/features/links/widgets/link_card.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class TagLinksPage extends StatefulWidget {
  final String tagName;

  const TagLinksPage({super.key, required this.tagName});

  @override
  State<TagLinksPage> createState() => _TagLinksPageState();
}

class _TagLinksPageState extends State<TagLinksPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _showSnack(
    String message, {
    Color? backgroundColor,
    Duration? duration,
  }) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.primary,
        duration: duration ?? const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openLink(String url) async {
    var urlToLaunch = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      urlToLaunch = 'https://$url';
    }
    final uri = Uri.parse(urlToLaunch);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      _showSnack('Could not launch $urlToLaunch', backgroundColor: Colors.red);
    }
  }

  Future<void> _shareLink(Link link) async {
    final title = link.title.trim().isEmpty
        ? 'Untitled Link'
        : link.title.trim();
    final message = '$title\n${link.url.trim()}';
    await Share.share(message, subject: title);
  }

  void _showAddLinkDialog() {
    _titleController.clear();
    _urlController.clear();
    _tagController.text = widget.tagName;

    final tagsState = context.read<TagsBloc>().state;
    List<String> availableTags = [];
    if (tagsState is TagsSuccess) {
      availableTags = tagsState.tags.map((tag) => tag.tagName).toList();
    }
    if (!availableTags.contains(widget.tagName)) {
      availableTags = [...availableTags, widget.tagName];
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Link'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter link title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        labelText: 'URL',
                        hintText: 'https://example.com',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: availableTags.contains(_tagController.text)
                          ? _tagController.text
                          : widget.tagName,
                      items: availableTags
                          .toSet()
                          .toList()
                          .map(
                            (tag) =>
                                DropdownMenuItem(value: tag, child: Text(tag)),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            _tagController.text = value;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Tag',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                BlocListener<AddLinkBloc, AddLinkState>(
                  listener: (context, state) {
                    if (state is AddLinkSuccess) {
                      Navigator.pop(context);
                      _showSnack(state.message, backgroundColor: Colors.green);
                    } else if (state is AddLinkError) {
                      _showSnack(state.message, backgroundColor: Colors.red);
                    }
                  },
                  child: BlocBuilder<AddLinkBloc, AddLinkState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                        ),
                        onPressed: state is AddLinkLoading
                            ? null
                            : () {
                                if (_titleController.text.isEmpty ||
                                    _urlController.text.isEmpty ||
                                    _tagController.text.isEmpty) {
                                  _showSnack(
                                    'Please fill all fields',
                                    backgroundColor: Colors.orange,
                                  );
                                  return;
                                }
                                context.read<AddLinkBloc>().add(
                                  AddLinkRequested(
                                    title: _titleController.text,
                                    url: _urlController.text,
                                    tag: _tagController.text,
                                  ),
                                );
                              },
                        child: state is AddLinkLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Add Link'),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditLinkDialog(Link link) {
    _titleController.text = link.title;
    _urlController.text = link.url;
    _tagController.text = link.tag;

    final tagsState = context.read<TagsBloc>().state;
    List<String> availableTags = [];
    if (tagsState is TagsSuccess) {
      availableTags = tagsState.tags.map((tag) => tag.tagName).toList();
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Link'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        labelText: 'URL',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: availableTags.contains(_tagController.text)
                          ? _tagController.text
                          : (availableTags.isNotEmpty
                                ? availableTags.first
                                : null),
                      items: availableTags
                          .toSet()
                          .toList()
                          .map(
                            (tag) =>
                                DropdownMenuItem(value: tag, child: Text(tag)),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            _tagController.text = value;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Tag',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                BlocListener<EditLinkBloc, EditLinkState>(
                  listener: (context, state) {
                    if (state is EditLinkSuccess) {
                      Navigator.pop(context);
                      _showSnack(state.message, backgroundColor: Colors.green);
                    } else if (state is EditLinkError) {
                      _showSnack(state.message, backgroundColor: Colors.red);
                    }
                  },
                  child: BlocBuilder<EditLinkBloc, EditLinkState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                        ),
                        onPressed: state is EditLinkLoading
                            ? null
                            : () {
                                if (_titleController.text.isEmpty ||
                                    _urlController.text.isEmpty ||
                                    _tagController.text.isEmpty) {
                                  _showSnack(
                                    'Please fill all fields',
                                    backgroundColor: Colors.orange,
                                  );
                                  return;
                                }
                                if (link.id == null || link.id!.isEmpty) {
                                  _showSnack(
                                    'Invalid link id. Please refresh and try again.',
                                    backgroundColor: Colors.red,
                                  );
                                  return;
                                }
                                context.read<EditLinkBloc>().add(
                                  EditLinkRequested(
                                    linkId: link.id!,
                                    title: _titleController.text,
                                    url: _urlController.text,
                                    tag: _tagController.text,
                                  ),
                                );
                              },
                        child: state is EditLinkLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Update Link'),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteLink(Link link) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocListener<DeleteLinkBloc, DeleteLinkState>(
          listener: (context, state) {
            if (state is DeleteLinkSuccess) {
              Navigator.pop(context);
              _showSnack(state.message, backgroundColor: Colors.green);
            } else if (state is DeleteLinkError) {
              _showSnack(state.message, backgroundColor: Colors.red);
            }
          },
          child: BlocBuilder<DeleteLinkBloc, DeleteLinkState>(
            builder: (context, state) {
              return DeleteConfirmationDialog(
                title: 'Delete Link',
                message: 'Are you sure you want to delete "${link.title}"?',
                isLoading: state is DeleteLinkLoading,
                onConfirm: () {
                  if (link.id == null || link.id!.isEmpty) {
                    _showSnack(
                      'Invalid link id. Please refresh and try again.',
                      backgroundColor: Colors.red,
                    );
                    return;
                  }
                  context.read<DeleteLinkBloc>().add(
                    DeleteLinkRequested(linkId: link.id!),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.tagName)),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLinkDialog,
        child: const Icon(Icons.add),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth >= 1200 ? 28.0 : 12.0;
          final contentMaxWidth = constraints.maxWidth >= 1200
              ? 1000.0
              : constraints.maxWidth;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth),
              child: BlocBuilder<LinksBloc, LinksState>(
                builder: (context, state) {
                  if (state is LinksLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is! LinksSuccess) {
                    return const Center(
                      child: Text('Unable to load links for this tag'),
                    );
                  }

                  final tagLinks = state.links
                      .where((link) => link.tag == widget.tagName)
                      .toList();

                  if (tagLinks.isEmpty) {
                    return const Center(child: Text('No links in this tag'));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 8,
                    ),
                    itemCount: tagLinks.length,
                    itemBuilder: (context, index) {
                      final link = tagLinks[index];
                      return LinkCard(
                        link: link,
                        onOpen: () => _openLink(link.url),
                        onEdit: () => _showEditLinkDialog(link),
                        onDelete: () => _deleteLink(link),
                        onShare: () => _shareLink(link),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
