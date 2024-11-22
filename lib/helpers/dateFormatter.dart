String formatDate(String inputDate) {
  // Parse the input date string
  DateTime date = DateTime.parse(inputDate);

  // Define month abbreviations
  List<String> months = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];

  // Extract day, month, and year
  String day = date.day.toString().padLeft(2, '0');
  String month = months[date.month - 1];
  String year = date.year.toString();

  // Return formatted date
  return "$day $month $year";
}
