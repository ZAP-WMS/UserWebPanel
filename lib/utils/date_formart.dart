import 'package:intl/intl.dart';

DateTime date = DateTime.now();
String ddmmyyyy = DateFormat('dd/MM/yyyy').format(date);
String ttmmss = DateFormat('HH:mm:ss').format(date);
