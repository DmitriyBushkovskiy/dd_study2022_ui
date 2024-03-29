import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CamWidget extends StatefulWidget {
  final Function(File) onFile;
  final CameraShape shape;
  const CamWidget({
    Key? key,
    required this.onFile,
    required this.shape,
  }) : super(key: key);

  @override
  State<CamWidget> createState() => CamWidgetState();
}

class CamWidgetState extends State<CamWidget> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  asyncInit() async {
    var cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    await controller!.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!(controller?.value.isInitialized ?? false)) {
      return const Center(
          child: Text(
        "Camera initialize",
        style: TextStyle(color: Colors.white),
      ));
    }

    var camera = controller!.value;

    return LayoutBuilder(
      builder: (context, constraints) {
        var scale = (min(constraints.maxWidth, constraints.maxHeight) /
                max(constraints.maxWidth, constraints.maxHeight)) *
            camera.aspectRatio;

        if (scale < 1) scale = 1 / scale;

        return Stack(
          children: [
            Transform.scale(
              scale: scale,
              child: Center(
                child: CameraPreview(
                  controller!,
                ),
              ),
            ),
            ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.srcOut,
                ), // This one will create the magic
                child: Stack(fit: StackFit.expand, children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ), // This one will handle background + difference out
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: widget.shape == CameraShape.circle
                            ? BorderRadius.circular(
                                MediaQuery.of(context).size.width / 2,
                              )
                            : null,
                      ),
                    ),
                  ),
                ])),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 10),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      color: Colors.grey[400]!.withAlpha(150),
                      borderRadius: BorderRadius.circular(30)),
                  width: 60,
                  height: 60,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.camera),
                    color: Colors.white,
                    iconSize: 54,
                    onPressed: () async {
                      var file = await controller!.takePicture();
                      widget.onFile(File(file.path));
                    },
                  ),
                )
              ]),
            )
          ],
        );
      },
    );
  }
}

enum CameraShape { circle, square }
