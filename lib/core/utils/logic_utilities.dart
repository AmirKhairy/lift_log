class LogicUtilities {
  LogicUtilities._();

  static final LogicUtilities instance = LogicUtilities._();

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }
}
