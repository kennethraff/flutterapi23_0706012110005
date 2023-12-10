part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Province> provinceData = [];
  bool isLoading = true;

  String kurir = 'jne';
  var kurirchosen = ['jne', 'pos', 'tiki'];
////////////////////////////////////// ambil data provinsi /////////////////////////////////////////
  dynamic provId;
  dynamic listProvince;
  dynamic selectedProvOrigin;
  dynamic selectedProvDestination;

  Future<List<Province>> getProvinces() async {
    dynamic provinceData;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        provinceData = value;
        isLoading = false;
      });
    });
    return provinceData;
  }

////////////////////////////////////// ambil data kota /////////////////////////////////////////
  dynamic cityDataOrigin;
  dynamic cityIdOrigin;
  dynamic selectedCityOrigin;

  dynamic cityDataDestination;
  dynamic cityIdDestination;
  dynamic selectedCityDestination;

  Future<List<City>> getCities(var provId) async {
    dynamic city;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        city = value;
      });
    });

    return city;
  }

////////////////////////////////////// ambil data ongkir /////////////////////////////////////////
  ///
  ///
  bool isProvinceOriginSelected = false;
  bool isCityOriginSelected = false;

  bool isProvinceDestinationSelected = false;
  bool isCityDestinationSelected = false;
  final weight = TextEditingController();
  List<Costs> listCosts = [];
  Future<dynamic> getCostsData() async {
    await MasterDataService.getCosts(
            cityIdOrigin, cityIdDestination, int.parse(weight.text), kurir)
        .then((value) {
      setState(() {
        listCosts = value;
        isLoading = false;
      });
      print(listCosts.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    listProvince = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
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
                      flex: 1,
                      child: DropdownButton(
                          value: kurir,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: kurirchosen.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              kurir = newValue!;
                            });
                          }),
                    ),
                    SizedBox(
                        width: 200,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: weight,
                          decoration: const InputDecoration(
                            labelText: 'Berat (gr)',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return value == null || value == 0
                                ? 'Berat harus diisi dan tidak boleh 0!'
                                : null;
                          },
                        ))
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
                                  child: FutureBuilder<List<Province>>(
                                    future: listProvince,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return DropdownButton(
                                            isExpanded: true,
                                            value: selectedProvOrigin,
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 30,
                                            elevation: 4,
                                            style:
                                                TextStyle(color: Colors.black),
                                            hint: selectedProvOrigin == null
                                                ? Text("Select Province")
                                                : Text(selectedProvOrigin
                                                    .province),
                                            items: snapshot.data!.map<
                                                    DropdownMenuItem<Province>>(
                                                (Province value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.province.toString()),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedProvOrigin = newValue;
                                                provId = selectedProvOrigin
                                                    .provinceId;
                                                isProvinceOriginSelected = true;
                                              });
                                              selectedCityOrigin = null;
                                              cityDataOrigin =
                                                  getCities(provId);
                                            });
                                      } else if (snapshot.hasError) {
                                        return Text("Tidak ada data");
                                      }
                                      return UiLoading.loadingSmall();
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
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return DropdownButton(
                                            isExpanded: true,
                                            value: selectedCityOrigin,
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 30,
                                            elevation: 4,
                                            style:
                                                TextStyle(color: Colors.black),
                                            hint: selectedCityOrigin == null
                                                ? Text("Select City")
                                                : Text(selectedCityOrigin
                                                    .cityName),
                                            items: snapshot.data!
                                                .map<DropdownMenuItem<City>>(
                                                    (City value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.cityName.toString()),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedCityOrigin = newValue;
                                                isCityOriginSelected = true;
                                                cityIdOrigin =
                                                    selectedCityOrigin.cityId;
                                              });
                                            });
                                      } else if (snapshot.hasError) {
                                        return Text("Tidak ada data");
                                      }
                                      if (isProvinceOriginSelected == false) {
                                        return Text(
                                            "Pilih provinsi asal terlebih dahulu");
                                      } else {
                                        return UiLoading.loadingSmall();
                                      }
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
                                  child: FutureBuilder<List<Province>>(
                                    future: listProvince,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return DropdownButton(
                                            isExpanded: true,
                                            value: selectedProvDestination,
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 30,
                                            elevation: 4,
                                            style:
                                                TextStyle(color: Colors.black),
                                            hint: selectedProvDestination ==
                                                    null
                                                ? Text("Select Province")
                                                : Text(selectedProvDestination
                                                    .province),
                                            items: snapshot.data!.map<
                                                    DropdownMenuItem<Province>>(
                                                (Province value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.province.toString()),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedProvDestination =
                                                    newValue;
                                                provId = selectedProvDestination
                                                    .provinceId;
                                              });
                                              selectedCityDestination = null;
                                              cityDataDestination =
                                                  getCities(provId);
                                            });
                                      } else if (snapshot.hasError) {
                                        return Text("Tidak ada data");
                                      }
                                      return UiLoading.loadingSmall();
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
                                    future: cityDataDestination,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return DropdownButton(
                                            isExpanded: true,
                                            value: selectedCityDestination,
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 30,
                                            elevation: 4,
                                            style:
                                                TextStyle(color: Colors.black),
                                            hint: selectedCityDestination ==
                                                    null
                                                ? Text("Select City")
                                                : Text(selectedCityDestination
                                                    .cityName),
                                            items: snapshot.data!
                                                .map<DropdownMenuItem<City>>(
                                                    (City value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.cityName.toString()),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedCityDestination =
                                                    newValue;
                                                isCityDestinationSelected =
                                                    true;
                                                cityIdDestination =
                                                    selectedCityDestination
                                                        .cityId;
                                              });
                                            });
                                      } else if (snapshot.hasError) {
                                        return Text("Tidak ada data");
                                      }
                                      if (isProvinceDestinationSelected ==
                                          false) {
                                        return Text(
                                            "Pilih provinsi tujuan terlebih dahulu");
                                      } else {
                                        return UiLoading.loadingSmall();
                                      }
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
                child: Container(),
              ),
              SizedBox(height: 0),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ))),
                  onPressed: () async {
                    if (isProvinceDestinationSelected == true &&
                        isProvinceOriginSelected == true &&
                        isCityDestinationSelected == true &&
                        isCityOriginSelected == true &&
                        kurir.isNotEmpty &&
                        weight.text.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });
                      await getCostsData();
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Lengkapi data terlebih dahulu"),
                        ),
                      );
                    }
                  },
                  child: Text("Hitung Estimasi Harga"))
            ],
          ),
          isLoading == true ? UiLoading.loadingBlock() : Container(),

          Flexible(
                        flex: 4,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: listCosts.isEmpty
                              ? const Align(
                                  alignment: Alignment.topCenter,
                                  child: Text("Silakan isi semua field terlebih dahulu"))
                              : ListView.builder(
                                  itemCount: listCosts.length,
                                  itemBuilder: (context, index) {
                                    
                                  },
                                ),
                        ),
          ),
        ],
      ),
    );
  }
}
