import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final CollectionReference donor =
  FirebaseFirestore.instance.collection('donor');

  void deleteDonor(docId){
    donor.doc(docId).delete();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Donation App'),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add,
          color: Colors.red,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: StreamBuilder(
        stream: donor.orderBy('group').snapshots(),
        builder: (context,AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot donorsnap = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              spreadRadius: 15
                          )
                        ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 30,
                              child: Text(donorsnap['group'],
                                style: const TextStyle(
                                    fontSize: 25
                                ),),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(donorsnap['name'],style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                            Text(donorsnap['phone'].toString(),style: const TextStyle(fontSize: 25),),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: (){
                                Navigator.pushNamed(context, '/update',
                                    arguments: {
                                      'name':donorsnap['name'],
                                      'phone':donorsnap['phone'].toString(),
                                      'group':donorsnap['group'],
                                      'id': donorsnap.id,
                                    }
                                );

                              },
                              icon: const Icon(Icons.edit),
                              iconSize: 30,
                              color: Colors.blue,
                            ),
                            IconButton(
                              onPressed: (){
                                deleteDonor(donorsnap.id);
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              iconSize: 30,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },);
          }
          return Container();
        },
      ),
    );
  }
}