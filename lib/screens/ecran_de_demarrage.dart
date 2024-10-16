import 'package:equilibromobile/screens/ecran_principal.dart';
import 'package:flutter/material.dart';

class EcranDeDemarrage extends StatefulWidget {
  @override
  _EcranDeDemarrageState createState() => _EcranDeDemarrageState();
}

class _EcranDeDemarrageState extends State<EcranDeDemarrage> {
  @override
  void initState() {
    super.initState()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ;
    _naviguerVersEcranPrincipal();
  }

  void _naviguerVersEcranPrincipal() async {
    await Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EcranPrincipal()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/logo 2.png'), 
      ),
    );
  }
}
