import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medkit/animations/fadeAnimation.dart';
import 'package:medkit/animations/bottomAnimation.dart';
import 'package:medkit/doctor/doctorPanel.dart';
import 'package:medkit/otherWidgetsAndScreen/backBtnAndImage.dart';
import 'package:toast/toast.dart';

class DoctorLogin extends StatefulWidget {
  @override
  _DoctorLoginState createState() => _DoctorLoginState();
}

final _controllerName = TextEditingController();
final _controllerPassword = TextEditingController();

class _DoctorLoginState extends State<DoctorLogin> {

  bool validateCNICVar = false;
  bool validateName = false;


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> _signIn(BuildContext context, String email, String password) async {
    final AuthCredential credential = EmailAuthProvider.getCredential(email: email, password: password);

    FirebaseUser userDetails =
        await _firebaseAuth.signInWithCredential(credential);
    ProviderDoctorDetails providerInfo =
        new ProviderDoctorDetails(userDetails.providerId);

    List<ProviderDoctorDetails> providerData =
        new List<ProviderDoctorDetails>();
    providerData.add(providerInfo);

    DoctorDetails details = new DoctorDetails(
      userDetails.providerId,
      userDetails.displayName ?? "Petre",
      userDetails.photoUrl,// ?? "https://i.picsum.photos/id/532/200/300.jpg?hmac=77wsdhKY-O9QmZj8Fmkuc_h3fj6nJXCxQcXCRhX4Vos",
      userDetails.email,
      providerData,
    );

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => DoctorPanel(
                  detailsUser: details,
                )));

    return userDetails;
  }

  controllerClear(){
    _controllerName.clear();
    _controllerPassword.clear();
  }

  validateCNIC(String password) {
    if(password.isEmpty) {
      return "Please add password";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final nameTextField = TextField(
      keyboardType: TextInputType.text,
      autofocus: false,
      maxLength: 50,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      controller: _controllerName,
      decoration: InputDecoration(
          fillColor: Colors.black.withOpacity(0.07),
          filled: true,
          labelText: 'Enter email',
          prefixIcon: WidgetAnimator(Icon(Icons.person)),
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(20)))),
    );

    final passTextField = TextField(
      keyboardType: TextInputType.number,
      autofocus: false,
      maxLength: 20,
      controller: _controllerPassword,
      obscureText: true,
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
          filled: true,
          errorText: validateCNIC(_controllerPassword.text),
          fillColor: Colors.black.withOpacity(0.07),
          labelText: 'Password',
          prefixIcon: WidgetAnimator(Icon(Icons.password)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    );

    getInfoAndLogin() {
      // Firestore.instance
      //     .collection('doctorInfo')
      //     .document(_controllerName.text)
      //     .setData({
      //   'cnic': _controllerPassword.text,
      // });
      _signIn(context, _controllerName.text.trim(), _controllerPassword.text.trim())
          .then((FirebaseUser user) =>
          print('User Logged In'))
          .catchError((e) => print(e));
      controllerClear();
    }

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
              width: width,
              height: height,
              child: Stack(
                children: <Widget>[
                  BackBtn(),
                  ImageAvatar(
                    assetImage: 'assets/bigDoc.png',
                  ),
                  Container(
                    width: width,
                    height: height,
                    margin:
                        EdgeInsets.fromLTRB(width * 0.03, 0, width * 0.03, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          height: height * 0.05,
                        ),
                        Text(
                          "\t\tLogin",
                          style: GoogleFonts.abel(
                              fontSize: height * 0.044,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        nameTextField,
                        //phoneTextField,
                        passTextField,
                        SizedBox(
                          height: height * 0.01,
                        ),
                        SizedBox(
                          width: width,
                          height: height * 0.07,
                          child: RaisedButton(
                            color: Colors.white,
                            shape: StadiumBorder(),
                            onPressed: ()  {
                              setState(() {
                                _controllerPassword.text.isEmpty ? validateCNICVar = true
                                : validateCNICVar = false;
                                _controllerName.text.isEmpty ? validateName = true
                                : validateName = false;
                              });
                                !validateName & !validateCNICVar ? getInfoAndLogin() :
                                    Toast.show("Empty Field(s) Found!", context, backgroundColor: Colors.red, backgroundRadius: 5, duration: Toast.LENGTH_LONG);

                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // WidgetAnimator(
                                //   Image(
                                //     image: AssetImage('assets/google.png'),
                                //     height: height * 0.035,
                                //   ),
                                // ),
                                SizedBox(width: height * 0.015),
                                Text(
                                  'Login',
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.022),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        // WidgetAnimator(
                        //   Text(
                        //     'You Will be asked Question regarding your Qualifications!',
                        //     textAlign: TextAlign.center,
                        //     style: TextStyle(
                        //       color: Colors.black.withOpacity(0.5),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: height * 0.2,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class DoctorDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDoctorDetails> providerData;

  DoctorDetails(this.providerDetails, this.userName, this.photoUrl,
      this.userEmail, this.providerData);
}

class ProviderDoctorDetails {
  ProviderDoctorDetails(this.providerDetails);

  final String providerDetails;
}
