import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String searchText;

  const EmptyState({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with animated background
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Icon(
                  searchText.isEmpty
                      ? Icons.inbox_rounded
                      : Icons.search_off_rounded,
                  size: 50,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              searchText.isEmpty ? 'No Links Yet' : 'No Results Found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              searchText.isEmpty
                  ? 'Start organizing your links!\nTap the + button to add your first link.'
                  : 'Try searching with different keywords\nor adjust your filters.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
