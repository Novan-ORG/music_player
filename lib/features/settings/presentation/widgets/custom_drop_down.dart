import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
  });

  final String value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      underline: const SizedBox(),
      borderRadius: BorderRadius.circular(12),
      style: Theme.of(context).textTheme.bodyMedium,
      icon: const Icon(Icons.arrow_drop_down_rounded),
    );
  }
}
