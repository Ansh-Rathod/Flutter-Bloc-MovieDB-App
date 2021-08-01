import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Collection {
  final String name;
  final String image;
  final String time;

  Collection({
    required this.time,
    required this.name,
    required this.image,
  });

  factory Collection.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    getCustomFormattedDateTime(String givenDateTime, String dateFormat) {
      // dateFormat = 'MM/dd/yy';
      final DateTime docDateTime = DateTime.parse(givenDateTime);
      return DateFormat(dateFormat).format(docDateTime);
    }

    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    monthgenrater(String date) {
      switch (date) {
        case "01":
          return months[0];
        case "02":
          return months[1];
        case "03":
          return months[2];
        case "04":
          return months[3];
        case "05":
          return months[4];
        case "06":
          return months[5];
        case "07":
          return months[6];
        case "08":
          return months[7];
        case "09":
          return months[8];
        case "10":
          return months[9];
        case "11":
          return months[10];
        case "12":
          return months[11];
        default:
          return date + ",";
      }
    }

    var string = '';
    try {
      var date = getCustomFormattedDateTime(
          DateTime.parse(doc.data()['time'].toDate().toString()).toString(),
          'dd/MM/yy');
      string =
          "${monthgenrater(date.split('/')[1])} ${date.split("/")[0]}, 20${date.split("/")[2]}";
    } catch (e) {}

    return new Collection(
      image: doc.data()['image'] ?? '',
      name: doc.data()['name'] ?? '',
      time: string,
    );
  }
}

class CollectionList {
  final List<Collection> list;
  CollectionList({
    required this.list,
  });
  factory CollectionList.fromDoc(QuerySnapshot<Map<String, dynamic>> doc) {
    return new CollectionList(
        list: doc.docs.map((all) => Collection.fromDoc(all)).toList());
  }
}
