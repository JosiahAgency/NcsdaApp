import 'package:material_ui/material_ui.dart';

import 'ink_surface.dart';

/// A tappable decorated surface (shadow, gradient, border) with an ink ripple.
///
/// The shadow is painted outside the Ink layer, on a rounded DecoratedBox, so it
/// follows the corners instead of being clipped square. See [InkSurface].
/// [radius] is optional: by default it is read from the decoration.
class RaisedTap extends StatelessWidget {
  const RaisedTap({
    super.key,
    required this.onTap,
    required this.decoration,
    required this.child,
    this.radius,
  });

  final VoidCallback onTap;
  final BoxDecoration decoration;
  final Widget child;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final r = resolveRadius(context, decoration, override: radius);

    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: r, boxShadow: decoration.boxShadow),
      child: ClipRRect(
        borderRadius: r,
        child: Material(
          type: MaterialType.transparency,
          child: Ink(
            decoration: decoration.copyWith(boxShadow: const <BoxShadow>[]),
            child: InkWell(borderRadius: r, onTap: onTap, child: child),
          ),
        ),
      ),
    );
  }
}
