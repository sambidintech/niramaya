import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
Future<void> updateFilledData(String doctorId, DateTime selectedDay, String selectedTime) async {
  final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
  final CollectionReference doctorCollection = FirebaseFirestore.instance.collection('doctor-data');

  final DocumentReference doctorDocRef = doctorCollection.doc(doctorId);
  final DocumentSnapshot docSnapshot = await doctorDocRef.get();
  int maxSeats=0;
  if (docSnapshot.exists) {
    final Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    List<dynamic> filled = data['filled'] ?? [];
    final matchingAppointment = data['appointment'].firstWhere(
          (slot) => slot['time'] == selectedTime,
      orElse: () => null,
    );
    if (matchingAppointment != null) {
       maxSeats = matchingAppointment['total_seat'] ?? 0;}


    bool isUpdated = false;

    // Try to find matching date + time
    for (var entry in filled) {
      if (entry['date'] == formattedDate && entry['time'] == selectedTime) {
        if(entry['seats']<maxSeats){
        entry['seats'] = (entry['seats'] ?? 0) + 1;
        isUpdated = true;}
        else{
          isUpdated=true;
        }
        break;
      }
    }

    if (!isUpdated) {
      filled.add({
        'date': formattedDate,
        'time': selectedTime,
        'seats': 1,
      });
    }

    await doctorDocRef.update({'filled': filled});
  }
}




Future<void> uploadDoctorsAndExportJson() async {
  final CollectionReference doctorCollection = FirebaseFirestore.instance.collection('doctor-data');

  // Load JSON from assets
  final String jsonString = await rootBundle.loadString('assets/doctors.json');
  final List<dynamic> doctorList = jsonDecode(jsonString);

  List<Map<String, dynamic>> updatedDoctors = [];

  for (var doctor in doctorList) {
    doctor.remove('rating'); // Skip rating
    DocumentReference docRef = await doctorCollection.add(doctor);
    doctor['id'] = docRef.id;
    updatedDoctors.add(Map<String, dynamic>.from(doctor));
  }

  // Convert updated list to JSON
  final String updatedJsonString = jsonEncode(updatedDoctors);

  // Get the local documents directory
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/updated_doctor_data.json');

  // Write the file
  await file.writeAsString(updatedJsonString);

  print('✅ JSON file saved at: ${file.path}');
}



Future<List<Map<String, dynamic>>> getDoctors() async {
  final CollectionReference doctorCollection = FirebaseFirestore.instance.collection('doctor-data');

  try {
    QuerySnapshot snapshot = await doctorCollection.get();
    List<Map<String, dynamic>> doctors = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Attach document ID
      return data;
    }).toList();
    return doctors;
  } catch (e) {
    print('Error fetching doctors: $e');
    return [];
  }
}


