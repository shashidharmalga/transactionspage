import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:transaction/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
   final TextEditingController _emailController=TextEditingController();
   final TextEditingController _passwordController=TextEditingController();

   final supabase=Supabase.instance.client;

  void signUp() async {
    try{
      final res = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim()
      );

      if (res.user != null){
        Navigator.pushReplacement(
          context,
        MaterialPageRoute(builder: (context)=> LoginScreen())
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Confirmation email sent ! Please check"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signup failed. Try again."),
          ));
      }
    } catch(e){
      
      
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error : ${e.toString}"),
          ));
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register page"),
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
            ),
           
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.indigo),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  onPressed: () {
                    
                    signUp();
                   
                  },
                  child: Text("Submit"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}