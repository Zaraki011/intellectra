import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  const Carousel({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 130.0,
        autoPlay: true,
      ),
      items: [
        GestureDetector(
          onTap: () {},
          child: Card(
            elevation: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                'assets/images/insight.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Card(
            elevation: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                'assets/images/bootcamp.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Card(
            elevation: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                'assets/images/goo.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
