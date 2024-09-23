import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

class TimerPageWidget extends StatefulWidget {
  const TimerPageWidget({super.key});

  @override
  State<TimerPageWidget> createState() => _TimerPageWidgetState();
}

class _TimerPageWidgetState extends State<TimerPageWidget> {
  Timer? _timer;
  int remainingTime = 0;
  int selectedMinutes = 0;
  int selectedHours = 0;
  bool isTimerActive = false;
  bool isTimerPaused = false;
  FixedExtentScrollController hoursController = FixedExtentScrollController();
  FixedExtentScrollController minutesController = FixedExtentScrollController();
  

  @override
  void dispose(){
    _timer?.cancel();
    hoursController.dispose();
    minutesController.dispose();
    super.dispose();
  }

  void startTimer(){
    if (selectedMinutes <= 0 && selectedHours <= 0) return;

    setState(() {
      if (!isTimerPaused){     
         remainingTime = selectedHours * 3600 + selectedMinutes * 60;
      }
      isTimerActive = true;
      isTimerPaused = false;
    });
  
  _timer?.cancel();
  _timer = Timer.periodic(const Duration(seconds: 1),(Timer timer){
    setState(() {
      if ( remainingTime>0){
        remainingTime--;
      }  
      else {
        timer.cancel();
        isTimerActive = false;
      }  
      });
  });
  }

void stopTimer(){
          _timer?.cancel();
          setState(() {
            isTimerActive = false;
            isTimerPaused = true;
          });
        }

void cancelTimer(){
  _timer?.cancel();
  setState(() {
    remainingTime = 0;
    selectedHours = 0;
    selectedMinutes = 0;
    isTimerActive = false;
    isTimerPaused = false;
    hoursController.jumpToItem(0);
    minutesController.jumpToItem(0);
  });
}

double getProgress(){
  if (selectedMinutes <= 0 && selectedHours <= 0) return 0.0;
  int totalTime = selectedHours * 3600 + selectedMinutes * 60;
  if(totalTime == 0) return 0.0;
return remainingTime / totalTime;
}        
  
  String formatTime(int seconds){
    final int hours=seconds ~/ 3600;
    final int minutes = ( seconds % 3600) ~/ 60;
    final int secs = seconds % 60 ;
    return '${hours.toString().padLeft( 2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Timer', 
            style: TextStyle(
              color:Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w700
            ),
            ),
             Icon(Icons.timer, color:Colors.white )
          ]
        ),
        backgroundColor: Colors.black,
        ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Stack(
                alignment: Alignment.center,
                children: [
                  if (isTimerActive || isTimerPaused)  ...[
                  SizedBox(
                height: 370,
                width: 370,
                child: 
                     CircularProgressIndicator(
                    value: getProgress(),
                      backgroundColor: Colors.blue,
                      color: Colors.grey,
                      strokeWidth: 12,
                    ),
                 ),
                ],
      
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 80,
                       child: CupertinoPicker(
                  scrollController: hoursController,
                    itemExtent: 45,
                    onSelectedItemChanged: (index){ 
              setState((){
                selectedHours = index;
              
              });
              },
               
              children:List<Widget>.generate(24, (index){
                return Center(
                  child: Text(
                    index.toString(),
                    style: const TextStyle(color:Colors.white, fontSize: 20),
                  ),
                );
              }
            ),
          ),
        ),
        
      
        
              const SizedBox(width:10),
              const Text (
                'Hr',
                style: TextStyle(color:Colors.white,fontSize:25),
              ),
              const SizedBox(width:10),
              SizedBox(
              height:100,
              width: 80,
              child: CupertinoPicker(
                scrollController: minutesController,
                itemExtent: 45,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedMinutes = index;
                    });
                  },
                  children: 
                    List<Widget>.generate(61,(index){
                    return Center(
                      child: Text(
                        index.toString(),
                      style:const TextStyle(
                        color:Colors.white,fontSize:20),
                      ),
                    );
                  }
                )   
              ),
            ),  
              const SizedBox(width: 10),
                  const Text(
                    'Min',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              Text(
                formatTime(remainingTime),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 65,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      
      
              const SizedBox(height: 100),
              Row(
             
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isTimerActive || isTimerPaused) ...[
                           ElevatedButton(
                            onPressed: cancelTimer,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.amber,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(30)
                            ),
                              child: const Text('Cancel'),
                           ),
                          ],
                        
                          const SizedBox(width: 10),
                          Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                 children:[
                                  ElevatedButton(
                                    onPressed: isTimerActive ? stopTimer : startTimer ,
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: isTimerActive
                                      ? const Color.fromARGB(255, 178, 32, 22) : isTimerPaused ?
                                      const Color.fromARGB(255, 27, 23, 129):
                                      const Color.fromARGB(255, 9, 147, 25) ,
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(30)
                                   ),
                                    child: Text(isTimerActive ? 'Pause' :isTimerPaused?'Resume':'Start'),
                                  ),
                                ],
                             ),
                           ],
                        ),
                      ],
                    ),          
                  ),
      );
  }
}


void main() {
  runApp(const MaterialApp(
    home: TimerPageWidget(),
  ));
}

