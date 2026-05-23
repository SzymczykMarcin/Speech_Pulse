import 'package:flutter/material.dart';

import '../theme.dart';

class PulsePage extends StatelessWidget {
  const PulsePage({
    super.key,
    this.title = 'Speech Pulse',
    this.actions,
    required this.child,
  });

  final String title;
  final List<Widget>? actions;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class SurfacePanel extends StatelessWidget {
  const SurfacePanel({super.key, required this.child, this.padding = 16});

  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.pulseSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.pulsePanelBorder),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: context.pulseSectionLabel);
  }
}

Future<String?> showNameDialog(
  BuildContext context, {
  required String title,
  String initialValue = '',
}) {
  final controller = TextEditingController(text: initialValue);
  final formKey = GlobalKey<FormState>();
  void submit(BuildContext context) {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      Navigator.pop(context, controller.text.trim());
    }
  }

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          autocorrect: false,
          enableSuggestions: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          onFieldSubmitted: (_) => submit(context),
          decoration: const InputDecoration(labelText: 'Name'),
          validator: (value) =>
              value == null || value.trim().isEmpty ? 'Name is required' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => submit(context),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
