import 'dart:convert';
import 'package:assignment12_6509966_ict425/Screens/EmployeeDetailPage.dart';
import 'package:assignment12_6509966_ict425/Screens/LoginPage.dart';
import 'package:assignment12_6509966_ict425/Screens/WeatherPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<StatefulWidget> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  List<Map<String, dynamic>> employees = [];
  String fullName = "";

  @override
  void initState() {
    super.initState();
    loadEmployeeData();
    loadUserFullName();
  }

  Future<void> loadEmployeeData() async {
    final String response =
    await rootBundle.loadString('assets/data/employees.json');
    final Map<String, dynamic> data = json.decode(response);
    setState(() {
      employees = data.entries.map((e) {
        final emp = e.value as Map<String, dynamic>;
        emp['id'] = e.key;
        return emp;
      }).toList();
    });
  }

  Future<void> loadUserFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName') ?? 'Unknown';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent.shade100,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.purpleAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Image.asset("assets/images/RSU_Logo.png", height: 60),
                  const SizedBox(height: 10),
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Employees'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud),
              title: const Text('Weather'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WeatherPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Exit'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LoginPage()));
              },
            ),
          ],
        ),
      ),
      body: employees.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final emp = employees[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              height: 180, 
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      'assets/images/${emp['id']}.jpg',
                      width: 150,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            emp['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            emp['position'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmployeeDetailPage(employee: emp),
                          ),
                        );
                      },
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