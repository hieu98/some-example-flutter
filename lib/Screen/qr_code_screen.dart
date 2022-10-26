import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Screen/web_view_screen.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  String result = "Please scan QR code or Barcode";
  ScanResult? scanResult;

  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');

  final _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  final _selectedCamera = -1;
  final _useAutoFocus = true;
  final _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });
  }

  Future<void> _scanQR() async {
    try {
      final qrResult = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': _cancelController.text,
            'flash_on': _flashOnController.text,
            'flash_off': _flashOffController.text,
          },
          restrictFormat: selectedFormats,
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      setState(() {
        scanResult = qrResult;
        result = scanResult!.rawContent;
      });
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  scanResult != null
                      ? Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/rose.jpg'),
                                Container(
                                  padding: EdgeInsets.only(top: 15, bottom: 10),
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: scanResult!.rawContent),
                                    autofocus: false,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Url',
                                        icon: Icon(Icons.link)),
                                    onChanged: (text) {
                                      result = text;
                                    },
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      goWebView(result);
                                    },
                                    child: Text('Go'))
                              ],
                            ),
                          )
                      : Text(
                          result,
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        _scanQR();
                      },
                      label: Text('Scan'),
                      icon: Icon(Icons.camera_alt),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void goWebView(String url) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewScreen(
                  urlWebView: url,
                )));
  }
}
