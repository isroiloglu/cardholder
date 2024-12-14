import 'package:card_holder/core/models/card_model.dart';
import 'package:dio/dio.dart';

class CardRepository {
  Dio dio = Dio();

  Future<String> uploadPhoto(String file) async {
    String fileName = file.split('/').last;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(file, filename: fileName),
    });
    Response response = await dio.post(
      'mockAPi.com',
      data: formData,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer \$token",
        },
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );

    if (response.statusCode == 201) {
      var model = response.data['result'];
      return model;
    } else {
      return 'mock';
      // throw Exception(response.data["data"]["error"]);
    }
  }

  Future<void> saveCard(CardModel model) async {
    var data = cardModelToJson(model);
    await dio.post(
      'mockAPi.com',
      data: data,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer \$token",
        },
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    // if (response.statusCode != 200) {
    //   throw Exception(response.data);
    // }
  }
}
