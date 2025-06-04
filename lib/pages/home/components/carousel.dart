import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/api/home/home_api.dart';
import 'package:music_player/pages/home/type.dart';
import 'package:music_player/http/request.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  List<CarouselItem> banners = [];

  @override
  void initState() {
    super.initState();
    _fetchBanners();
  }

  Future<void> _fetchBanners() async {
    try {
      var response = await Request.get(
        HomeApi().banner,
        queryParameters: {"type": '1'},
      );

      if (response['code'] == 200) {
        List<CarouselItem> items = (response['banners'] as List<dynamic>)
            .map(
              (item) => CarouselItem(
                pic: item['pic'],
                bannerId: item['bannerId'],
                typeTitle: item['typeTitle'] ?? '',
              ),
            )
            .toList();
        setState(() {
          banners = items;
        });
      } else {
        Fluttertoast.showToast(msg: response['message'] ?? '获取轮播图失败');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取轮播图失败');
    }
  }

  Future<void> _handleCarouselTap(CarouselItem item) async {
    Fluttertoast.cancel();
    Fluttertoast.showToast(msg: item.typeTitle);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = banners
        .map(
          (item) => Container(
            margin: EdgeInsets.all(5.0),
            height: 150,
            child: GestureDetector(
              onTap: () => _handleCarouselTap(item),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item.pic, width: 1000.0, fit: BoxFit.fill),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0,
                        ),
                        child: Text(
                          item.typeTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();

    return SizedBox(
      height: 150.0,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 150.0,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
        ),
        items: imageSliders,
      ),
    );
  }
}
