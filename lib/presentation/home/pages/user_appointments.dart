import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../main.dart';
import '../../auth/pages/signup_or_signin.dart';

class UserAppointmentsPage extends StatefulWidget {
  @override
  _UserAppointmentsPageState createState() => _UserAppointmentsPageState();
}

class _UserAppointmentsPageState extends State<UserAppointmentsPage> with RouteAware {
  List<Map<String, dynamic>> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointmentsFromFirestore();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    fetchAppointmentsFromFirestore();
  }

  Future<void> fetchAppointmentsFromFirestore() async {
    setState(() => isLoading = true);
    final storage = FlutterSecureStorage();
    final String? userId = await storage.read(key: 'user_uid');

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('patient-apt-data')
          .where('ptid', isEqualTo: userId)
          .get();

      final fetchedAppointments = snapshot.docs.expand((doc) {
        final data = doc.data();
        final apt = data['apt'];

        if (apt is List) {
          return apt
              .whereType<Map<String, dynamic>>()
              .map((item) => {
            ...item,
            'docId': doc.id,
          });
        } else {
          return <Map<String, dynamic>>[];
        }
      }).toList();

      setState(() {
        appointments = fetchedAppointments;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching appointments: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteAppointment({
    required String docId,
    required String appointmentId,
    required String appointmentTime,
    required String appointmentDate,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('patient-apt-data').doc(docId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final List<dynamic> aptList = data['apt'] ?? [];

        // Filter out the appointment by matching all three fields
        final updatedAptList = aptList.where((item) {
          return item is Map<String, dynamic> &&
              !(item['id'] == appointmentId &&
                  item['appointment_time'] == appointmentTime &&
                  item['appointment_date'] == appointmentDate);
        }).toList();

        await docRef.update({'apt': updatedAptList});
        await fetchAppointmentsFromFirestore(); // Refresh the UI
      }
    } catch (e) {
      print('Error deleting appointment: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      drawer: Drawer(
        elevation: 0,
        child: ListView(
          children: [
            ListTile(
              title: const Text('Log Out'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupOrSignInPage()),
                );
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Your Appointments',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : appointments.isEmpty
          ? Center(child: Text("No Appointments Found"))
          : ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          print(appointment);
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      appointment['image'] ?? '',
                      width: 80,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 65,
                          height: 65,
                          color: Colors.grey[300],
                          child: Icon(Icons.person, color: Colors.grey[500]),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment['name'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          appointment['experience'] ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          appointment['qualification'] ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Date: ${appointment['appointment_date'] ?? ''}",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Time: ${appointment['appointment_time'] ?? ''}",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[800],
                          ),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: 130,
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () {
                              if (appointment['docId'] != null) {
                                deleteAppointment(docId:  appointment['docId'],appointmentId:  appointment["id"],appointmentTime: appointment['appointment_time'],appointmentDate:appointment['appointment_date'] );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Delete Appointment',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
