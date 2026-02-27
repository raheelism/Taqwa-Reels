import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  final r = await dio.get(
    'https://pixabay.com/api/videos/',
    options: Options(validateStatus: (status) => true),
    queryParameters: {
      'key': '54668314-f82f212a8c835c5547884c861',
      'q': 'mosque',
    },
  );

  if (r.statusCode == 200) {
    if (r.data['hits'].isNotEmpty) {
      var h = r.data['hits'][0];
      print('Keys: ${h.keys}');
      print('Duration: ${h['duration']} (type: ${h['duration'].runtimeType})');
    }
  } else {
    print('Failed: ${r.data}');
  }
}
