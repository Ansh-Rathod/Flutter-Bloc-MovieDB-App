import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:moviedb/models/movie_model.dart';

import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewPhotos extends StatefulWidget {
  final int imageIndex;
  final Color color;
  final List<ImageBackdrop> imageList;
  ViewPhotos({
    Key? key,
    required this.imageIndex,
    required this.color,
    required this.imageList,
  }) : super(key: key);
  @override
  _ViewPhotosState createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  late PageController pageController;
  late int currentIndex;
  // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = widget.imageIndex;
    pageController = PageController(initialPage: widget.imageIndex);

    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    // final iOS = IOSInitializationSettings();
    // final initSettings = InitializationSettings(android: android, iOS: iOS);

    // flutterLocalNotificationsPlugin.initialize(initSettings,
    //     onSelectNotification: _onSelectNotification);
  }

  // Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
  //   final android = AndroidNotificationDetails(
  //       'channel id', 'channel name', 'channel description',
  //       priority: Priority.high, importance: Importance.max);
  //   final iOS = IOSNotificationDetails();
  //   final platform = NotificationDetails(android: android, iOS: iOS);
  //   final json = jsonEncode(downloadStatus);
  //   final isSuccess = downloadStatus['isSuccess'];

  //   await flutterLocalNotificationsPlugin.show(
  //       0, // notification id
  //       isSuccess ? 'Success' : 'Failure',
  //       isSuccess
  //           ? 'File has been downloaded successfully!'
  //           : 'There was an error while downloading the file.',
  //       platform,
  //       payload: json);
  // }

  // Future<void> _onSelectNotification(String? json) async {
  //   final obj = jsonDecode(json!);

  //   if (obj['isSuccess']) {
  //     OpenFile.open(obj['filePath']);
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         title: Text('Error'),
  //         content: Text('${obj['error']}'),
  //       ),
  //     );
  //   }
  // }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  // Future<String> createFolder() async {
  //   final folderName = 'TiViBu';
  //   String pathDoc = await ExtStorage.getExternalStoragePublicDirectory(
  //       ExtStorage.DIRECTORY_PICTURES);
  //   final path = Directory(pathDoc + "/$folderName");
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     await Permission.storage.request();
  //   }
  //   if ((await path.exists())) {
  //     return path.path;
  //   } else {
  //     path.create();
  //     return path.path;
  //   }
  // }

  // Future download2(Dio dio, String url, String savePath) async {
  //   Map<String, dynamic> result = {
  //     'isSuccess': false,
  //     'filePath': null,
  //     'error': null,
  //   };
  //   try {
  //     final response = await dio.download(
  //       url,
  //       "${savePath}/${widget.imageList[currentIndex].image.split("/")[6]}",
  //     );
  //     result['isSuccess'] = response.statusCode == 200;
  //     result['filePath'] =
  //         "${savePath}/${widget.imageList[currentIndex].image.split("/")[6]}";
  //   } catch (e) {
  //     result['error'] = e.toString();
  //     print(e);
  //   } finally {
  //     await _showNotification(result);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          // IconButton(
          //     onPressed: () async {
          //       final status = await Permission.storage.request();
          //       final extPath = await createFolder();
          //       print(extPath);
          //       var dio = Dio();
          //       final snackBar = SnackBar(
          //           backgroundColor: Colors.cyanAccent,
          //           content: Text(
          //             'Downloading started',
          //             style: normalText.copyWith(color: Colors.black),
          //           ));

          //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //       download2(dio, widget.imageList[currentIndex].image, extPath);
          //     },
          //     icon: Icon(Icons.download))
        ],
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        pageController: pageController,
        builder: (BuildContext context, int i) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage("${widget.imageList[i].image}"),
            minScale: PhotoViewComputedScale.contained,
            heroAttributes:
                PhotoViewHeroAttributes(tag: "photo${widget.imageIndex}"),
          );
        },
        onPageChanged: onPageChanged,
        itemCount: widget.imageList.length,
        loadingBuilder: (context, progress) => Center(
          child: Container(
            child: CircularProgressIndicator(
              color: Colors.cyanAccent,
              backgroundColor: Colors.grey.shade800,
              value: progress == null
                  ? null
                  : progress.cumulativeBytesLoaded /
                      progress.expectedTotalBytes!,
            ),
          ),
        ),
      ),
    );
  }
}
