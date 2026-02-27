import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  final r = await dio.get(
    'https://pixabay.com/api/videos/',
    queryParameters: {
      'key': '54668314-f82f212a8c835c5547884c861',
      'q': 'mosque -people -man -woman -face -portrait -girl -boy',
      'per_page': 3,
      'safesearch': 'true',
    },
  );

  for (var h in r.data['hits']) {
    print('ID: ${h['id']}');
    print('Picture ID: ${h['picture_id']}');
    print('Videos: ${h['videos']['tiny']}');
    print('---');
  }
}
