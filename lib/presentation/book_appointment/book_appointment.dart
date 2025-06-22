import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../data/sources/crud_functions/crud_functions.dart';

class BookAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> doctorData;

  const BookAppointmentPage({super.key, required this.doctorData});

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTime;

  List<Map<String, dynamic>> get _appointments => List<Map<String, dynamic>>.from(widget.doctorData['appointment']);
  List<Map<String, dynamic>> get _filledSlots => List<Map<String, dynamic>>.from(widget.doctorData['filled']);

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  List<String> getAvailableTimeSlots(DateTime date) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    print(formattedDate);
    return _appointments.map((slot) {
      String time = slot['time'];
      int total = slot['total_seat'];
      print("total $total time $time");
      int filled = _filledSlots
          .where((f) => f['date'] == formattedDate && f['time'] == time)
          .map((f) => f['seats'] as int)
          .fold(0, (a, b) => a + b);
      print("filled $filled");
      return filled >= total ? null : time;
    }).whereType<String>().toList();
  }

  void bookSlot() async {
    //updatethefilled data
    await updateFilledData(widget.doctorData['id'], _selectedDay!, _selectedTime!);


    Navigator.pop(context, widget.doctorData); // Return updated data
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF5F5F5);
    const Color cardColor = Colors.white;
    const Color primaryColor = Color(0xFF4285F4);
    const Color textColor = Colors.black87;
    const Color subtleGreyColor = Color(0xFFEEEEEE);

    List<String> availableSlots = _selectedDay != null ? getAvailableTimeSlots(_selectedDay!) : [];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Book Appointment",
          style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('MMMM yyyy').format(_focusedDay), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                              });
                            },
                            child: const Icon(Icons.chevron_left, size: 24),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                              });
                            },
                            child: const Icon(Icons.chevron_right, size: 24),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.utc(2030),
                    focusedDay: _focusedDay,
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                    headerVisible: false,
                    daysOfWeekHeight: 24,
                    rowHeight: 36,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _selectedTime = null; // Reset selection on new date
                      });
                    },
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: const TextStyle(color: textColor),
                      weekendTextStyle: const TextStyle(color: textColor),
                      selectedDecoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                      todayDecoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 1),
                      ),
                      todayTextStyle: const TextStyle(color: primaryColor),
                      outsideDaysVisible: true,
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(fontWeight: FontWeight.w500),
                      weekendStyle: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text("Select Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _appointments.length,
                itemBuilder: (context, index) {
                  final time = _appointments[index]['time'];
                  final isAvailable = availableSlots.contains(time);
                  final isSelected = _selectedTime == time;

                  return GestureDetector(
                    onTap: isAvailable
                        ? () {
                      setState(() {
                        _selectedTime = time;
                      });
                    }
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryColor
                            : isAvailable
                            ? subtleGreyColor
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        time,
                        style: TextStyle(
                          color: isAvailable ? (isSelected ? Colors.white : textColor) : Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: (_selectedDay != null && _selectedTime != null) ? bookSlot : null,
                child: const Text("Set appointment", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
