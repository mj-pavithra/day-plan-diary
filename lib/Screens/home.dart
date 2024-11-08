import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: SizedBox(
              width: 380,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black45
                      ),),
                      Text("Name", style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                  CircleAvatar(
                    radius: 20.0,
                    child: ClipOval(
                      child: Image.network(
                        'https://avatars.githubusercontent.com/u/83787860?v=4',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
          child: const Column(
            children: [
              Row(children: [
                Text("Today", style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold
                ),),
                Spacer(),
                Text("View All", style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.blue
                ),)
              ],)
            ],
          )
      ),
    );
  }
}