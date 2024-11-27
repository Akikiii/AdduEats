import 'package:flutter/material.dart';

void main() => runApp(const ChipApp());

class ChipApp extends StatelessWidget {
  const ChipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FilterChip Sample'),
        ),
        body: const FilterChipExample(
          choices: ['Apple', 'Banana', 'Orange'],
        ),
      ),
    );
  }
}

class FilterChipExample extends StatefulWidget {
  final List<String> choices;
  final ValueChanged<String?>? onSelected;

  const FilterChipExample({super.key, required this.choices, this.onSelected});

  @override
  State<FilterChipExample> createState() => _FilterChipExampleState();
}

class _FilterChipExampleState extends State<FilterChipExample> {
  String? selectedFilter;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 5.0),
          Wrap(
            spacing: 5.0,
            children: widget.choices.map((String choice) {
              return FilterChip(
                label: Text(choice),
                selected: selectedFilter == choice, // Only the selected one is true
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      selectedFilter = choice; // Set the selected chip
                    } else {
                      selectedFilter = null; // Deselect the chip
                    }
                  });

                  // Call the onSelected callback if provided
                  if (widget.onSelected != null) {
                    widget.onSelected!(selectedFilter); // Notify parent widget
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}