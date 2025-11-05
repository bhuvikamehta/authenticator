import 'dart:io';
import 'package:auth_app/Models/account.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


Future<String?> getStringFromQR(File imageFile) async {
  
  try {
    final MobileScannerController controller = MobileScannerController();
    
    // Analyze the image
    final BarcodeCapture? barcodeCapture = await controller.analyzeImage(imageFile.path);
    
    await controller.dispose();
    
    if (barcodeCapture == null || barcodeCapture.barcodes.isEmpty) {
      return null;
    }
    
    final String? qrData = barcodeCapture.barcodes.first.rawValue;
    
    if (qrData == null || qrData.isEmpty) {
      return null;
    }
    
    return qrData;
  } catch (e) {
    return null;
  }
}

Future<TOTPCard> getCardFromQR(String? qrData) async{
  if (qrData == null || qrData.isEmpty) {
    throw Exception('No QR code data provided');
  }
  
  // Parse the QR data to extract TOTPCard information
  // otpauth://totp/ACME%20Co:john.doe@email.com?secret=HXDMVJECJJWSRB3HWIZR4IFUGFTMXBOZ&issuer=ACME%20Co&algorithm=SHA1&digits=6&period=30
  qrData = qrData.replaceFirst('otpauth://totp/', '');
  // first part of the string is label, rest are parameters
  List<String> parts = qrData.split('?');
  String labelPart = parts[0];
  String paramsPart = parts[1];
  // splitting the label into issuer and account name
  List<String> labelComponents = labelPart.split(':');
  String issuer = labelComponents.length > 1 ? Uri.decodeComponent(labelComponents[0]) : '';
  String accountName = Uri.decodeComponent(labelComponents.length > 1 ? labelComponents[1] : labelComponents[0]);
  // getting the params
  Map<String, String> params = {};
  for (String param in paramsPart.split('&')) {
    List<String> keyValue = param.split('=');
    params[Uri.decodeComponent(keyValue[0])] = Uri.decodeComponent(keyValue[1]);
  }
  String secret = params['secret'] ?? '';
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  DateTime createdAt = DateTime.now();    
  TOTPCard totpCard = TOTPCard(
    id: id,
    accountName: accountName,
    issuer: issuer,
    secret: secret,
    createdAt: createdAt
  );
  return totpCard;
}

// Parse QR data string into TOTP Card
Future<TOTPCard> parseTOTPFromQR(String qrData) async {
  return await getCardFromQR(qrData);
}

// Scan QR code from image file
Future<TOTPCard?> scanQRFromImage(File imageFile) async {
  try {
    String? qrData = await getStringFromQR(imageFile);
    if (qrData == null) {
      throw Exception('No QR code found in the image');
    }
    
    TOTPCard totpCard = await getCardFromQR(qrData);
    return totpCard;
  } catch (e) {
    rethrow;
  }
}