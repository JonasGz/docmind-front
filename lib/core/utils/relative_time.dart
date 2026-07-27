/// Tempo relativo em português, no formato do design: "agora", "há 2 dias",
/// "há 1 semana".
///
/// O backend devolve datas em UTC; a conversão para local acontece aqui, na
/// exibição.
String relativeTime(DateTime timestamp, {DateTime? now}) {
  final reference = now ?? DateTime.now();
  final elapsed = reference.difference(timestamp.toLocal());

  if (elapsed.isNegative || elapsed.inMinutes < 1) return 'agora';

  if (elapsed.inHours < 1) {
    final minutes = elapsed.inMinutes;
    return minutes == 1 ? 'há 1 minuto' : 'há $minutes minutos';
  }

  if (elapsed.inDays < 1) {
    final hours = elapsed.inHours;
    return hours == 1 ? 'há 1 hora' : 'há $hours horas';
  }

  if (elapsed.inDays < 7) {
    final days = elapsed.inDays;
    return days == 1 ? 'ontem' : 'há $days dias';
  }

  if (elapsed.inDays < 30) {
    final weeks = elapsed.inDays ~/ 7;
    return weeks == 1 ? 'há 1 semana' : 'há $weeks semanas';
  }

  if (elapsed.inDays < 365) {
    final months = elapsed.inDays ~/ 30;
    return months == 1 ? 'há 1 mês' : 'há $months meses';
  }

  final years = elapsed.inDays ~/ 365;
  return years == 1 ? 'há 1 ano' : 'há $years anos';
}
