import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  final TextEditingController _searchController = TextEditingController();

  var uuid = const Uuid();
  String _sessionToken = "1234";
  List<dynamic> _placeList = [];

  void getSuggestion(String input) async {
    String kplacesApiKey = 'AIzaSyAFgJ78ocoHkT-c1-qtP8WhQ0SgRPTEZHE';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kplacesApiKey&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _placeList = jsonDecode(response.body.toString())["predictions"];
      });
    } else {
      Exception("Failed to load Data");
    }
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    } else {
      getSuggestion(_searchController.text);
    }
  }

  @override
  void initState() {
   
    super.initState();
    _searchController.addListener(() {
      onChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seach Location"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: "Search Location",
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    List<Location> locations = await locationFromAddress(
                        _placeList[index]['description']);

                    print(locations.last.latitude);
                    print(locations.last.longitude);
                  },
                  child: ListTile(
                    title: Text(_placeList[index]['description']),
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
