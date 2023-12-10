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

    List<City> selectedCities = [];
    for(var c in result){
      if(c.provinceId == provID){
        selectedCities.add(c);
      }
    }

    return selectedCities;
    
  }
  ////////////////////////// End of Ambil data kota dari API ////////////////////////
  ////////////////////////// Ambil data ongkos kirim dari API ////////////////////////
  ///
  
  static Future<http.Response> getOngkir() {
    return http.post(
      Uri.https(Const.baseUrl, "/starter/cost"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'key': Const.apiKey,
      },
      body: jsonEncode(<String, dynamic>{
        'origin': '501',
        'destination': '114',
        'weight': 2500,
        'courier': 'jne',
      }),
    );
  }
  static Future<List<Costs>> getCosts(
      dynamic ori, dynamic des, int weight, dynamic courier) async {
    var response = await http.post(
      Uri.https(Const.baseUrl, "/starter/cost"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'key': Const.apiKey,
      },
      body: jsonEncode(<String, dynamic>{
        'origin': ori,
        'destination': des,
        'weight': weight,
        'courier': courier,
      }),
    );
    var job = json.decode(response.body);
    List<Costs> costs = [];

    if (response.statusCode == 200) {
      costs = (job['rajaongkir']['results'][0]['costs'] as List)
          .map((e) => Costs.fromJson(e))
          .toList();
    }

    return costs;
  }
}
