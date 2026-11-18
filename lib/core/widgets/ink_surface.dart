import 'package:material_ui/material_ui.dart';

/// The corner radius of [d], resolved for the current text direction.
/// [override] wins when given.
BorderRadius resolveRadius(BuildContext context, BoxDecoration d, {double? override}) {
  if (override != null) return BorderRadius.circular(override);
  return (d.borderRadius ?? BorderRadius.zero).resolve(Directionality.of(context));
}

/// A decorated card whose InkWell children (rows, tiles) still show ripples.
///
/// Why the layers: Ink paints its decoration on the Material's ink layer, and
/// that layer is clipped to a RECTANGLE. A shadow painted there gets cut off
/// square, which shows up as dark wedges in the four corners of a rounded card.
/// So the shadow is painted OUTSIDE (a plain rounded DecoratedBox), and only the
/// fill, gradient and border go through Ink, inside a rounded clip.
class InkSurface extends StatelessWidget {
  const InkSurface({super.key, required this.decoration, required this.child, this.padding});

  final BoxDecoration decoration;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final radius = resolveRadius(context, decoration);

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: radius, boxShadow: decoration.boxShadow),
        child: ClipRRect(
          borderRadius: radius,
          child: Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: decoration.copyWith(boxShadow: const <BoxShadow>[]),
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
