import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cloud_server/general_widgets/icon.dart';
import 'package:image_cloud_server/general_widgets/min_container.dart';
import 'package:image_cloud_server/models/ImageModel.dart';
import 'package:image_cloud_server/providers/auth_provider.dart';
import 'package:image_cloud_server/providers/media_provider.dart';
import 'package:image_cloud_server/utils/design.dart';
import 'package:image_cloud_server/utils/text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // AuthProvider authProvider;
  MediaProvider? mediaProvider;

  @override
  void initState() {
    super.initState();
  }

  initProvider() {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    mediaProvider = Provider.of<MediaProvider>(context);
    mediaProvider?.setToken(authProvider.authToken);

    mediaProvider?.getAllImages();

    var map = mediaProvider?.imageMap;
    print(map);
  }

  @override
  Widget build(BuildContext context) {
    initProvider();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            header(),
            Expanded(
              child: body(),
            ),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return MinContainer(
      color: Colors.white,
      height: 53,
      boxShadow: [
        BoxShadow(
          color: Colors.grey[200] ?? Colors.grey,
          offset: Offset(0, -1),
          blurRadius: 6,
          spreadRadius: 4,
        )
      ],
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.menu,
            color: Colors.grey[300],
          ),
          AppIcon(iconSize: AppIconSize.small),
          Icon(
            Icons.person_pin,
            color: Design.kRed,
          ),
        ],
      ),
    );
  }

  Widget body() {
    List<String> dates = mediaProvider?.getDates() ?? [];

    return Stack(
      children: [
        ListView.builder(
          itemCount: dates.length,
          itemBuilder: (_, pos) {
            List<ImageModel>? imageList =
                mediaProvider?.getImagesFromDate(dates[pos]);

            return imagesWrap(dates[pos], imageList ?? []);
          },
        ),
        Positioned(
          bottom: 30,
          right: 30,
          child: FloatingActionButton(
            backgroundColor: Design.kRed,
            onPressed: () {
              Navigator.pushNamed(context, '/takePicture');
            },
            child: Center(
              child: Icon(
                Icons.add_a_photo_outlined,
                color: Colors.grey[300],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget imagesWrap(String date, List<ImageModel> imageList) {
    Widget dateComponent() {
      return Container(
        height: 50,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(20, 17, 0, 0),
        child: Text(
          date,
          style: TextDesign.normal(),
        ),
      );
    }

    Widget image({required String url}) {
      return MinContainer(
        height: 80,
        width: 90,
        radius: 7,
        margin: EdgeInsets.fromLTRB(11, 0, 10, 10),
        borderColor: Design.lightText,
        borderWidth: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            url,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    Widget wrap() {
      List<Widget> wrapWidget = [];
      for (int i = 0; i < imageList.length; i++) {
        wrapWidget.add(
          image(url: imageList[i].url),
        );
      }

      return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(9, 0, 0, 9),
        child: Wrap(
          children: wrapWidget,
          alignment: WrapAlignment.start,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        dateComponent(),
        wrap(),
      ],
    );
  }

  //Todo: Implement a dialog to allow user to pick a selection mode
  showPickDialog() {
    Widget pictureActionBox() {
      return Row();
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [],
          ),
        );
      },
    );
  }

  runTesting() async {
    final directory = await getApplicationDocumentsDirectory();

    print(directory.path);
  }

  runTest2() async {
    ImagePicker imagePicker = ImagePicker();

    PickedFile? file = await imagePicker.getImage(source: ImageSource.camera);

    print(file?.path);
  }
}
