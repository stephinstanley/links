import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:links/features/links/presentation/bloc/add_link/add_link_bloc.dart';
import 'package:links/features/links/presentation/bloc/add_link/add_link_event.dart';
import 'package:links/features/links/presentation/bloc/add_link/add_link_state.dart';
import 'package:links/features/links/presentation/bloc/delete_link/delete_link_bloc.dart';
import 'package:links/features/links/presentation/bloc/delete_link/delete_link_event.dart';
import 'package:links/features/links/presentation/bloc/delete_link/delete_link_state.dart';
import 'package:links/features/links/presentation/bloc/edit_link/edit_link_bloc.dart';
import 'package:links/features/links/presentation/bloc/edit_link/edit_link_event.dart';
import 'package:links/features/links/presentation/bloc/edit_link/edit_link_state.dart';
import 'package:links/features/links/widgets/empty_state.dart';
import 'package:links/features/links/widgets/link_card.dart';
// search and edit features removed for read-only mode
// share/copy removed in read-only mode
import 'package:url_launcher/url_launcher.dart';
import 'package:links/shared/screens/settings_screen.dart';
import 'tag_management_page.dart';
import '../bloc/links/links_bloc.dart';
import '../bloc/links/links_event.dart';
import '../bloc/links/links_state.dart';
import '../bloc/tags/tags_bloc.dart';
import '../bloc/tags/tags_event.dart';
import '../bloc/tags/tags_state.dart';

class LinkManagerPage extends StatefulWidget {
  const LinkManagerPage({super.key});

  @override
  State<LinkManagerPage> createState() => _LinkManagerPageState();
}

class _LinkManagerPageState extends State<LinkManagerPage> {
  // search removed for read-only mode

  // Tag management
  String selectedTag = 'all';
  //controllers
  TextEditingController _titleController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  TextEditingController _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch tags and links when screen initializes
    debugPrint(
      'LinkManagerPage: initState - Current user: ${FirebaseAuth.instance.currentUser?.uid}',
    );
    debugPrint('LinkManagerPage: Adding TagsFetched event');
    context.read<TagsBloc>().add(const TagsFetched());
    debugPrint('LinkManagerPage: Adding LinksFetched event');
    context.read<LinksBloc>().add(const LinksFetched());
  }

  @override
  void dispose() {
    // no controllers to dispose in read-only mode
    _titleController.dispose();
    _urlController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _showAddLinkDialog() {
    // Clear controllers
    _titleController.clear();
    _urlController.clear();
    _tagController.clear();

    // Get available tags from TagsBloc
    final tagsState = context.read<TagsBloc>().state;
    List<String> availableTags = [];
    if (tagsState is TagsSuccess) {
      availableTags = tagsState.tags.map((tag) => tag.tagName).toList();
    }

    // Set default tag to DEFAULT
    _tagController.text = 'DEFAULT';

    showDialog(
      context: context,
      builder: (context) {
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
                  value: _tagController.text.isEmpty
                      ? 'DEFAULT'
                      : _tagController.text,
                  hint: const Text('Select or enter tag'),
                  items: availableTags
                      .map(
                        (tag) => DropdownMenuItem(value: tag, child: Text(tag)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _tagController.text = value;
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
                            child: CircularProgressIndicator(strokeWidth: 2),
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
  }

  // Helper: show SnackBar
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

  // URL validation removed (no add/edit in read-only mode)

  // Add / edit UI removed (read-only mode)

  void _openLink(String url) async {
    try {
      var urlToLaunch = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        urlToLaunch = 'https://$url';
      }
      final uri = Uri.parse(urlToLaunch);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          _showSnack(
            'Could not launch $urlToLaunch',
            backgroundColor: Colors.red,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnack('Error: ${e.toString()}', backgroundColor: Colors.red);
      }
    }
  }

  // Sharing removed in read-only mode

  // Tag creation removed in read-only mode

  // Deletion removed in read-only mode

  void _showEditLinkDialog(dynamic link) {
    // Set controllers with current link data
    _titleController.text = link.title;
    _urlController.text = link.url;
    _tagController.text = link.tag;

    // Get available tags from TagsBloc
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
                      value: availableTags.contains(_tagController.text)
                          ? _tagController.text
                          : (availableTags.isNotEmpty
                                ? availableTags.first
                                : null),
                      hint: const Text('Select or enter tag'),
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
                                context.read<EditLinkBloc>().add(
                                  EditLinkRequested(
                                    linkId: link.id,
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

  void _deleteLink(dynamic link) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Link'),
          content: Text('Are you sure you want to delete "${link.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            BlocListener<DeleteLinkBloc, DeleteLinkState>(
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
                  return ElevatedButton(
                    onPressed: state is DeleteLinkLoading
                        ? null
                        : () {
                            context.read<DeleteLinkBloc>().add(
                              DeleteLinkRequested(linkId: link.id),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: state is DeleteLinkLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Delete'),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Links'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.label_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TagManagementScreen()),
              );
            },
            tooltip: 'Manage Tags',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),

      //creating a floating button to use the _showAddLinkDialog
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLinkDialog,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          // Search removed in read-only mode
          // Tag filter buttons
          BlocBuilder<TagsBloc, TagsState>(
            builder: (context, state) {
              List<String> tags = [];
              if (state is TagsSuccess) {
                tags = state.tags.map((tag) => tag.tagName).toList();
              }
              return SizedBox(
                height: 56,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('All'),
                        selected: selectedTag == 'all',
                        onSelected: (selected) {
                          setState(() {
                            selectedTag = 'all';
                          });
                        },
                        selectedColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceVariant,
                        labelStyle: TextStyle(
                          color: selectedTag == 'all'
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: selectedTag == 'all'
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        elevation: selectedTag == 'all' ? 2 : 0,
                        shadowColor: Theme.of(context).colorScheme.shadow,
                      ),
                    ),
                    ...tags.map(
                      (tag) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(tag),
                          selected: selectedTag == tag,
                          onSelected: (selected) {
                            setState(() {
                              selectedTag = tag;
                            });
                          },
                          selectedColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceVariant,
                          labelStyle: TextStyle(
                            color: selectedTag == tag
                                ? Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: selectedTag == tag
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          elevation: selectedTag == tag ? 2 : 0,
                          shadowColor: Theme.of(context).colorScheme.shadow,
                        ),
                      ),
                    ),
                    // Add new tag removed in read-only mode
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<LinksBloc, LinksState>(
              builder: (context, state) {
                if (state is LinksLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is LinksEmpty || state is! LinksSuccess) {
                  return EmptyState(searchText: '');
                }

                var userLinks = state.links;
                // Only filter by selected tag in read-only mode
                if (selectedTag != 'all') {
                  userLinks = userLinks
                      .where((link) => link.tag == selectedTag)
                      .toList();
                }

                // Show empty state if no links for selected tag
                if (userLinks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.link_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No links for this tag',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a new link or select a different tag',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.builder(
                    itemCount: userLinks.length,
                    itemBuilder: (context, index) {
                      final link = userLinks[index];
                      return LinkCard(
                        link: link,
                        onOpen: () => _openLink(link.url),
                        onEdit: () => _showEditLinkDialog(link),
                        onDelete: () => _deleteLink(link),
                      );
                    },
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // floatingActionButton disabled for now - read-only mode
    );
  }
}
