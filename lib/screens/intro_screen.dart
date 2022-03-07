import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../camera_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() {
    // TODO: implement createState
    return _IntroScreenState();
  }
}

class _IntroScreenState extends State<IntroScreen>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.face, size: 100, color: Colors.lightGreen),
              const SizedBox(height: 20),
              const Text('Face Recognition\nAthentication',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center),
              Expanded(
                child: Container(),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton.icon(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> CameraScreen()));
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Sign in'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            )
                        )
                    )),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton.icon(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> CameraScreen()));
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Sign up'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            )
                        )
                    )),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}