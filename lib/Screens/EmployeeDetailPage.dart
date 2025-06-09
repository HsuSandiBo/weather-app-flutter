import 'package:flutter/material.dart';

class EmployeeDetailPage extends StatelessWidget {
  final Map<String, dynamic> employee;

  const EmployeeDetailPage({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              child: Image.asset(
                'assets/images/${employee['id']}.jpg',
                height: 200,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
              Text(
                employee['name'] ?? 'Unknown',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 8),
            Text(
              employee['position'] ?? '',
              style: const TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            infoRow(Icons.person, 'Secretary : ${employee['secretary'] ?? '_'}'),
            infoRow(Icons.email, 'Email : ${employee['email'] ?? '_'}'),
            infoRow(Icons.phone, 'Phone : ${employee['phone'] ?? '_'}'),
            infoRow(Icons.fax, 'Fax : ${employee['fax'] ?? '_'}'),
          ],
        ),
      ),
    );
  }

  Widget infoRow(IconData icon, String text) {
     return Padding(
       padding: const EdgeInsets.fromLTRB(100, 6, 0, 6),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Icon(icon, size: 20, color: Colors.black87),
           const SizedBox(width: 12),
           Expanded(
               child: Text(
                 text,
                 style: const TextStyle(fontSize: 16),
               ),
           ),
         ],
       ),
     );
  }
}
