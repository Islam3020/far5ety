class IntroModel {
  final String image;
  final String title;
  final String description;

  IntroModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<IntroModel> introPages = [
  IntroModel(
    image: 'assets/images/chicken.jpg',
    title: 'فرختك لحد باب البيت',
    description: 'اختار نوع الطير اللي نفسك فيه واحنا نوصلهولك لحد عندك.',
  ),
  IntroModel(
    image: 'assets/images/تقطيع.jpg',
    title: 'تقطيع زي ما تحب',
    description: 'بانيه؟ وراك؟ استربس؟ كل التقطيعات اللي بتحبها موجودة.',
  ),
  IntroModel(
    image: 'assets/images/cleanchicken.webp',
    title: 'نضفناها... وجهزناها ليك',
    description: 'كل الطيور متجهزة ومنضفة على أصولها ومستنياك.',
  ),
];