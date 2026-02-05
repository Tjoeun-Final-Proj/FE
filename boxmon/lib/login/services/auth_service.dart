import '../models/token_model.dart';

class AuthService {
  String? accessToken;
  String? refreshToken;
  late Token token;
  // final TokenService tokenController = TokenService();

  // 함수 나중에 넣어둘게요~~
  // Future<bool> login(String email, String password) async {
  //   final lambdaResponse = await http.post(
  //   );
  //   var responseData = jsonDecode(lambdaResponse.body);
  //   try {
  //     if (response.statusCode == 200) {
  //       final data = response.body;
  //       if (data.containsKey('accessToken') &&
  //           data.containsKey('refreshToken') &&
  //           data.containsKey('user_id') &&
  //           data.containsKey('is_owner')) {

  //         token = Token(
  //           accessToken: data['accessToken'],
  //           refreshToken: data['refreshToken'],
  //           userId: data['user_id'].toString(),
  //           isOwner: data['is_owner'], // 서버에서 int로 내려오므로 그대로
  //         );

  //         await tokenController.saveToken(
  //           token.accessToken,
  //           token.refreshToken,
  //           token.userId,
  //           token.isOwner.toString(), // ✅ 반드시 toString()
  //         );

  //         return true;
  //       } else {
  //         return false;
  //       }
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     print("JSON Parsing Error: $e");
  //     return false;
  //   }
  // }

  // void logout() {
  //   tokenController.clearToken();
  // }

// 미들웨어로 쓸 예정이에요 26.02.05
  // Future<bool> commonRegistration(String id, String pw, String name, String nickname, String number, String gender) async {
  //   final lambdaResponse = await http.post(
  //     Uri.parse(
  //         'https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/SignUp'),
  //     body: jsonEncode({
  //       "id": id,
  //       "pw": pw,
  //       "name": name,
  //       "nickname": nickname,
  //       "number": number,
  //       "gender": gender,
  //       "is_owner": "0"
  //     }),
  //     headers: {'Content-Type': 'application/json; charset=UTF-8'},
  //   );
  //   var responseData = jsonDecode(lambdaResponse.body);
  //   final LambdaResponse response = LambdaResponse.fromJson(responseData);
  //   try{
  //     if(response.statusCode == 200){
  //       return true;
  //     }
  //     else{
  //       return false;
  //     }
  //   } catch (e){
  //     print("JSON Parsing Error: $e");
  //     return false;
  //   }
  // }

// 미들웨어로 쓸 예정이에요 26.02.05
  // Future<bool> ownerRegistration(String id, String pw, String name, String nickname, String number, String gender) async {
  //   final lambdaResponse = await http.post(
  //     Uri.parse(
  //         'https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/SignUp'),
  //     body: jsonEncode({
  //       "id": id,
  //       "pw": pw,
  //       "name": name,
  //       "nickname": nickname,
  //       "number": number,
  //       "gender": gender,
  //       "is_owner": "1"
  //     }),
  //     headers: {'Content-Type': 'application/json; charset=UTF-8'},
  //   );
  //   var responseData = jsonDecode(lambdaResponse.body);
  //   final LambdaResponse response = LambdaResponse.fromJson(responseData);
  //   try{
  //     if(response.statusCode == 200){
  //       return true;
  //     }
  //     else{
  //       return false;
  //     }
  //   } catch (e){
  //     print("JSON Parsing Error: $e");
  //     return false;
  //   }
  // }
}