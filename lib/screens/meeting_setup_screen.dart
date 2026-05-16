import 'package:flutter/material.dart';

import '../models/person.dart';
import '../services/app_store.dart';
import '../theme.dart';
import '../widgets/pulse_widgets.dart';
import 'active_meeting_screen.dart';

class MeetingSetupScreen extends StatefulWidget {
  const MeetingSetupScreen({super.key, required this.store});

  final AppStore store;

  @override
  State<MeetingSetupScreen> createState() => _MeetingSetupScreenState();
}

class _MeetingSetupScreenState extends State<MeetingSetupScreen> {
  final Set<String> _selectedIds = {};
  final List<Person> _guests = [];

  List<Person> get _availablePeople => [...widget.store.people, ..._guests];
  List<Person> get _selectedPeople => _availablePeople
      .where((person) => _selectedIds.contains(person.id))
      .toList();

  Future<void> _addGuest() async {
    final name = await showNameDialog(context, title: 'Add guest');
    if (name == null) {
      return;
    }
    final guest = Person(
      id: 'guest-${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      isGuest: true,
    );
    setState(() {
      _guests.add(guest);
      _selectedIds.add(guest.id);
    });
  }

  void _startCounting() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ActiveMeetingScreen(
          store: widget.store,
          participants: _selectedPeople,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allSelected = _availablePeople.isNotEmpty &&
        _availablePeople.every((person) => _selectedIds.contains(person.id));
    return PulsePage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Select participants',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: PulseColors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose who is speaking in this session.',
            style: TextStyle(color: PulseColors.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              TextButton.icon(
                onPressed: _availablePeople.isEmpty
                    ? null
                    : () => setState(() {
                          if (allSelected) {
                            _selectedIds.clear();
                          } else {
                            _selectedIds
                              ..clear()
                              ..addAll(
                                  _availablePeople.map((person) => person.id));
                          }
                        }),
                icon: Icon(
                  allSelected ? Icons.check_box : Icons.check_box_outline_blank,
                ),
                label: const Text('Select all'),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: _addGuest,
                icon: const Icon(Icons.person_add),
                label: const Text('Add guest'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _availablePeople.isEmpty
                ? const Center(
                    child: Text(
                      'Add people or a guest to prepare the meeting.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PulseColors.onSurfaceVariant),
                    ),
                  )
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (final person in _availablePeople)
                          FilterChip(
                            selected: _selectedIds.contains(person.id),
                            avatar: Icon(
                              person.isGuest
                                  ? Icons.person_outline
                                  : Icons.person,
                            ),
                            label: Text(person.name),
                            onSelected: (selected) => setState(() {
                              if (selected) {
                                _selectedIds.add(person.id);
                              } else {
                                _selectedIds.remove(person.id);
                              }
                            }),
                            selectedColor: PulseColors.secondary,
                            checkmarkColor: PulseColors.background,
                            labelStyle: TextStyle(
                              color: _selectedIds.contains(person.id)
                                  ? PulseColors.background
                                  : PulseColors.onSurface,
                              fontSize: 16,
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            key: const Key('startCountingButton'),
            onPressed: _selectedPeople.isEmpty ? null : _startCounting,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Counting'),
          ),
        ],
      ),
    );
  }
}
