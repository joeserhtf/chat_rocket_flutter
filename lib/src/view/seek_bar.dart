import 'dart:math';
import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget {
  final Duration? duration;
  final Duration? position;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;
  final Color? stateColor;

  SeekBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
    this.stateColor = Colors.blue,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Slider(
          min: 0.0,
          activeColor: widget.stateColor,
          inactiveColor: widget.stateColor,
          max: widget.duration?.inMilliseconds.toDouble() ?? 0,
          value: min(_dragValue ?? widget.position?.inMilliseconds.toDouble() ?? 0, widget.duration?.inMilliseconds.toDouble() ?? 0),
          onChanged: (value) {
            setState(() {
              _dragValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(Duration(milliseconds: value.round()));
            }
          },
          onChangeEnd: (value) {
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd!(Duration(milliseconds: value.round()));
            }
            _dragValue = null;
          },
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch("$_remaining")?.group(1) ?? '$_remaining',
              style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}
