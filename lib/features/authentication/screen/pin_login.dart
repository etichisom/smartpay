
import 'package:apex_task/core/constant/size.dart';
import 'package:apex_task/core/constant/strings.dart';
import 'package:apex_task/core/res/color.dart';
import 'package:apex_task/core/res/text_stlye.dart';
import 'package:apex_task/data/local_storage/auth_storage.dart';
import 'package:apex_task/features/authentication/screen/all_set.dart';
import 'package:apex_task/features/authentication/screen/create_account.dart';
import 'package:apex_task/features/authentication/screen/login.dart';
import 'package:apex_task/features/authentication/view_model/auth_view_model.dart';
import 'package:apex_task/features/dashboard/screens/home.dart';
import 'package:apex_task/widget/custom_appbar.dart';
import 'package:apex_task/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:provider/provider.dart';


// ignore: must_be_immutable
class PinLogin extends StatefulWidget {

  static const String routeName = "/PinLogin";
  const PinLogin({Key? key}) : super(key: key);

  @override
  State<PinLogin> createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<PinLogin> {

  String code ='';
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var user = AuthStorage.getUser();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: const CustomAppbar(),
        body: Padding(
          padding:  EdgeInsets.only(
              left: kAppPadding,
              right: kAppPadding,
              top: 20.h
          ),
          child: SingleChildScrollView(
            physics:const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome back ${user!.data!.user!.username!}",
                  style: AppTextTheme.h1,),
                SizedBox(height: 12.h,),
                Text(Strings.pinLogin,
                  style:AppTextTheme.light.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      color: AppColor.grey2) ,),
                SizedBox(height: 32.h,),
                OtpPinField(
                  fieldHeight: 56,
                  fieldWidth: size.width*0.143,
                  maxLength: 5,
                  onSubmit: (e){
                    //setPin(e, context);
                  },
                  onChange: (e){
                    setState(() {
                      code=e;
                    });

                  },
                  otpPinFieldStyle: OtpPinFieldStyle(
                      textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600
                      ),
                      activeFieldBorderColor:AppColor.primaryColor, //,
                      defaultFieldBackgroundColor: AppColor.whiteGrey,
                      defaultFieldBorderColor: AppColor.green,
                      fieldBorderRadius: 0,
                      fieldBorderWidth: 12
                  ),
                  otpPinFieldDecoration: OtpPinFieldDecoration.underlinedPinBoxDecoration,
                ),
                SizedBox(height:67.h ,),
                code.length!=5?
                const CustomButton(
                    text:Strings.signIn,
                    onPressed: null
                )
                    :CustomButton(
                    text:Strings.createPin,
                    onPressed: (){
                      setPin(code,context);
                    }
                ),
                SizedBox(height:40.h ,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push(Login.routeName);
                      },
                      child: RichText(
                        text:  TextSpan(
                            text: "Not you? ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: AppColor.grey),
                            children: [
                              TextSpan(
                                text:"switch account" ,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                    color: AppColor.solidGreen
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
                SizedBox(height:size.height*0.1 ,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push(CreateAccount.routeName);
                      },
                      child: RichText(
                        text:  TextSpan(
                            text: Strings.doNotHaveAccount,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: AppColor.grey),
                            children: [
                              TextSpan(
                                text: Strings.signUp,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                    color: AppColor.solidGreen
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setPin(String e,BuildContext context) {
    AuthViewModel authViewModel = context.read<AuthViewModel>();
    if(e.length==5){
      ///checking if the pin the user inputted  is correct, if it is correct the user is logged in on the app
      authViewModel.pinLogin(e).then((value){
        if(value!=null){
          context.go(Dashboard.routeName);
          //Navigator.pushReplacementNamed(context,Dashboard.routeName);
        }
      });
    }else{
      Fluttertoast.showToast(msg: "Enter a valid pin");
    }
  }
}
