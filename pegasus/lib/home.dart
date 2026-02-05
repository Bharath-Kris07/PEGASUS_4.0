import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pegasus/camera.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    void toCamera() {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CameraView()));
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pegasus",
          style: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.bold
          ),
          ),
      ),
      body: Center(
        child: CarouselSlider(
          options: CarouselOptions(
            height: 1.6.dp,
            enlargeCenterPage: true,
            reverse: false,
            // enableInfiniteScroll: false
            ),
          items: [1,2,3,4,5].map((i) {
            List<Color> colors = [Colors.green.shade300, Colors.green.shade400 ,Colors.green, Colors.green.shade600, Colors.green.shade800];
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    toCamera();
                  },
                  child: Container(
                    width: 1.5.dp,
                    // height: 1.6.dp,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: colors[i-1],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined, size: 50.sp, color: Colors.white,),
                        Text("Camera 0$i", 
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        )
                        ,)
                      ],
                    ))
                  ),
                );
              },
            );
          }).toList(),
        ),
      )
    );
  }
}