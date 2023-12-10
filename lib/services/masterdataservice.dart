part of 'services.dart';

class MasterDataService {
  static Future<List<Province>> getProvince() async {
    var response = await http.get(
      Uri.https(Const.baseUrl, "/starter/province"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'key': Const.apiKey,
      },
    );

    var job = json.decode(response.body);
    List<Province> result = [];

    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => Province.fromMap(e))
          .toList();
    }

    return result;
  }
////////////////////////// Ambil data kota dari API ////////////////////////
  static Future<List<City>> getCity(var provID) async {
    var response = await http.get(
      Uri.https(Const.baseUrl, "/starter/city"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'key': Const.apiKey,
      },
    );

    var job = json.decode(response.body);
    List<City> result = [];

    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => City.fromMap(e))
          .toList();
    }
////////////////////////// End of Ambil data kota dari API ////////////////////////
    List<City> selectedCities = [];
    for(var c in result){
      if(c.provinceId == provID){
        selectedCities.add(c);
      }
    }

    return selectedCities;
    
  }
}
