import '../models/itinerary.dart';

const String currentUserName = 'Stanley Woo';

const int placesVisitedCount = 69;
const String followersCount = '634k';

/// Notes: Master list of demo itineraires for the ProfilePage
/// Excludes video blocks for faster rendering in the demo
final List<ItineraryStatic> deomoItineraries = [
  ItineraryStatic(
    id: 1,
    title: 'Akita Winter Onsen',
    destination: 'Akita, Japan',
    days: 8,
    userName: currentUserName,
    likes: 5600,
    forks: 6,
    saves: 3400,
    blocks: [
      TextBlock(
        "「銀山溫泉」有著懷舊復古的氣氛，原本就因為日劇《阿信》的拍攝場景而爆紅，近年因像極了日本動畫《神隱少女》湯屋場景再度翻紅。這篇就要為大家介紹銀山溫泉旅館、交通方式跟推薦行程。現在就跟著「樂吃購！日本」記者一起到這個一生必去一次的夢幻景點，體驗銀山溫泉的魅力吧！",
      ),
      PhotoBlock("https://picsum.photos/400/200?image=10"),
    ],
  ),
  ItineraryStatic(
    id: 2,
    title: "Honeymoon with _____",
    destination: 'Italy',
    days: 10,
    userName: currentUserName,
    likes: 67000,
    forks: 4500,
    saves: 456023,
    blocks: [
      TextBlock("Having The Best Cruise Trip As Our Honeymoon!"),
      PhotoBlock("https://picsum.photos/400/200?image=20"),
    ],
  ),
  ItineraryStatic(
    id: 3,
    title: 'Solo Travel in Faroe Island',
    destination: 'Faroe Island',
    days: 5,
    userName: currentUserName,
    likes: 3400,
    forks: 60,
    saves: 1314,
    blocks: [
      TextBlock('A Magical Edge of The World'),
      PhotoBlock('https://picsum.photos/400/200?image=30'),
    ],
  ),
];

List<ItineraryStatic> get myItineraries =>
    deomoItineraries.where((it) => it.userName == currentUserName).toList();

final Set<int> favoriteIds = {2};
List<ItineraryStatic> get myFavorites =>
    deomoItineraries.where((it) => favoriteIds.contains(it.id)).toList();

List<ItineraryStatic> get myForks => [deomoItineraries[0], deomoItineraries[2]];
