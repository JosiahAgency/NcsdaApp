import 'package:material_ui/material_ui.dart';

/// A decorated surface (shadow, gradient, border) that still shows the ink ripple.
/// Ink + InkWell paint on a transparent Material so the ripple is not hidden
/// underneath the decoration.
class RaisedTap extends StatelessWidget {
  const RaisedTap({
    super.key,
    required this.onTap,
    required this.decoration,
    required this.child,
    this.radius = 20,
  });

  final VoidCallback onTap;
  final BoxDecoration decoration;
  final Widget child;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: decoration,
        child: InkWell(borderRadius: BorderRadius.circular(radius), onTap: onTap, child: child),
      ),
    );
  }
}
