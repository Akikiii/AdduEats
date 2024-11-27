import 'package:flutter/material.dart';

class PriceRangeSlider extends StatefulWidget {
    //todo: Parameters
  final RangeValues initialRangeValues;
  final ValueChanged<RangeValues> onRangeChanged;

  const PriceRangeSlider({
    //todo: Constructors
    super.key,
    required this.initialRangeValues,
    required this.onRangeChanged,
  });

  @override
  State<PriceRangeSlider> createState() => _RangeSliderState();
}

class _RangeSliderState extends State<PriceRangeSlider> {
    //todo: State Maagement for Current Value (of the slider)
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = widget.initialRangeValues;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.green,
            thumbColor: const Color.fromARGB(255, 102, 102, 102),
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
            overlayColor: Colors.blue.withOpacity(0.2),
          ),
          child: RangeSlider(
            values: _currentRangeValues,
            max: 300,
            divisions: 300,
            labels: RangeLabels(
              _currentRangeValues.start.round().toString(),
              _currentRangeValues.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
              widget.onRangeChanged(_currentRangeValues); 
            },
          ),
        ),
      ],
    );
  }
}
