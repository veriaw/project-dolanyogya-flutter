import 'package:flutter/material.dart';
import 'package:project_tpm/models/user.dart';
import 'package:project_tpm/screens/Login.dart';
import 'package:project_tpm/services/user_service.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

bool isRegisterSuccess = true;

class _RegisterPageState extends State<RegisterPage> {
  final userService = UserService();
  String username = "";
  String password = "";
  String? gender;
  DateTime? dateOfBirth;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        appBar: AppBar(
          title: Text("Register Page"),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/logo.png", width: 200, height: 200, fit: BoxFit.scaleDown),
              _usernameField(),
              _passwordField(),
              _genderField(),
              _dateOfBirthField(context),
              _loginButton(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already Have an Account?"),
                  SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text("Login"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _usernameField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        onChanged: (value) {
          username = value;
        },
        decoration: InputDecoration(
          hintText: "Username",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: isRegisterSuccess ? Colors.green : Colors.red),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        obscureText: true,
        onChanged: (value) {
          password = value;
        },
        decoration: InputDecoration(
          hintText: "Password",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: isRegisterSuccess ? Colors.green : Colors.red),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _genderField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Gender"),
          Row(
            children: [
              Radio<String>(
                value: "Male",
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),
              Text("Male"),
              Radio<String>(
                value: "Female",
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),
              Text("Female"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateOfBirthField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: dateOfBirth ?? DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              dateOfBirth = pickedDate;
            });
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: isRegisterSuccess ? Colors.green : Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateOfBirth == null
                    ? "Select Date of Birth"
                    : "${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}",
                style: TextStyle(fontSize: 16),
              ),
              Icon(Icons.calendar_today),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: (isRegisterSuccess) ? Colors.green : Colors.red,
          minimumSize: Size(double.infinity, 50),
        ),
        onPressed: () async {
          String text = "";
          final newUser = User(
            username: username,
            password: password,
            gender: gender,
            dateOfBirth: dateOfBirth,
          );
          final success = await userService.addUser(newUser);

          if (success) {
            setState(() {
              text = "Register success!";
              isRegisterSuccess = true;
            });
          } else {
            setState(() {
              text = "Register failed!";
              isRegisterSuccess = false;
            });
          }

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

          if (isRegisterSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        },
        child: Text("Register"),
      ),
    );
  }
}