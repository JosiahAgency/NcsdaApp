import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../theme/surfaces.dart';

class SoftCard extends StatelessWidget {
  const SoftCard({super.key, required this.child, this.padding = const EdgeInsets.all(16)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.line),
      boxShadow: depth(1),
    ),
    child: child,
  );
}
