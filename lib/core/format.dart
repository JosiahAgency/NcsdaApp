// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

String formatKes(int amount) => 'KES ${NumberFormat('#,##0').format(amount)}';
