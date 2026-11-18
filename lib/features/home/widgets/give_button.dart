import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/surfaces.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/raised_tap.dart';

/// A raised gold button: light-to-dark gradient, bright top edge, warm shadow.
class GiveButton extends StatelessWidget {
  const GiveButton({super.key, required this.onTap, required this.title, required this.subtitle});

  final VoidCallback onTap;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return RaisedTap(
      onTap: onTap,
      radius: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE9D3A0), AppColors.gold, Color(0xFFC6A45E)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.2),
        boxShadow: depth(2, tint: const Color(0xFF7A5A1C)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.navy,
                shape: BoxShape.circle,
                boxShadow: depth(1),
              ),
              child: const Icon(Icons.volunteer_activism, color: AppColors.gold, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: heading(26, color: AppColors.navy, height: 1.1)),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: tt.bodyMedium?.copyWith(color: AppColors.navy.withValues(alpha: 0.8)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, color: AppColors.navy, size: 28),
          ],
        ),
      ),
    );
  }
}
