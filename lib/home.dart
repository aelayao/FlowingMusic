import 'package:flutter/material.dart';

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
                
              ),
            )
        );
      }
    }