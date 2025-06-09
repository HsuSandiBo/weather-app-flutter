import 'package:assignment12_6509966_ict425/Screens/EmployeePage.dart';
import 'package:assignment12_6509966_ict425/Screens/SignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    if (_emailController.text == savedEmail &&
        _passwordController.text == savedPassword) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => EmployeePage()));
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Login Failed!'),
            content: const Text('Incorrect email or password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _emailController.clear();
                  _passwordController.clear();
                },
                child: const Text("OK"))
            ],
          )
      );
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
        )),
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
                Image.asset(
                  'assets/images/RSU_Logo.png',
                  height: 100,
                ),
                const SizedBox(height: 10),
                const Text(
                  'International College',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Information and Communication Technology Program',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),

                TextField(
                  controller: _emailController,
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
                const SizedBox(height: 20),

                TextButton(
                  onPressed: _login,
                  child: Text('Login'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white54,
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignUpPage()),
                    );
                  },
                  child: Text("Don't have an account? Sign Up"),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
