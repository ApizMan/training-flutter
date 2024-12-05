import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teaching_flutter_crud/controllers/firestore_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // firestore
  final FirestoreService firestore = FirestoreService();

  final TextEditingController addField = TextEditingController();

  void openModel({String? docId, String? existingText}) {
    addField.text = existingText ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: addField,
          ),
          actions: [
            // Button
            TextButton(
              onPressed: () {
                // add data to database
                if (docId == null) {
                  firestore.store(addField.text);

                  // update the existing database
                } else {
                  firestore.update(docId, addField.text);
                }

                // clear the text controller
                addField.clear();

                // Close the Model
                Navigator.of(context).pop();
              },
              child: Text(docId == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('Dashboard'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: openModel,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.getDatabaseString(),
        builder: (context, snapshot) {
          // If we have data, we will get all the data from the docs inside the firestore
          if (snapshot.hasData) {
            List dataList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: dataList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // get each individually data
                DocumentSnapshot document = dataList[index];
                String docId = document.id;

                // get data from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                String dataText = data['data'];
                Timestamp timestamp = data['timestamp'];

                // display as a list tile
                return ListTile(
                  title: Text(dataText),
                  subtitle: Text(
                      '${timestamp.toDate().day}-${timestamp.toDate().month}-${timestamp.toDate().year}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          openModel(docId: docId, existingText: dataText);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => firestore.delete(docId),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );

            // If the data doesn't exist on the database
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
