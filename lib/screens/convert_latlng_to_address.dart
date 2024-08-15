import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class ConvertLatlngToAddress extends StatefulWidget {
  const ConvertLatlngToAddress({super.key});

  @override
  State<ConvertLatlngToAddress> createState() => _ConvertLatlngToAddressState();
}

class _ConvertLatlngToAddressState extends State<ConvertLatlngToAddress> {
  String stAddress = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConvertLatlngToAddress'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(stAddress),
            GestureDetector(
              onTap: () async {
                List<Placemark> placemarks =
                    await placemarkFromCoordinates(24.966116, 66.983297);
                    setState(() {
                      stAddress =placemarks.last.subAdministrativeArea.toString();
                    });

              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: const Center(child: Text('Convert')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
