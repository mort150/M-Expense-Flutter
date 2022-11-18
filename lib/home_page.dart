import 'package:assignment/database/database.dart';
import 'package:assignment/database/trip.dart';
import 'package:assignment/editor.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  AppDB db;
  HomePage({super.key, required this.db});
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trip List',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: const [],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => Editor(db: widget.db))))
        },
      ),
      body: FutureBuilder<List<Trip>>(
        future: widget.db.tripDAO.getAllTrips(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              return ListView(
                  children: snapshot.data!
                      .map(
                        (Trip trip) => ListTile(
                          title: Text(
                            trip.name,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Destination: ${trip.destination} \nDate: ${trip.date}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          onTap: () => {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Trip details'),
                                    content: Text(
                                        'Name: ${trip.name}\n \nDestination: ${trip.destination}\n \nDate: ${trip.date}\n \nAssessment: ${trip.assessment}\n \nDescription: ${trip.description}\n \nExpected Cost: ${trip.expectedCost?.toDouble()}\n \nNumber of participants: ${trip.membersAmount?.toInt()}'),
                                  );
                                })
                          },
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          leading: const Icon(
                            Icons.article_outlined,
                            color: Colors.lightBlue,
                            size: 50.0,
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              size: 35.0,
                              color: Colors.greenAccent,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Editor(
                                          db: widget.db, tripId: trip.tripId)));
                            },
                          ),
                          contentPadding: const EdgeInsets.all(8.0),
                        ),
                      )
                      .toList());
            } else {
              return const Center(child: Text("There is no Trip available"));
            }
          } else if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }
}
