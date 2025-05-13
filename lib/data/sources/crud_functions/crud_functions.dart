import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    print(data);
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
  uploadPatientAppointmentData(doctorData: docSnapshot.data() as Map<String, dynamic>, appointmentDate: formattedDate, appointmentTime: selectedTime);
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
    docRef.update({"id":docRef.id});
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
      // data['id'] = doc.id; // Attach document ID
      return data;
    }).toList();
    return doctors;
  } catch (e) {
    print('Error fetching doctors: $e');
    return [];
  }
}



Future<void> uploadPatientAppointmentData({
  required Map<String, dynamic> doctorData,
  required String appointmentDate,
  required String appointmentTime,
}) async {
  final CollectionReference appointmentCollection =
  FirebaseFirestore.instance.collection('patient-apt-data');
  final storage = FlutterSecureStorage();
  final String? userId = await storage.read(key: 'user_uid');

  if (userId == null) {
    print("User ID not found in SharedPreferences.");
    return;
  }

  // Query Firestore to check if document with ptid == userId exists
  QuerySnapshot querySnapshot = await appointmentCollection
      .where("ptid", isEqualTo: userId)
      .limit(1)
      .get();

  // Build the appointment data
  print(doctorData);
  Map<String, dynamic> newAppointment = {
    "id":doctorData["id"],
    "name": doctorData["name"],
    "experience": doctorData["experience"],
    "cost": doctorData["cost"],
    "image": doctorData["image"],
    "qualification": doctorData["qualification"],
    "status": doctorData["status"],
    "appointment_time": appointmentTime,
    "appointment_date": appointmentDate,
  };

  if (querySnapshot.docs.isNotEmpty) {
    // Document found — update the "apt" list
    DocumentReference existingDocRef = querySnapshot.docs.first.reference;

    await existingDocRef.update({
      "apt": FieldValue.arrayUnion([newAppointment])
    });

    print("Added new appointment to existing patient document.");
  } else {
    // No document — create new document with ptid and appointment
    await appointmentCollection.add({
      "ptid": userId,
      "Name": doctorData["patientName"], // Replace or remove as needed
      "apt": [newAppointment]
    });

    print("Created new patient document with appointment.");
  }
}



Future<Map<String, dynamic>?> getPatientAppointmentData() async {
  final CollectionReference appointmentCollection =
  FirebaseFirestore.instance.collection('patient-apt-data');

  final storage = FlutterSecureStorage();
  final String? userId = await storage.read(key: 'user_uid');

  if (userId == null) {
    print("User ID not found in SharedPreferences.");
    return null;
  }

  try {
    // Query documents where ptid matches the userId
    final QuerySnapshot querySnapshot = await appointmentCollection
        .where('ptid', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isEmpty) {
      print("No appointment data found for ptid: $userId");
      return null;
    }

    // Assuming only one document per ptid — return the first one
    final doc = querySnapshot.docs.first;
    final data = doc.data() as Map<String, dynamic>;

    return data; // You can access data['apt'], data['Name'], etc.
  } catch (e) {
    print("Error retrieving appointment data: $e");
    return null;
  }
}


Future<void> deleteAllDocumentsFromCollection(String collectionName) async {
  try {
    final collection = FirebaseFirestore.instance.collection(collectionName);
    final snapshot = await collection.get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    print('All documents deleted from $collectionName');
  } catch (e) {
    print('Error deleting documents from $collectionName: $e');
  }
}
