import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/api/home/home_api.dart';
import 'package:music_player/components/carousel/type.dart';
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
    Fluttertoast.showToast(msg: item.typeTitle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider(
        options: CarouselOptions(height: 200, viewportFraction: 1),
        items: banners.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  _handleCarouselTap(i);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Row(
                    children: [
                      Image(
                        image: NetworkImage(i.pic),
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
