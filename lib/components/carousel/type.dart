class CarouselItem {
  final String pic;
  final String bannerId;
  final String typeTitle;

  CarouselItem({
    required this.pic,
    required this.bannerId,
    required this.typeTitle,
  });
}

class CarouselResponse {
  final List<CarouselItem> banners;

  CarouselResponse({required this.banners});
}

class RecommendListItem {
  final int id;
  final String name;
  final String picUrl;

  RecommendListItem({
    required this.id,
    required this.name,
    required this.picUrl,
  });
}
