import 'package:flutter/material.dart';
import '../../service details/view/ServiceDetailScreen.dart';
export '../provider/CategoryDetailProvider.dart' show Service;

class Service {
  final String id;
  final String name;
  final String imagePath;
  final String category;

  Service({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.category,
  });
}

class CategoryDetailProvider extends ChangeNotifier {
  final String categoryTitle;

  CategoryDetailProvider(this.categoryTitle);

  // Services data mapped by category
  final Map<String, List<Service>> _categoryServices = {
    "Tailor Services": [
      Service(
        id: 'tailor_1',
        name: "Clothing",
        imagePath: "https://images.unsplash.com/photo-1558769132-cb1aea3c8e5e",
        category: "Tailor Services",
      ),
      Service(
        id: 'tailor_2',
        name: "Suit Tailor",
        imagePath: "https://images.unsplash.com/photo-1594938298603-c8148c4dae35",
        category: "Tailor Services",
      ),
      Service(
        id: 'tailor_3',
        name: "Gilie Uniform",
        imagePath: "https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8",
        category: "Tailor Services",
      ),
      Service(
        id: 'tailor_4',
        name: "Kids Tailor",
        imagePath: "https://images.unsplash.com/photo-1519238263530-99bdd11df2ea",
        category: "Tailor Services",
      ),
      Service(
        id: 'tailor_5',
        name: "Women's Full Fit Circle",
        imagePath: "https://images.unsplash.com/photo-1539008835657-9e8e9680c956",
        category: "Tailor Services",
      ),
      Service(
        id: 'tailor_6',
        name: "Alterations",
        imagePath: "https://images.unsplash.com/photo-1556905055-8f358a7a47b2",
        category: "Tailor Services",
      ),
      Service(
        id: 'tailor_7',
        name: "Wedding Attire",
        imagePath: "https://images.unsplash.com/photo-1519741497674-611481863552",
        category: "Tailor Services",
      ),
      Service(
        id: 'tailor_8',
        name: "Other Tailor Services",
        imagePath: "https://images.unsplash.com/photo-1618221195710-dd6b41faaea6",
        category: "Tailor Services",
      ),
    ],
    "Entertainment & Event": [
      Service(
        id: 'entertainment_1',
        name: "DJ Services",
        imagePath: "https://images.unsplash.com/photo-1571266028243-d220ee3f6f99",
        category: "Entertainment & Event",
      ),
      Service(
        id: 'entertainment_2',
        name: "Photography",
        imagePath: "https://images.unsplash.com/photo-1542038784456-1ea8e935640e",
        category: "Entertainment & Event",
      ),
      Service(
        id: 'entertainment_3',
        name: "Event Planning",
        imagePath: "https://images.unsplash.com/photo-1511795409834-ef04bbd61622",
        category: "Entertainment & Event",
      ),
      Service(
        id: 'entertainment_4',
        name: "Catering",
        imagePath: "https://images.unsplash.com/photo-1555244162-803834f70033",
        category: "Entertainment & Event",
      ),
      Service(
        id: 'entertainment_5',
        name: "Decoration",
        imagePath: "https://images.unsplash.com/photo-1464366400600-7168b8af9bc3",
        category: "Entertainment & Event",
      ),
      Service(
        id: 'entertainment_6',
        name: "Live Band",
        imagePath: "https://images.unsplash.com/photo-1501281668745-f7f57925c3b4",
        category: "Entertainment & Event",
      ),
    ],
    "Towing Services": [
      Service(
        id: 'towing_1',
        name: "Car Towing",
        imagePath: "https://images.unsplash.com/photo-1632823469270-1a8f8e0d6eb1",
        category: "Towing Services",
      ),
      Service(
        id: 'towing_2',
        name: "Bike Towing",
        imagePath: "https://images.unsplash.com/photo-1558618666-fcd25c85cd64",
        category: "Towing Services",
      ),
      Service(
        id: 'towing_3',
        name: "Emergency Towing",
        imagePath: "https://images.unsplash.com/photo-1621939514649-280e2ee25f60",
        category: "Towing Services",
      ),
      Service(
        id: 'towing_4',
        name: "Heavy Vehicle Towing",
        imagePath: "https://images.unsplash.com/photo-1581091226825-c6a89e7e4801",
        category: "Towing Services",
      ),
    ],
    "Cleaning": [
      Service(
        id: 'cleaning_1',
        name: "Home Cleaning",
        imagePath: "https://images.unsplash.com/photo-1581578731548-c64695cc6952",
        category: "Cleaning",
      ),
      Service(
        id: 'cleaning_2',
        name: "Office Cleaning",
        imagePath: "https://images.unsplash.com/photo-1600880292203-757bb62b4baf",
        category: "Cleaning",
      ),
      Service(
        id: 'cleaning_3',
        name: "Deep Cleaning",
        imagePath: "https://images.unsplash.com/photo-1628177142898-93e36e4e3a50",
        category: "Cleaning",
      ),
      Service(
        id: 'cleaning_4',
        name: "Carpet Cleaning",
        imagePath: "https://images.unsplash.com/photo-1604335399105-a0c585fd81a1",
        category: "Cleaning",
      ),
      Service(
        id: 'cleaning_5',
        name: "Window Cleaning",
        imagePath: "https://images.unsplash.com/photo-1585421514738-01798e348b17",
        category: "Cleaning",
      ),
    ],
    "Handy Works": [
      Service(
        id: 'handy_1',
        name: "Plumbing",
        imagePath: "https://images.unsplash.com/photo-1607472586893-edb57bdc0e39",
        category: "Handy Works",
      ),
      Service(
        id: 'handy_2',
        name: "Electrical Work",
        imagePath: "https://images.unsplash.com/photo-1621905251918-48416bd8575a",
        category: "Handy Works",
      ),
      Service(
        id: 'handy_3',
        name: "Carpentry",
        imagePath: "https://images.unsplash.com/photo-1567016376408-0226e4d0c1ea",
        category: "Handy Works",
      ),
      Service(
        id: 'handy_4',
        name: "Painting",
        imagePath: "https://images.unsplash.com/photo-1562259949-e8e7689d7828",
        category: "Handy Works",
      ),
      Service(
        id: 'handy_5',
        name: "AC Repair",
        imagePath: "https://images.unsplash.com/photo-1581094271901-8022df4466f9",
        category: "Handy Works",
      ),
    ],
    "Food": [
      Service(
        id: 'food_1',
        name: "Home Chef",
        imagePath: "https://images.unsplash.com/photo-1556910103-1c02745aae4d",
        category: "Food",
      ),
      Service(
        id: 'food_2',
        name: "Catering",
        imagePath: "https://images.unsplash.com/photo-1555244162-803834f70033",
        category: "Food",
      ),
      Service(
        id: 'food_3',
        name: "Bakery",
        imagePath: "https://images.unsplash.com/photo-1509440159596-0249088772ff",
        category: "Food",
      ),
      Service(
        id: 'food_4',
        name: "Party Food",
        imagePath: "https://images.unsplash.com/photo-1555939594-58d7cb561ad1",
        category: "Food",
      ),
    ],
    "Engineering": [
      Service(
        id: 'engineering_1',
        name: "Civil Engineering",
        imagePath: "https://images.unsplash.com/photo-1503387762-592deb58ef4e",
        category: "Engineering",
      ),
      Service(
        id: 'engineering_2',
        name: "Mechanical",
        imagePath: "https://images.unsplash.com/photo-1581094271901-8022df4466f9",
        category: "Engineering",
      ),
      Service(
        id: 'engineering_3',
        name: "Electrical",
        imagePath: "https://images.unsplash.com/photo-1473341304170-971dccb5ac1e",
        category: "Engineering",
      ),
      Service(
        id: 'engineering_4',
        name: "Structural Design",
        imagePath: "https://images.unsplash.com/photo-1504917595217-d4dc5ebe6122",
        category: "Engineering",
      ),
    ],
    "Tutoring": [
      Service(
        id: 'tutoring_1',
        name: "Math Tutor",
        imagePath: "https://images.unsplash.com/photo-1509869175650-a1d97972541a",
        category: "Tutoring",
      ),
      Service(
        id: 'tutoring_2',
        name: "Science Tutor",
        imagePath: "https://images.unsplash.com/photo-1532094349884-543bc11b234d",
        category: "Tutoring",
      ),
      Service(
        id: 'tutoring_3',
        name: "Language Tutor",
        imagePath: "https://images.unsplash.com/photo-1546410531-bb4caa6b424d",
        category: "Tutoring",
      ),
      Service(
        id: 'tutoring_4',
        name: "Music Lessons",
        imagePath: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d",
        category: "Tutoring",
      ),
      Service(
        id: 'tutoring_5',
        name: "Computer Classes",
        imagePath: "https://images.unsplash.com/photo-1516321318423-f06f85e504b3",
        category: "Tutoring",
      ),
    ],
  };

  List<Service> get services {
    return _categoryServices[categoryTitle] ?? [];
  }

  void onServiceTap(Service service, BuildContext context) {
    // Navigate to service detail screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailScreen(service: service),
      ),
    );
  }
}