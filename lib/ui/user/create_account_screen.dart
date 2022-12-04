import 'package:flutter/material.dart';

import '../../design_system/foli_sizes.dart';
import '../../design_system/foli_styles.dart';
import '../../utils/text_form_field_validator.dart';
import '../../web/resource/new_user_resource.dart';
import '../../web/service/dio_impl/dio_factory.dart';
import '../../web/service/dio_impl/dio_user_service.dart';
import '../../web/service/user_service.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final UserService _userService = DioUserService(
      DioFactory.addRefreshTokenInterceptors(DioFactory.createDioForUser()));

  String _name = "";
  String _email = "";
  String _password = "";

  bool _isPasswordHidden = true;

  void setName(String name) {
    setState(() {
      _name = name;
    });
  }

  void setEmail(String email) {
    setState(() {
      _email = email;
    });
  }

  void setPassword(String password) {
    setState(() {
      _password = password;
    });
  }

  void changePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  void saveNewUser(BuildContext context) {
    NewUserResource newUserResource = NewUserResource(
      name: _name,
      email: _email,
      password: _password,
    );

    _userService
        .postNewUser(newUserResource)
        .then((createdUser) => {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Usuário ${createdUser?.name}  foi criado com sucesso!'),
                ),
              ),
              Navigator.pushNamed(context, '/login'),
            })
        .onError((error, stackTrace) => {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Algo deu errado!')),
              )
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crie sua conta"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  validator: TextFormFieldValidator.nameValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: setName,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                TextFormField(
                  validator: TextFormFieldValidator.emailValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: setEmail,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                TextFormField(
                  validator: TextFormFieldValidator.passwordValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: _isPasswordHidden,
                  onChanged: setPassword,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: changePasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32.0,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      width: screenWidthPercentage(context, percentage: 60),
                      height: 48),
                  child: ElevatedButton(
                    child: const Text(
                      "Criar conta",
                      style: foliSubheadingStyle,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        saveNewUser(context);
                      }
                    },
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
