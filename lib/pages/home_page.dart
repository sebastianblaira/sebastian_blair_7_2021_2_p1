import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> results = [];

  @override
  void initState() {
    super.initState();
    _getApi();
  }

  Future _getApi() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {});
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    } else {
      // aqui va el https con el get
      var url = Uri.parse('https://api.doge-meme.lol/v1/memes');
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Accept": "application/json"
      };
      var response = await http.get(url, headers: headers);

      final decodeData = json.decode(response.body);

      print(decodeData);

      if (decodeData['data'] != null && decodeData['data'].length > 0) {
        for (var i = 0; i < decodeData['data'].length; i++) {
          final String image = decodeData['data'][i]['submission_url'];
          if (image.contains('jpg') ||
              image.contains('png') ||
              image.contains('gif')) {
            results.add(decodeData['data'][i]['submission_url']);
          }
        }
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de memes'),
      ),
      body: ListImage(results: results),
    );
  }
}

class ListImage extends StatelessWidget {
  final List<String> results;

  const ListImage({
    Key? key,
    required this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (_, i) {
          return Container(
            padding: const EdgeInsets.all(8),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/loading.gif',
              image: results[i],
              fit: BoxFit.cover,
              height: 200.0,
            ),
          );
        });
  }
}
