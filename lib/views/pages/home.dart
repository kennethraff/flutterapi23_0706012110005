part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Province> provinceData = [];
  bool isLoading = true;

  Future<dynamic> getProvinces() async {
    await MasterDataService.getProvince().then((value) {
      setState(() {
        provinceData = value;
        isLoading = false;
      });
    });
  }

  dynamic cityDataOrigin;
  dynamic cityIdOrigin;
  dynamic selectedCityOrigin;

  Future<List<City>> getCities(var provId) async {
    dynamic city;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        city = value;
      });
    });

    return city;
  }

  Future<List<Province>> getProvince(var provId) async {
    dynamic city;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        city = value;
      });
    });

    return city;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getProvinces();
    cityDataOrigin = getCities("10");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Hitung Ongkir"),
        titleTextStyle: TextStyle(color: Colors.white),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ///////////////////////////// WEIGHT /////////////////////////////
              Flexible(
                child: Row(
                  children: [
                    Expanded(
                      // Wrap the DropdownButton with Expanded
                      child: Container(
                        child: DropdownButton<String>(
                          isExpanded: false, // Set this to false
                          hint: Text('kurir'),
                          items: <String>['Option 1', 'Option 2', 'Option 3']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                    SizedBox(
                        width:
                            80), // Optional: Adds some spacing between the DropdownButton and TextField
                    Expanded(
                      // Wrap the TextField with Expanded
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Berat (gram)',
                          hintText: 'Masukkan berat dalam gr',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              ///////////////////////////// ORIGIN /////////////////////////////
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Origin",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 150,
                                  child: FutureBuilder<List<City>>(
                                    future: cityDataOrigin,
                                    builder: (context, snapshot){
                                      if(snapshot.hasData){
                                        return DropdownButton(
                                          isExpanded: true,
                                          value: selectedCityOrigin,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 4,
                                          style: TextStyle(color: Colors.black),
                                          hint: selectedCityOrigin == null
                                          ? Text("Select Province")
                                          : Text(selectedCityOrigin.cityName),
                                          items: snapshot.data!.map<DropdownMenuItem<City>>((City value){
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value.cityName.toString()),
                                            );
                                          }).toList(),
                                          onChanged: (newValue){
                                            setState(() {
                                              selectedCityOrigin = newValue;
                                              cityIdOrigin = selectedCityOrigin.cityId;
                                            });
                                          });
                                      } else if(snapshot.hasError){
                                        return Text("Tidak ada data");
                                      }
                                      return UiLoading.loadingDD();
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 50),
                            Column(
                              children: [
                                Container(
                                  width: 150,
                                  child: FutureBuilder<List<City>>(
                                    future: cityDataOrigin,
                                    builder: (context, snapshot){
                                      if(snapshot.hasData){
                                        return DropdownButton(
                                          isExpanded: true,
                                          value: selectedCityOrigin,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 4,
                                          style: TextStyle(color: Colors.black),
                                          hint: selectedCityOrigin == null
                                          ? Text("Select City")
                                          : Text(selectedCityOrigin.cityName),
                                          items: snapshot.data!.map<DropdownMenuItem<City>>((City value){
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value.cityName.toString()),
                                            );
                                          }).toList(),
                                          onChanged: (newValue){
                                            setState(() {
                                              selectedCityOrigin = newValue;
                                              cityIdOrigin = selectedCityOrigin.cityId;
                                            });
                                          });
                                      } else if(snapshot.hasError){
                                        return Text("Tidak ada data");
                                      }
                                      return UiLoading.loadingDD();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              ///////////////////////////// DESTINATION /////////////////////////////
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Destination",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 150,
                                  child: FutureBuilder<List<City>>(
                                    future: cityDataOrigin,
                                    builder: (context, snapshot){
                                      if(snapshot.hasData){
                                        return DropdownButton(
                                          isExpanded: true,
                                          value: selectedCityOrigin,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 4,
                                          style: TextStyle(color: Colors.black),
                                          hint: selectedCityOrigin == null
                                          ? Text("Select Province")
                                          : Text(selectedCityOrigin.cityName),
                                          items: snapshot.data!.map<DropdownMenuItem<City>>((City value){
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value.cityName.toString()),
                                            );
                                          }).toList(),
                                          onChanged: (newValue){
                                            setState(() {
                                              selectedCityOrigin = newValue;
                                              cityIdOrigin = selectedCityOrigin.cityId;
                                            });
                                          });
                                      } else if(snapshot.hasError){
                                        return Text("Tidak ada data");
                                      }
                                      return UiLoading.loadingDD();
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 50),
                            Column(
                              children: [
                                Container(
                                  width: 150,
                                  child: FutureBuilder<List<City>>(
                                    future: cityDataOrigin,
                                    builder: (context, snapshot){
                                      if(snapshot.hasData){
                                        return DropdownButton(
                                          isExpanded: true,
                                          value: selectedCityOrigin,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 4,
                                          style: TextStyle(color: Colors.black),
                                          hint: selectedCityOrigin == null
                                          ? Text("Select City")
                                          : Text(selectedCityOrigin.cityName),
                                          items: snapshot.data!.map<DropdownMenuItem<City>>((City value){
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value.cityName.toString()),
                                            );
                                          }).toList(),
                                          onChanged: (newValue){
                                            setState(() {
                                              selectedCityOrigin = newValue;
                                              cityIdOrigin = selectedCityOrigin.cityId;
                                            });
                                          });
                                      } else if(snapshot.hasError){
                                        return Text("Tidak ada data");
                                      }
                                      return UiLoading.loadingDD();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: provinceData.isEmpty
                        ? const Align(
                            alignment: Alignment.center,
                            child: Text("No Data Was Found"),
                          )
                        : ListView.builder(
                            itemCount: provinceData.length,
                            itemBuilder: (context, index) {
                              return CardProvince(provinceData[index]);
                            },
                          )),
              ),
            ],
          ),
          isLoading == true ? UiLoading.loadingBlock() : Container(),
        ],
      ),
    );
  }
}
