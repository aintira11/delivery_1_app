import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController NameNoCtl = TextEditingController();
  TextEditingController PasswordNoCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.rocket_launch,
                        size: 60,
                        color: Colors.black,
                      ),
                      Text(
                        'DELIVERY',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '- ROCKET DELIVERY -',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 252, 183, 64),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Name'),
                      const SizedBox(height: 5),
                      TextField(
                        controller: NameNoCtl,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(0, 255, 255, 255),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text('Password'),
                      const SizedBox(height: 5),
                      TextField(
                        controller: PasswordNoCtl,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(0, 255, 255, 255),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Login();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF702D),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)), // มุมไม่โค้ง
                            ),
                          ),
                          child: const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void Login() {

  }
}
