import 'package:flutter/material.dart';

import '../utils/breakpoints.dart';

class LayoutDebugBar extends StatelessWidget {
  const LayoutDebugBar({super.key, required this.width, required this.type});
  final double width;
  final ScreenType type;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    return ColoredBox(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            'Vùng bố cục: ${width.round()}dp | Cửa sổ cao: ${size.height.round()}dp'
            ' | ${landscape ? "Ngang" : "Dọc"}'
            ' | ${type == ScreenType.mobile ? "MOBILE" : "TABLET"} | Ngưỡng: 600dp',
            key: const ValueKey('layout-debug'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
