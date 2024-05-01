import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_app/services/ehr/ehr_service.dart';

class EHRView extends StatelessWidget {
  final String patientID;

  EHRView({
    super.key,
    required this.patientID,
  });

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Record"),
      ),


      body: FutureBuilder<DocumentSnapshot>(
        future: _firestoreService.getDocumentById(patientID),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Center(child: Text("No data found"));
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          return _buildEHRItem(data);  
        },
      ),
    );
  }

  Widget _buildEHRItem(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: Column(
        children: [

          Text(
            "${data["firstName"]} ${data["lastName"]}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              )
          ),

          const SizedBox(height: 20),

          Text("Personal Information"),
          const SizedBox(height: 10),
          Table(
            children: [
              TableRow(children: [
                Text("First Name"),
                Text(data["firstName"])
              ]),
          
              TableRow(children: [
                Text("Last Name"),
                Text(data["lastName"])
              ]),
          
              TableRow(children: [
                Text("Preferred Name"),
                Text(data["preferredName"])
              ]),
          
              TableRow(children: [
                Text("Gender"),
                Text(data["gender"])
              ]),
          
              TableRow(children: [
                Text("Date of Birth"),
                Text("${data["dateOfBirth"]["day"]}/${data["dateOfBirth"]["month"]}/${data["dateOfBirth"]["year"]}")
              ]),
          
              TableRow(children: [
                Text("Blood Type"),
                Text(data["bloodType"])
              ]),
          
              TableRow(children: [
                Text("Last Updated"),
                Text("${data["lastUpdated"]["day"]}/${data["lastUpdated"]["month"]}/${data["lastUpdated"]["year"]}")
              ]),
          
              TableRow(children: [
                Text("Address"),
                Text(data["address"])
              ]),
          
              TableRow(children: [
                Text("City"),
                Text(data["city"])
              ]),
          
              TableRow(children: [
                Text("State"),
                Text(data["state"])
              ]),
          
              TableRow(children: [
                Text("Postal Code"),
                Text(data["postalCode"])
              ]),
            ]
          ),


          const SizedBox(height: 20), 


          Text("Emergency Contact"),
          const SizedBox(height: 10), 
          Table(
            children: [
              TableRow(children: [
                Text("First Name"),
                Text(data["emergencyContact"]["firstName"])
              ]),

              TableRow(children: [
                Text("Last Name"),
                Text(data["emergencyContact"]["lastName"])
              ]),

              TableRow(children: [
                Text("Relationship"),
                Text(data["emergencyContact"]["relationship"])
              ]),

              TableRow(children: [
                Text("Contact Number"),
                Text(data["emergencyContact"]["contactNumber"])
              ]),
            ]
          ),


          const SizedBox(height: 20), 


          Text("Insurance Information"),
          const SizedBox(height: 10), 
          Table(
            children: [
              TableRow(children: [
                Text("Insurance Carrier"),
                Text(data["insurance"]["carrier"])
              ]),

              TableRow(children: [
                Text("Insurance Plan"),
                Text(data["insurance"]["plan"])
              ]),

              TableRow(children: [
                Text("Contact Number"),
                Text(data["insurance"]["contactNumber"])
              ]),

              TableRow(children: [
                Text("Policy Number"),
                Text(data["insurance"]["policyNumber"])
              ]),
            ]
          ),

          
          const SizedBox(height: 20), 

          Text("Known Medical Conditions"),
          const SizedBox(height: 10), 
          Table(
            children: [
              TableRow(children: [
                Text("Myopic - wears glasses to correct his vision."),
              ]),
            ]
          ),

          const SizedBox(height: 20), 

          Text("Allergies"),
          const SizedBox(height: 10), 
          Table(
            children: [
              TableRow(children: [
                Text("Penicillin"),
              ]),
            ]
          ),



        





        ],
      )
      
      
      );
  }
}
