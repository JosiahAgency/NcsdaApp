import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/surfaces.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/raised_tap.dart';
import '../../../l10n/app_localizations.dart';

/// Returned by [showMinistrySheet] when "All ministries" is picked
/// (null means the sheet was dismissed).
const kAllMinistries = '';

class MinistryPill extends StatelessWidget {
  const MinistryPill({super.key, required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RaisedTap(
      onTap: onTap,
      radius: 24,
      decoration: BoxDecoration(
        color: active ? AppColors.mist : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.line),
        boxShadow: depth(1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.tune_rounded, size: 20, color: AppColors.navy),
            const SizedBox(width: 8),
            Flexible(child: Text(label, style: Theme.of(context).textTheme.titleMedium)),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more_rounded, color: AppColors.navy),
          ],
        ),
      ),
    );
  }
}

Future<String?> showMinistrySheet(
  BuildContext context, {
  required List<String> ministries,
  required String? selected,
}) {
  return showModalBottomSheet<String>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: AppPaper.sheet,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (ctx) {
      final t = AppLocalizations.of(ctx)!;
      final tt = Theme.of(ctx).textTheme;

      Widget option(String label, String value, bool isSelected) => ListTile(
        minTileHeight: 56,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        title: Text(label, style: tt.titleMedium),
        trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.navy) : null,
        onTap: () => Navigator.pop(ctx, value),
      );

      return ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 20, bottom: 16),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(t.progChooseMinistry, style: heading(22, color: AppPaper.ink)),
          ),
          option(t.progAllMinistries, kAllMinistries, selected == null),
          for (final m in ministries) option(m, m, selected == m),
        ],
      );
    },
  );
}
