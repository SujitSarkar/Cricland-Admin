import 'package:cricland_admin/constants/static_colors.dart';
import 'package:cricland_admin/repository/login/controller/login_controller.dart';
import 'package:cricland_admin/widgets/solid_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../constants/dynamic_size.dart';
import '../../../widgets/text_field_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(context: context),
      autoRemove: true,
      builder: (loginController) {
        return RawKeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKey: (event){
            if(event.isKeyPressed(LogicalKeyboardKey.enter)){
              _validateAndLogin(loginController);
            }
          },
          child: Scaffold(
            body:Stack(
              children: [
                Container(
                  height: Get.size.height,
                  width: Get.size.width,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/login_bg.jpg'),
                          fit: BoxFit.cover
                      )
                  ),
                ),

                Center(
                  child: Container(
                    height: Get.size.height*.55,
                    width: Get.size.height*.5,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/logo.png',height: Get.size.height*.1,),
                            Text('Cricland Admin',
                                style: TextStyle(fontFamily: 'openSans',
                                    fontSize: Get.size.height*.04,color:StaticColor.primaryColor,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: Get.size.height*.03),

                        ///Username
                        SizedBox(
                          width: Get.size.height*.35,
                          child: TextFieldWidget(
                            controller: loginController.username,
                            labelText: 'Username',
                          )
                        ),
                        SizedBox(height: Get.size.height*.03),

                        ///Password
                        SizedBox(
                          width: Get.size.height*.35,
                          child: TextFieldWidget(
                            controller: loginController.password,
                            labelText: 'Password',
                            obscure: true,
                          ),
                        ),
                        SizedBox(height: Get.size.height*.04),

                        Obx(() => loginController.loading.value
                            ? const CircularProgressIndicator()
                            : SolidButton(
                          onPressed: (){
                            _validateAndLogin(loginController);
                          },
                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text('Log In',
                                style: TextStyle(fontSize: Get.size.height*.022,
                                    fontFamily: 'openSans')),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  void _validateAndLogin(LoginController loginController)async{
    if(loginController.username.text.isNotEmpty){
      if(loginController.password.text.isNotEmpty){
        loginController.validateAdmin();
      }else {
        showToast('Enter Password');
      }
    }else {
      showToast('Enter Username');
    }
  }
}
