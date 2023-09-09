
class Operation{
  static String convertDate(DateTime date) {
    late String newDate;
    if (date.month == 1) {
      newDate = "Jan";
    } else if (date.month == 2) {
      newDate = "Feb";
    } else if (date.month == 3) {
      newDate = "Mar";
    } else if (date.month == 4) {
      newDate = "Apr";
    } else if (date.month == 5) {
      newDate = "May";
    } else if (date.month == 6) {
      newDate = "Jun";
    } else if (date.month == 7) {
      newDate = "Jul";
    } else if (date.month == 8) {
      newDate = "Aug";
    } else if (date.month == 9) {
      newDate = "Sep";
    } else if (date.month == 10) {
      newDate = "Oct";
    } else if (date.month == 11) {
      newDate = "Nov";
    } else if (date.month == 12) {
      newDate = "Dec";
    }

    return "$newDate ${date.day}, ${date.year} - ${date.hour}:${date.minute} ${date.hour > 12 ? "PM" : "AM"}";
  }

}