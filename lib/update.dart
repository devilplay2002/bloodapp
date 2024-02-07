import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateDonor extends StatefulWidget {
  const UpdateDonor({super.key});

  @override
  State<UpdateDonor> createState() => _UpdateDonorState();
}

class _UpdateDonorState extends State<UpdateDonor> {

  TextEditingController donorName = TextEditingController();
  TextEditingController donorPhone = TextEditingController();

  final  bloodGroups =['A+','A-','B+','B-','O+','O-','AB+','AB-'];

  final CollectionReference donor =
  FirebaseFirestore.instance.collection('donor');


  void updateDonor(docId){
    final data = {
      'name':donorName.text,
      'phone':donorPhone.text,
      'group':selectedGroup,
    };
    donor.doc(docId).update(data).then((value) => Navigator.pop(context));
  }



  String ?selectedGroup;
  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map;

    donorName.text = args['name'];
    donorPhone.text = args['phone'];
    selectedGroup = args['group'];

    final docId = args['id'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Donors'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children:  [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: donorName,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Donor Name')
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: donorPhone,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Phone No')
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                  value: selectedGroup,
                  decoration: const InputDecoration(
                      label: Text('Select Blood group')
                  ),
                  items:
                  bloodGroups.map((e) =>
                      DropdownMenuItem(value: e,child: Text(e),
                      )).toList(),
                  onChanged: (val){
                    selectedGroup =val as String?;
                  }),
            ),
            ElevatedButton(onPressed: (){
              updateDonor(docId);
            },
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 50)),
                  backgroundColor: MaterialStateProperty.all(Colors.red)
              ),
              child:  const Text('Update',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}