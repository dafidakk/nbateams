import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nbateams/model.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<Teams> _teams = [];

  // get teams

  Future getTeams() async {
    var response = await http.get(Uri.https('balldontlie.io', 'api/v1/teams'));

    var jsonData = jsonDecode(response.body);

    for (var eachTeam in jsonData['data']) {
      final team = Teams(
        abbreviation: eachTeam['abbreviation'],
        city: eachTeam['city'],
      );

      _teams.add(team);
    }

    print(_teams.length);
  }

  @override
  Widget build(BuildContext context) {
    getTeams();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('NBA API TUTORIAL'),
      ),
      body: FutureBuilder(
        future: getTeams(),
        builder: (context, snapshot) {
          // is it done loading? then show team data
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: _teams.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: ListTile(
                      title: Text(_teams[index].abbreviation),
                      subtitle: Text(_teams[index].city),
                    ),
                  ),
                );
              },
            );
          }
          // if it's still loading, show loading circle
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
