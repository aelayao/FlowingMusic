import 'package:flutter/material.dart';
import 'package:flowing_music/imports.dart';

class HomeScreen extends StatefulWidget{
    const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();

}
class _HomeScreenState extends State<HomeScreen>{
  @override
    Widget build(BuildContext context ){
        return Scaffold(
          backgroundColor: const Color.fromRGBO(54, 38, 71, 1),
            body: SafeArea(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ajustes',
                        style: TextStyle(fontSize: 28, color: const Color.fromARGB(233, 239, 169, 248), fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Ajuste',

                      ),
                    ]
              ),
            )
        );
      }
    }