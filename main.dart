import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: QRViewExample()));

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class QRViewExample extends StatefulWidget {
  const QRViewExample({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  var qrText = '';
  var flashState = flashOn;
  var cameraState = frontCamera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Stack(children: [
              QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      color: Colors.white,
                      icon: Icon((flashState == flashOn)
                          ? Icons.flash_off
                          : Icons.flash_on),
                      onPressed: () {
                        if (controller != null) {
                          controller.toggleFlash();
                          if (_isFlashOn(flashState)) {
                            setState(() {
                              flashState = flashOff;
                            });
                          } else {
                            setState(() {
                              flashState = flashOn;
                            });
                          }
                        }
                      },
                    ),
                    IconButton(
                      color: Colors.white,
                      icon: Icon((cameraState == frontCamera)
                          ? Icons.camera_front
                          : Icons.camera_rear),
                      onPressed: () {
                        if (controller != null) {
                          controller.flipCamera();
                          if (_isBackCamera(cameraState)) {
                            setState(() {
                              cameraState = frontCamera;
                            });
                          } else {
                            setState(() {
                              cameraState = backCamera;
                            });
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            ]),
          ),
          Expanded(
              flex: 2,
              child: Container(
                color: Colors.blueGrey[50],
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'This is the result of scan: $qrText',
                          style: GoogleFonts.roboto(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                   Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(8),
                          child: RaisedButton(
                            color: Colors.blue,
                            onPressed: () {
                              controller?.pauseCamera();
                            },
                            child:
                                Text('Pause', style: GoogleFonts.roboto(color: Colors.white)),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          margin: EdgeInsets.all(8),
                          child: RaisedButton(
                            color: Colors.blue,
                            onPressed: () {
                              controller?.resumeCamera();
                            },
                            child:
                                Text('Resume', style: GoogleFonts.roboto(color: Colors.white)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  bool _isBackCamera(String current) {
    return backCamera == current;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
