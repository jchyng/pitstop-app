import 'package:intl/intl.dart';

String fmtKm(int km) => NumberFormat('#,##0').format(km);

String fmtKrw(int amount) => NumberFormat('#,##0').format(amount);
