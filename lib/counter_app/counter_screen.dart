import 'package:app_matic_tech_flutter_app/counter_app/button_colors.dart';
import 'package:app_matic_tech_flutter_app/counter_app/font_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int count = 0;

  void increaseCount() {
    if (count < 20) {
      setState(() {
        count++;
      });
    }
  }

  void decreaseCount() {
    if (count > 0) {
      setState(() {
        count--;
      });
    }
  }

  void plusfive(){
    if (count <=20){
    setState(() {
      count+=5;
    });}
}
  void minusfive(){
    if (count >=0){
    setState(() {
      count-=5;
    });}

  }

  void resetCount() {
    setState(() {
      count = 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   backgroundColor: ButtonColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: ButtonColors.whiteColor,
        elevation: 2,
        centerTitle: true,
        title: Text('Counter App',style: TextStyle(
          color: ButtonColors.deepPurple,
          fontSize: FontSize.Fontheader,
          fontWeight: FontWeight.w600,
        ),),
      ),
      body: SafeArea(
    child: SingleChildScrollView(
    child:
      Padding(padding: EdgeInsets.all(20),
      child: Column(
        children: [

          const SizedBox(height: 30,),
          Container(
            width: double.infinity,
            height:350.0,
            decoration: BoxDecoration(
              color: ButtonColors.softLavender,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const[
                BoxShadow(
                  color: ButtonColors.whiteColor,
                  blurRadius:5,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: const Text('Current Count',
                    style: TextStyle(
                      fontSize: 22,
                      color: ButtonColors.deepPurple,
                    ),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text('$count',
                    style: const TextStyle(
                      color: ButtonColors.deepPurple,
                      fontSize: 140,
                      fontWeight: FontWeight.w500,
                    ),
                  ),


                ]
          )
          ),

             ),
          SizedBox(height: 40,),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: count == 0 ? null : decreaseCount,
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    size: 30,
                  ),
                  label: const Text(
                    'Decrease',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ButtonColors.whiteColor,
                    foregroundColor: ButtonColors.primaryTextColor,
                    disabledBackgroundColor:
                    ButtonColors.disabledColor,
                    minimumSize: const Size(0, 70),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: count == 20 ? null : increaseCount,
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 30,
                  ),
                  label: const Text(
                    'Increase',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: ButtonColors.primaryPurple,
                    foregroundColor: ButtonColors.whiteColor,
                    minimumSize: const Size(0, 70),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(onPressed: plusfive,
                  child: Text('+5',style: TextStyle(
                    color: ButtonColors.deepPurple,
                    fontSize: 13,
                    fontWeight:FontWeight(500),
                  ),)),
              SizedBox(width: 15,),
              IconButton(onPressed: minusfive, icon: Icon(CupertinoIcons.minus,size: 20,color:ButtonColors.deepPurple,),
              ),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 400,
            height: 70,
            child: OutlinedButton.icon(
              onPressed: resetCount,
              icon: const Icon(
                Icons.sync,
                size: 32,
              ),
              label: const Text(
                'Reset Counter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: ButtonColors.primaryPurple,
                  side: const BorderSide(
                    color: ButtonColors.primaryPurple,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )
              ),
            ),
          )
  ]

    ),
    ),

    )
    ),
    );

  }
}
