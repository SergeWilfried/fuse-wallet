import 'package:digitalrand/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:digitalrand/models/app_state.dart';
import 'package:digitalrand/models/views/backup.dart';
import 'package:digitalrand/screens/routes.gr.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class ColorsPincodeScreen extends StatefulWidget {
  @override
  _ColorsPincodeScreenState createState() => _ColorsPincodeScreenState();
}

class _ColorsPincodeScreenState extends State<ColorsPincodeScreen> {
  final pincodeController = TextEditingController(text: "");
  String lastPincode;
  bool isRetype = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future(() => false);
        },
        child: Scaffold(
            body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF2256B9), Color(0xFF0233A4)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .5,
                width: MediaQuery.of(context).size.height * .5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/images/digitalrand_logo.png',
                              width: 135, height: 21),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          I18n.of(context).enter_pincode,
                          style: TextStyle(
                            fontSize: 25,
                            color: Theme.of(context).splashColor,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Theme(
                            data: ThemeData(
                                hintColor:
                                    Theme.of(context).scaffoldBackgroundColor),
                            child: StoreConnector<AppState,
                                    LockScreenViewModel>(
                                converter: LockScreenViewModel.fromStore,
                                builder: (_, viewModel) => Container(
                                      width: 250,
                                      child: PinInputTextField(
                                          pinLength: 6,
                                          decoration: UnderlineDecoration(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .splashColor,
                                              ),
                                              hintTextStyle: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              color:
                                                  Theme.of(context).splashColor,
                                              enteredColor:
                                                  Theme.of(context).splashColor,
                                              obscureStyle: ObscureStyle(
                                                  isTextObscure: true,
                                                  obscureText: '●')),
                                          controller: pincodeController,
                                          autoFocus: true,
                                          textInputAction: TextInputAction.go,
                                          onChanged: (value) {
                                            if (value == viewModel.pincode) {
                                              Router.navigator
                                                  .pushNamedAndRemoveUntil(
                                                      Router.cashHomeScreen,
                                                      (Route<dynamic> route) =>
                                                          false);
                                            }
                                          }),
                                    )))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )));
  }
}
