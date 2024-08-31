import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Country {
  final int id;
  final String name;

  Country({required this.id, required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
    );
  }
}

class City {
  final int id;
  final String name;
  final int countryId;

  City({required this.id, required this.name, required this.countryId});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      countryId: json['country_id'],
    );
  }
}

// Mendapatkan daftar negara
Future<List<Country>> fetchCountries() async {
  final response = await http.get(Uri.parse(
      'https://api-medmap.mandatech.co.id/v1/countries?page=1&limit=25'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body)['data'];
    return data.map((country) => Country.fromJson(country)).toList();
  } else {
    throw Exception('Failed to load countries');
  }
}

// Mendapatkan daftar kota berdasarkan ID negara
Future<List<City>> fetchCities(int countryId) async {
  final response = await http.get(Uri.parse(
      'https://api-medmap.mandatech.co.id/v1/countries/$countryId/states?page=1&limit=1000'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body)['data'];
    return data.map((city) => City.fromJson(city)).toList();
  } else {
    throw Exception('Failed to load cities');
  }
}

// void partnership() => runApp(CountryCityDropdown());

class CountryCityDropdown extends StatefulWidget {
  @override
  _CountryCityDropdownState createState() => _CountryCityDropdownState();
}

class _CountryCityDropdownState extends State<CountryCityDropdown> {
  List<Country> _countries = [];
  List<City> _cities = [];
  Country? _selectedCountry;
  City? _selectedCity;
  bool _isLoadingCountries = false;
  bool _isLoadingCities = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  void _loadCountries() async {
    setState(() {
      _isLoadingCountries = true;
      _error = null;
    });
    try {
      List<Country> countries = await fetchCountries();
      setState(() {
        _countries = countries;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoadingCountries = false;
      });
    }
  }

  void _loadCities(int countryId) async {
    setState(() {
      _isLoadingCities = true;
      _error = null;
    });
    try {
      List<City> cities = await fetchCities(countryId);
      setState(() {
        _cities = cities;
        _selectedCity = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoadingCities = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Select Country and City')),
        body: _isLoadingCountries
            ? Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : Column(
                    children: [
                      DropdownButton<Country>(
                        hint: Text('Select Country'),
                        value: _selectedCountry,
                        onChanged: (Country? newValue) {
                          setState(() {
                            _selectedCountry = newValue;
                            if (newValue != null) {
                              _loadCities(newValue.id);
                            }
                          });
                        },
                        items: _countries.map((Country country) {
                          return DropdownMenuItem<Country>(
                            value: country,
                            child: Text(country.name),
                          );
                        }).toList(),
                      ),
                      _isLoadingCities
                          ? Center(child: CircularProgressIndicator())
                          : DropdownButton<City>(
                              hint: Text('Select City'),
                              value: _selectedCity,
                              onChanged: (City? newValue) {
                                setState(() {
                                  _selectedCity = newValue;
                                });
                              },
                              items: _cities.map((City city) {
                                return DropdownMenuItem<City>(
                                  value: city,
                                  child: Text(city.name),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
      ),
    );
  }
}
