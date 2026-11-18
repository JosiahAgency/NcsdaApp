import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/surfaces.dart';
import '../../../core/theme/typography.dart';
import '../../../l10n/app_localizations.dart';
import '../program_provider.dart';

Future<void> showEventSheet(BuildContext context, ProgramEvent event) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: AppPaper.sheet,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (ctx) => _EventSheet(event: event),
  );
}

class _EventSheet extends StatelessWidget {
  const _EventSheet({required this.event});

  final ProgramEvent event;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final hm = DateFormat.Hm(locale);

    Widget row(IconData icon, String text) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: AppColors.navy),
          const SizedBox(width: 14),
          Expanded(child: Text(text, style: tt.bodyLarge)),
        ],
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppPaper.edge,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.mist.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              event.ministry,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(event.title, style: heading(28, color: AppPaper.ink, height: 1.15)),
          const SizedBox(height: 20),
          row(
            Icons.calendar_today_outlined,
            DateFormat('EEEE, d MMMM yyyy', locale).format(event.start),
          ),
          row(Icons.schedule, '${hm.format(event.start)} – ${hm.format(event.end)}'),
          row(Icons.place_outlined, event.place),
          if (event.description != null) ...[
            const SizedBox(height: 4),
            Text(event.description!, style: tt.bodyLarge),
          ],
          const SizedBox(height: 24),
          FilledButton(onPressed: () => Navigator.pop(context), child: Text(t.done)),
        ],
      ),
    );
  }
}
