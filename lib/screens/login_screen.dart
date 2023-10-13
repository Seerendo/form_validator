import 'package:flutter/material.dart';
import 'package:form_validator/providers/login_form_provider.dart';
import 'package:provider/provider.dart';
import 'package:form_validator/ui/input_decorations.dart';
import 'package:form_validator/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 200,
            ),
            CardContainer(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ChangeNotifierProvider(
                    create: (context) => LoginFormProvider(),
                    child: _LoginForm(),
                  ),                  
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Crear una nueva cuenta',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    ));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      // TODO: mantener la referencia al KEY
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            //InputDecoration llamada mediante clase
            decoration: InputDecorations.authInputDecoration(
              hintText: 'john.doe@gmail.com',
              labelText: 'Correo electrónico',
              prefixIcon: Icons.alternate_email_rounded
            ),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp  = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                ? null : 'El valor ingresado no luce como un correo';
            },
          ),
          const SizedBox(height: 30,),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            //InputDecoration llamada mediante clase
            decoration: InputDecorations.authInputDecoration(
              hintText: '*****',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline
            ),
            onChanged: (value) => loginForm.password,
            validator: (value) {
              return value != null && value.length >= 6
              ? null
              : 'La contraseña debe de ser de 6 caracteres';
            },
          ),
          const SizedBox(height: 30,),

          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 80,
                vertical: 15
              ),
              child: Text(
                loginForm.isLoading
                ? 'Espere'
                : 'Ingresar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            onPressed: loginForm.isLoading? null : () async {
              // Para quitar el teclado
              FocusScope.of(context).unfocus();

              if(!loginForm.isValidForm()) return;

              loginForm.isLoading = true;

              await Future.delayed(const Duration(seconds: 2));
              // TODO: Validar si el loading es correcto
              loginForm.isLoading = false;
              // TODO: Build Context Synchronously
              if (context.mounted) Navigator.pushReplacementNamed(context, 'home');
            },
          )
        ],
      ),
    );
  }
}
