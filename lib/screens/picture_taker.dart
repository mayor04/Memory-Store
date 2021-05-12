import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_cloud_server/general_widgets/button.dart';
import 'package:image_cloud_server/general_widgets/min_container.dart';
import 'package:image_cloud_server/providers/auth_provider.dart';
import 'package:image_cloud_server/providers/media_provider.dart';
import 'package:image_cloud_server/screens/picture_display.dart';
import 'package:image_cloud_server/utils/design.dart';
import 'package:provider/provider.dart';

class TakePictureScreen extends StatefulWidget {
  TakePictureScreen({Key? key}) : super(key: key);

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  CameraController? controller;
  Future? loadCam;

  String? filePath;
  MediaProvider? mediaProvider;
  LoadState uploadState = LoadState.idle;

  @override
  void initState() {
    super.initState();

    loadCam = loadCameras();
  }

  Future loadCameras() async {
    List cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.high);

    await controller?.initialize();
    controller?.setFlashMode(FlashMode.off);
    controller?.setFocusMode(FocusMode.auto);
  }

  @override
  void dispose() {
    controller?.dispose();
    print('disposing camera');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        color: Colors.grey[900],
        alignment: Alignment.center,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 50,
                alignment: Alignment(-0.9, 0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey[500],
                  size: 25,
                ),
              ),
              Expanded(
                flex: 8,
                child: FutureBuilder(
                  future: loadCam,
                  builder: (context, snapshot) {
                    if (controller == null) return Container();
                    return MinContainer(
                      width: controller?.value.previewSize?.width ?? 300,
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      // color: Colors.blue,
                      alignment: Alignment.center,
                      radius: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: filePath != null
                            ? Image.file(
                                File(filePath ?? ''),
                              )
                            : CameraPreview(controller!),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: filePath == null
                    ? takePictureButton()
                    : savePictureButton(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget takePictureButton() {
    return FloatButton(
      iconData: Icons.camera,
      onPressed: () async {
        try {
          await loadCam;
          final image = await controller?.takePicture();

          filePath = image?.path;
          setState(() {});
        } catch (error) {
          print(error);
        }
      },
    );
  }

  Widget savePictureButton() {
    if (uploadState == LoadState.loading) {
      return Center(
        child: Container(
          width: 100,
          height: 10,
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey[600],
            valueColor: AlwaysStoppedAnimation(Colors.blue[400]),
          ),
        ),
      );
    }

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatButton(
            color: Colors.grey[100],
            iconColor: Colors.grey[800],
            iconData: Icons.cancel,
            onPressed: () {
              filePath = null;
              setState(() {});
            },
          ),
          FloatButton(
            color: Colors.blue[400],
            iconData: Icons.upload,
            onPressed: () async {
              //save to database first
              uploadState = LoadState.loading;
              setState(() {});

              await mediaProvider?.uploadImages(filePath ?? '');
              uploadState = LoadState.idle;

              filePath = null;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
