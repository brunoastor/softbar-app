import 'dart:collection';

import 'package:flutter/material.dart';
import 'scanner_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  MobileScannerController cameraController = MobileScannerController();

  var index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Stack(
          children: [
            MobileScanner(
                controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.normal,
                ),
                startDelay: true,
                onDetect: _foundBarCode
            ),
            ScannerOverlay(overlayColour: Colors.black.withOpacity(0.5))
          ],
        )
    );
  }

  void _foundBarCode(BarcodeCapture barcode) {
    final List<Barcode> codes = barcode.barcodes;
    for (final barcode in codes) {
      final Map<int, String> values = HashMap();
      values.addAll({index : '${barcode.rawValue}'});
      index++;
      print(values);
    }
  }
}