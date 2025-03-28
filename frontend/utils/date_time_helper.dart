import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatTimestamp(String timestamp) {
    try {
      DateTime parsedDate =
          DateTime.parse(timestamp); // Convert string to DateTime
      return DateFormat('MMMM dd, yyyy h:mm a').format(parsedDate); // Format it
    } catch (e) {
      return 'Invalid date'; // Handle errors gracefully
    }
  }
}
