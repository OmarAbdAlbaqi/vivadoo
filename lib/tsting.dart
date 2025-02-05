import 'dart:convert';
import 'package:crypto/crypto.dart';

class AppSignature2 {
  /// Generates headers required for authentication
  static Map<String, String> generateHeaders({
    required String method,
    required String fullUrl,
    required String secretKey,
    required String publicKey,
    required String username,
  }) {
    // Parse the full URL to extract the base URL
    Uri uri = Uri.parse(fullUrl);
    String baseUrl = Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.port,
      path: uri.path,
    ).toString();

    // URL-encode the base URL
    baseUrl = Uri.encodeComponent(baseUrl);

    // Generate the current timestamp in ISO format
    String timestamp = DateTime.now().toUtc().toIso8601String();

    // Prepare required parameters
    List<String> requiredParams = [
      'username=${Uri.encodeComponent(username)}',
      'token=${Uri.encodeComponent(publicKey)}',
      'timestamp=${Uri.encodeComponent(timestamp)}',
    ];

    // Construct the base signature string
    String baseSignatureString = [
      method,
      baseUrl, // URL-encoded base URL
      ...requiredParams,
    ].join("&");

    // Generate the HMAC SHA-512 signature
    Hmac hmac = Hmac(sha512, utf8.encode(secretKey));
    Digest hmacSignature = hmac.convert(utf8.encode(baseSignatureString));

    // Convert signature to hex string
    String signatureHex = hmacSignature.toString();

    // Prepare the Authorization header
    String authorizationHeader = "AUTH $publicKey:$signatureHex";

    // Return headers
    return {
      'X-Once': timestamp,
      'Authorization': authorizationHeader,
    };
  }
}

void main() {
  // Example usage
  String method = "GET";
  String fullUrl = "https://example.com/resource?query=value#fragment";
  String secretKey = "your_secret_key";
  String publicKey = "your_public_key";
  String username = "your_username";

  Map<String, String> headers = AppSignature2.generateHeaders(
    method: method,
    fullUrl: fullUrl,
    secretKey: secretKey,
    publicKey: publicKey,
    username: username,
  );

  print('Generated Headers: $headers');
}
