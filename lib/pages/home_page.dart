import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:memes_app/models/meme_model.dart';
import 'package:memes_app/pages/detail_meme_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Meme> results = [];

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
      var url =
          Uri.parse('https://api.doge-meme.lol/v1/memes/?skip=0&limit=100');
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Accept": "application/json"
      };
      var response = await http.get(url, headers: headers);

      final decodeData = json.decode(response.body);

      if (decodeData['data'] != null && decodeData['data'].length > 0) {
        for (var i = 0; i < decodeData['data'].length; i++) {
          var image = decodeData['data'][i]['submission_url'];
          if (image.contains('jpg') ||
              image.contains('png') ||
              image.contains('gif')) {
            results.add(Meme.fromJson(decodeData['data'][i]));
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
        backgroundColor: Colors.black,
        title: Center(
          child: Text('Listado de Memes',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
      body: ListImage(results: results),
    );
  }
}

class ListImage extends StatelessWidget {
  final List<Meme> results;

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
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailsMemePage(meme: results[i])));
                    },
                    child: Container(
                      width: double.infinity,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/loading.gif',
                        image: results[i].submissionUrl,
                        fit: BoxFit.cover,
                        height: 200.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    results[i].submissionTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ));
        });
  }
}
