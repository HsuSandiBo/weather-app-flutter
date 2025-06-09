import 'package:assignment12_6509966_ict425/Screens/EmployeePage.dart';
import 'package:assignment12_6509966_ict425/Screens/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget{
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage>{
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _saveData() async {

    //Checking all fields filled or not
    if(_fullNameController.text.isEmpty ||
    _emailController.text.isEmpty ||
    _passwordController.text.isEmpty ||
    _confirmController.text.isEmpty ||
    _phoneController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error'),
            content: Text('Please fill all fields!!!'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
              ),
            ],
      ));
      return;
    }

    //Checking password match or not
    if(_passwordController.text != _confirmController.text) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Passwords do not match.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text('OK')),
          ],
        ),
    );
      return;
    }

    //Creating account confirm
    final confirm = await showDialog<bool> (
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirm Registration'),
        content: Text('Do you want to register your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No')
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes')
          ),
        ],
      ),
    );

    //Confirm account or not
    if(confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullName', _fullNameController.text);
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => EmployeePage()));
    } else {
      _fullNameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmController.clear();
      _phoneController.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Rangsit University',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset('assets/images/RSU_Logo.png', height: 80),
                const SizedBox(height: 10),
                const Text(
                  'Student\'s Registration',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 30),

                TextField(
                  controller: _fullNameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Full Name : ',
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'E-mail : ',
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password : ',
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                
                TextField(
                  controller: _confirmController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Confirm Password : ',
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.mobile_friendly),
                    labelText: 'Mobile Phone No. : ',
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                
                ElevatedButton(
                  onPressed: _saveData,
                  child: Text('Register'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}