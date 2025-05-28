import 'package:flutter/material.dart';
import 'package:project_tpm/screens/MainMenu.dart';
import 'package:project_tpm/screens/register.dart';
import 'package:project_tpm/services/user_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool isLoginSuccess = true;

class _LoginPageState extends State<LoginPage> {
  final userService = UserService();
  String username = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        appBar: AppBar(
          title: Text("Login Page"),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
          children: [
            Container(
              child: Image.asset("assets/logo.png", width: 200,height: 200, fit: BoxFit.scaleDown),
            ),
          _usernameField(), 
          _passwordField(), 
          _loginButton(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Text("Doesnt Have an Account?"),
                SizedBox(width: 8),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue
                    ),
                    onPressed: ()=>{
                        Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                        ),
                        )
                    }, 
                    child: Text("Register")
                )
            ],
          )
          ],
          ),
        ),
      ),
    );
  }

  Widget _usernameField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        enabled: true,
        onChanged: (value) {
          username = value;
        },
        decoration: InputDecoration(
          hintText: "Username",
          contentPadding: EdgeInsets.all(8.0),
          enabledBorder:OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: (isLoginSuccess)? Colors.green : Colors.red),
          ), 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.green),
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        enabled: true,
        onChanged: (value) {
          password = value;
        },
        decoration: InputDecoration(
          hintText: "Password",
          contentPadding: EdgeInsets.all(8.0),
           enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: (isLoginSuccess) ? Colors.green : Colors.red,
            ),
          ), 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: (isLoginSuccess) ? Colors.green : Colors.red
        ),
        onPressed: () async {
          String text = "";

          final data = await userService.login(username, password);

          if (data) {
            setState(() {
              text = "Login success!";
              isLoginSuccess = true;
            });
          } else {
           setState(() {
              text = "Username atau Password Salah!";
              isLoginSuccess = false;
           });
          }
          SnackBar snackBar = SnackBar(content: Text(text));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          if(isLoginSuccess==true){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainMenu(),
              ),
            );
          }
        },
        child: Text("Login"),
      ),
    );
  }
}