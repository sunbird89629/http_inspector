import 'dart:convert';
import 'dart:io';

const String url =
    'https://open.feishu.cn/open-apis/bot/v2/hook/40d8befe-4f22-4baf-a97d-3d94b0f12406';

class FeishuSend {
  static Future<bool> sendMessage(String message) async {
    final body = {
      'msg_type': 'text',
      'content': {'text': message},
    };

    final client = HttpClient();
    final request = await client.postUrl(Uri.parse(url));
    request.headers.set('Content-Type', 'application/json');
    request.write(jsonEncode(body));
    final response = request.close();
    return true;
  }
}
