import 'package:apex_task/core/res/text_stlye.dart';
import 'package:apex_task/features/authentication/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  static const String routeName = "/dashboard";
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = context.read<AuthViewModel>();
    var user = authViewModel.userModel!.data!.user!;
    return Scaffold(
       body: Center(child: Text("Welcome ${user.username!}",
       style: AppTextTheme.h1,)),
    );
  }
}
