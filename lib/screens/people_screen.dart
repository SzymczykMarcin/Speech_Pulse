import 'package:flutter/material.dart';

import '../debug_log.dart';
import '../models/person.dart';
import '../services/app_store.dart';
import '../theme.dart';
import '../widgets/pulse_widgets.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key, required this.store});

  final AppStore store;

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  @override
  void initState() {
    super.initState();
    widget.store.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    widget.store.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() => setState(() {});

  Future<void> _addPerson() async {
    appDebugLog('People: Add Person tapped');
    final name = await showNameDialog(context, title: 'Add person');
    if (name != null) {
      await widget.store.addPerson(name);
    }
  }

  Future<void> _editPerson(Person person) async {
    appDebugLog('People: Edit tapped for ${person.id}');
    final name = await showNameDialog(
      context,
      title: 'Edit person',
      initialValue: person.name,
    );
    if (name != null) {
      await widget.store.updatePerson(person, name);
    }
  }

  Future<void> _deletePerson(Person person) async {
    appDebugLog('People: Delete tapped for ${person.id}');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete person?'),
        content: Text('${person.name} will be removed from the saved list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.store.deletePerson(person);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PulsePage(
      actions: [
        IconButton(
          tooltip: 'Add person',
          onPressed: _addPerson,
          icon: const Icon(Icons.person_add),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'People',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: context.pulseOnSurface,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage local participants saved only on this device.',
            style: TextStyle(color: context.pulseOnSurfaceVariant),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addPerson,
            icon: const Icon(Icons.person_add),
            label: const Text('Add Person'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: widget.store.people.isEmpty
                ? Center(
                    child: Text(
                      'No saved people yet.',
                      style: TextStyle(color: context.pulseOnSurfaceVariant),
                    ),
                  )
                : ListView.separated(
                    itemCount: widget.store.people.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final person = widget.store.people[index];
                      return SurfacePanel(
                        child: Row(
                          children: [
                            const CircleAvatar(child: Icon(Icons.person)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                person.name,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Edit ${person.name}',
                              onPressed: () => _editPerson(person),
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              tooltip: 'Delete ${person.name}',
                              onPressed: () => _deletePerson(person),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
