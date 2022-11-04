import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:location/location.dart';
import 'package:my_meds/utilities/current_location.dart';
import 'package:get/get.dart';

import '../../utilities/position_to_map.dart';

class ImportContact extends StatefulWidget {
  const ImportContact({super.key});

  @override
  State<ImportContact> createState() => _ImportContactState();
}

class _ImportContactState extends State<ImportContact> {
  String? Name;
  int? Number;
  String? NameLast;

late String message;
List<String> recipents = [];

  Stream<List<Contacts>> readContact() =>FirebaseFirestore
  .instance.collection('Contacts')
  .snapshots()
  .map((snapshot) =>
   snapshot.docs.map((doc)=> Contacts.fromJson(doc.data())).toList());

      Widget buildContacts(Contacts contact)=>Dismissible(

        key: Key('${contact.id}'),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          FirebaseFirestore.instance.collection('Contacts').doc(contact.id).delete();
        },
        background: Container(
            color: const Color(0xFF088F6F),
            child: const Icon(Icons.delete),
        ),

        child: ListTile(
        title: Text('${contact.name}'),
        subtitle: Text('${contact.number}'),
        
          ),
      );

  
  void currentLocation() async{         //To get Current Location
      LocationData? locationData = await getLocationData();
      message = 'Latitude: ${locationData?.latitude.toString()} Longitude: ${locationData?.longitude.toString()} Date-Time: ${DateTime.fromMillisecondsSinceEpoch(locationData?.time?.toDouble().round() as int).toString()} \n ${getMapLink((locationData?.latitude)!, (locationData?.longitude)!)}';
      _sendSMS(message, recipents);

   }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('${'Emergency contacts'.tr}')
      ),
      
      body: StreamBuilder<List<Contacts>>(
          stream: readContact(),
          builder: (context, snapshot){
              if (snapshot.hasError){
                return Text('ERROR ALERT! ${snapshot.error}}');
              } else if (snapshot.hasData){
                final contact = snapshot.data!; 
                recipents = [];          //Initilizing it to empty so that every tie result does not get appended  
                                          //Gives list of contact fetched from firebase ex: [Instance of 'Contacts', Instance of 'Contacts', 
                recipents.addAll(ExtractContactNumber(contact));      //Extract contact numbers to send to SMS 


                if (recipents.isEmpty){           //If no contacts
                   return const  Center(child: Text(
                        "No Contact",
                         style: TextStyle(
                         fontSize: 20.0, 
                          ),
                         ),
                      );
                }

                return ListView( children: contact.map(buildContacts).toList(),);
              }

             else{ return const Center(child: CircularProgressIndicator()); }
          },
      ),


      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
               currentLocation();
            },
            child: const Icon(
              Icons.sms,
            ),
            heroTag: null,
          ),
          const SizedBox(height: 10,),


      FloatingActionButton(
        onPressed: () async{
          final FullContact contact = await FlutterContactPicker.pickFullContact();

          setState(() {
            Name = contact.name?.firstName;
            NameLast = contact.name?.lastName;   // To display both first and last name 
            if (NameLast != null){
                Name = Name! + ' ' + NameLast!;
            }
            Number = int.parse(contact.phones[0].number.toString().replaceAll(new RegExp(r'[^0-9]'), ''));
            SaveContact(name: Name, number: Number);
          });
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.contact_phone),
          ),
        ],
      )

    );



  }
}


Future SaveContact({required String? name, required int? number }) async {
  
  final docContacts = FirebaseFirestore.instance.collection('Contacts').doc();
  final contact = Contacts(
    id: docContacts.id,
    name :  name,
    number: number,
  ); 

  final json = contact.toJson();
  await docContacts.set(json);
}

class Contacts{
String id;
final String? name;
final int? number;

Contacts({
  this.id = '',
  required this.name,
  required this.number,
});

Map<String, dynamic> toJson()=>{
  'id': id,
  'Phonename': name,
  'Phonenumber': number,
};

static Contacts fromJson(Map<String, dynamic> json) => Contacts(
  id:  json['id'],
  name:  json['Phonename'],
  number: json['Phonenumber']
);

}


void _sendSMS(String message, List<String> recipents) async{


  String sendResult = await sendSMS(message: message, recipients:  recipents)
   .catchError((err){
   });
  }

List<String> ExtractContactNumber(List<Contacts> contact){
List<String> Extractnumber=[];
for(int i=0;i<contact.length;i++){
  Extractnumber.add(contact[i].number.toString());
}
return Extractnumber;
}