import 'package:Tether/store/auth/actions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Store
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:Tether/store/index.dart';

// Styling
import 'package:Tether/global/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Tether/global/dimensions.dart';

class PasswordStep extends StatefulWidget {
  const PasswordStep({Key key}) : super(key: key);

  PasswordStepState createState() => PasswordStepState();
}

class PasswordStepState extends State<PasswordStep> {
  PasswordStepState({Key key});

  bool visibility = false;
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmFocusNode = FocusNode();

  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _Props>(
        distinct: true,
        converter: (Store<AppState> store) => _Props.mapStoreToProps(store),
        builder: (context, props) {
          double width = MediaQuery.of(context).size.width;

          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: Container(
                    width: width * 0.65,
                    padding: EdgeInsets.only(bottom: 8),
                    constraints: BoxConstraints(
                      maxHeight: Dimensions.mediaSizeMax,
                      maxWidth: Dimensions.mediaSizeMax,
                    ),
                    child: SvgPicture.asset(
                      Assets.heroSignupPassword,
                      semanticsLabel:
                          'User thinking up a password in a swirl of wind',
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 8, top: 8),
                        child: Text(
                          'Come up with 4 random words\nyou\'ll easily remember',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Create a password',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    width: width * 0.8,
                    height: Dimensions.inputHeight,
                    constraints: BoxConstraints(
                      minWidth: Dimensions.inputWidthMin,
                      maxWidth: Dimensions.inputWidthMax,
                    ),
                    child: TextField(
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      obscureText: !visibility,
                      onChanged: (text) {
                        props.onChangePassword(text);
                      },
                      onSubmitted: (String value) {
                        FocusScope.of(context).requestFocus(confirmFocusNode);
                      },
                      onEditingComplete: () {
                        props.onChangePassword(props.password);
                        passwordFocusNode.unfocus();
                      },
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            if (!passwordFocusNode.hasFocus) {
                              // Unfocus all focus nodes
                              passwordFocusNode.unfocus();

                              // Disable text field's focus node request
                              passwordFocusNode.canRequestFocus = false;
                            }

                            // Do your stuff
                            this.setState(() {
                              visibility = !this.visibility;
                            });

                            if (!passwordFocusNode.hasFocus) {
                              //Enable the text field's focus node request after some delay
                              Future.delayed(Duration(milliseconds: 100), () {
                                passwordFocusNode.canRequestFocus = true;
                              });
                            }
                          },
                          child: Icon(
                            visibility
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: props.isPasswordValid
                              ? BorderSide(
                                  color: Theme.of(context).primaryColor,
                                )
                              : BorderSide(),
                          borderRadius: BorderRadius.circular(34.0),
                        ),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(
                  vertical: 8,
                )),
                Flexible(
                  flex: 1,
                  child: Container(
                    width: width * 0.8,
                    height: Dimensions.inputHeight,
                    constraints: BoxConstraints(
                      minWidth: Dimensions.inputWidthMin,
                      maxWidth: Dimensions.inputWidthMax,
                    ),
                    child: TextField(
                      controller: confirmController,
                      focusNode: confirmFocusNode,
                      obscureText: true,
                      onChanged: (text) {
                        props.onChangePasswordConfirm(text);
                      },
                      onEditingComplete: () {
                        props.onChangePasswordConfirm(props.password);
                        confirmFocusNode.unfocus();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(34.0),
                        ),
                        labelText: 'Confirm Password',
                        suffixIcon: Visibility(
                          visible: props.isPasswordValid,
                          child: Container(
                            width: 12,
                            height: 12,
                            margin: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Container(
                              padding: EdgeInsets.all((6)),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
}

class _Props extends Equatable {
  final String password;
  final String passwordConfirm;
  final bool isPasswordValid;

  final Function onChangePassword;
  final Function onChangePasswordConfirm;

  _Props({
    @required this.password,
    @required this.passwordConfirm,
    @required this.isPasswordValid,
    @required this.onChangePassword,
    @required this.onChangePasswordConfirm,
  });

  static _Props mapStoreToProps(Store<AppState> store) => _Props(
        password: store.state.authStore.password,
        passwordConfirm: store.state.authStore.passwordConfirm,
        isPasswordValid: store.state.authStore.isPasswordValid,
        onChangePassword: (String text) {
          store.dispatch(setPassword(password: text));
        },
        onChangePasswordConfirm: (String text) {
          store.dispatch(setPasswordConfirm(password: text));
        },
      );

  @override
  List<Object> get props => [
        password,
        passwordConfirm,
        isPasswordValid,
      ];
}
