import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medkit/animations/bottomAnimation.dart';
import 'package:medkit/doctor/doctorLogin.dart';
import 'package:medkit/otherWidgetsAndScreen/backBtnAndImage.dart';
import 'package:medkit/patient/patientPanel.dart';
import 'package:toast/toast.dart';

class PatientLogin extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _controllerName = TextEditingController();

  Future<void> signIn(BuildContext context, String email) async {

    // final AuthCredential credential = EmailAuthProvider.getCredential(email: "petre@gmail.com", password: "parola");
    // FirebaseUser userDetails =
    //     await _firebaseAuth.signInWithCredential(credential);
    // ProviderDoctorDetails providerInfo =
    //     new ProviderDoctorDetails(userDetails.providerId);
    //
    // List<ProviderDoctorDetails> providerData =
    //     new List<ProviderDoctorDetails>();
    // providerData.add(providerInfo);

    String name = email.split('@').first;

    PatientDetails details = new PatientDetails(
      name ?? "patient",
      null,
      email ?? "patient@gmail.com",
    );

    Firestore.instance
        .collection('patientInfo')
        .document(email)
        .setData({
      'user': email,
    });

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => PatientPanel(
                  detailsUser: details,
                )));

  }

  controllerClear(){
    _controllerName.clear();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            BackBtn(),
            ImageAvatar(
              assetImage: 'assets/bigPat.png',
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
                        // setState(() {
                        //   _controllerName.text.isEmpty ? validateName = true : validateName = false;
                        // });
                        // !validateName ? getInfoAndLogin() :
                        !_controllerName.text.trim().isEmpty ? signIn(context, _controllerName.text.trim()) :
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
                  // SizedBox(height: height * 0.2,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientDetails {
  // final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  // final List<ProviderDoctorDetails> providerData;

  PatientDetails(this.userName, this.photoUrl,
      this.userEmail);
}

class ProviderPatientDetails {
  ProviderPatientDetails(this.providerDetails);

  final String providerDetails;
}
