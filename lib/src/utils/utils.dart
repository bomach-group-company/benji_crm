import 'package:url_launcher/url_launcher.dart';

Future<void> launchDownloadLinkAndroid() async {
  final url = Uri.parse('https://bomachgroup.com/');
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
    webViewConfiguration: const WebViewConfiguration(
        headers: <String, String>{'my_header_key': 'my_header_value'}),
  )) {
    throw Exception('Could not launch $url');
  }
}


Future<void> launchDownload(String openUrl) async {
  final url = Uri.parse(openUrl);
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
    webViewConfiguration: const WebViewConfiguration(
        headers: <String, String>{'my_header_key': 'my_header_value'}),
  )) {
    throw Exception('Could not launch $url');
  }
}
