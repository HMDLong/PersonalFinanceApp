import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saving_app/models/category.model.dart';

List<TransactCategory> builtInCategories = [
  TransactCategory(id: "1", type: false, name: "Housing", icon: Icons.house.codePoint,
    subCategories: [
      TransactCategory(id: "1.1", type: false, name: "Rent", icon: Icons.house.codePoint),
      TransactCategory(id: "1.2", type: false, name: "Rental Insurances", icon: Icons.house.codePoint),
      TransactCategory(id: "1.3", type: false, name: "Repairations", icon: Icons.house.codePoint),
      TransactCategory(id: "1.4", type: false, name: "Improvements", icon: Icons.house.codePoint),
      TransactCategory(id: "1.5", type: false, name: "Appliances", icon: Icons.house.codePoint),
      TransactCategory(id: "1.6", type: false, name: "Other", icon: Icons.house.codePoint),
    ],
  ),
  TransactCategory(id: "2", type: false, name: "Food", icon: Icons.food_bank_outlined.codePoint,
    subCategories: [
      TransactCategory(id: "2.1", type: false, name: "Groceries", icon: Icons.house.codePoint),
      TransactCategory(id: "2.2", type: false, name: "Eating-out", icon: Icons.house.codePoint),
      TransactCategory(id: "2.3", type: false, name: "Café", icon: Icons.house.codePoint),
    ],
  ),
  TransactCategory(id: "3", type: false, name: "Transport", icon: CupertinoIcons.bus.codePoint,
    subCategories: [
      TransactCategory(id: "3.1", type: false, name: "Vehicle Payment", icon: Icons.house.codePoint),
      TransactCategory(id: "3.2", type: false, name: "Fare", icon: Icons.house.codePoint),
      TransactCategory(id: "3.3", type: false, name: "Repairs", icon: Icons.house.codePoint),
      TransactCategory(id: "3.4", type: false, name: "Registration", icon: Icons.house.codePoint),
      TransactCategory(id: "3.5", type: false, name: "Fuel/Electric", icon: Icons.house.codePoint),
      TransactCategory(id: "3.6", type: false, name: "Parking Fees", icon: Icons.house.codePoint),
    ]
  ),
  TransactCategory(id: "4", type: false, name: "Utilities", icon: CupertinoIcons.bus.codePoint,
    subCategories: [
      TransactCategory(id: "4.1", type: false, name: "Electricity", icon: Icons.house.codePoint),
      TransactCategory(id: "4.2", type: false, name: "Water", icon: Icons.house.codePoint),
      TransactCategory(id: "4.3", type: false, name: "Trash/Sewer", icon: Icons.house.codePoint),
      TransactCategory(id: "4.4", type: false, name: "Gas", icon: Icons.house.codePoint),
      TransactCategory(id: "4.5", type: false, name: "Phone", icon: Icons.house.codePoint),
      TransactCategory(id: "4.6", type: false, name: "Cable TV", icon: Icons.house.codePoint),
      TransactCategory(id: "4.7", type: false, name: "Internet", icon: Icons.house.codePoint),
    ],
  ),
  TransactCategory(id: "5", type: false, name: "Education", icon: CupertinoIcons.bus.codePoint,
    subCategories: [
      TransactCategory(id: "5.1", type: false, name: "Primary Fees", icon: Icons.house.codePoint),
      TransactCategory(id: "5.2", type: false, name: "Tutors", icon: Icons.house.codePoint),
      TransactCategory(id: "5.3", type: false, name: "Cram schools", icon: Icons.house.codePoint),
      TransactCategory(id: "5.4", type: false, name: "Courses", icon: Icons.house.codePoint),
      TransactCategory(id: "5.5", type: false, name: "Others", icon: Icons.house.codePoint),
    ],
  ),
  TransactCategory(id: "6", type: false, name: "Entertainment", icon: CupertinoIcons.bus.codePoint,
    subCategories: [
      TransactCategory(id: "6.1", type: false, name: "Activities", icon: Icons.house.codePoint),
      TransactCategory(id: "6.2", type: false, name: "Books", icon: Icons.house.codePoint),
      TransactCategory(id: "6.3", type: false, name: "Games", icon: Icons.house.codePoint),
      TransactCategory(id: "6.4", type: false, name: "Fun stuff", icon: Icons.house.codePoint),
      TransactCategory(id: "6.5", type: false, name: "Hobbies", icon: Icons.house.codePoint),
      TransactCategory(id: "6.6", type: false, name: "Film/Music", icon: Icons.house.codePoint),
      TransactCategory(id: "6.7", type: false, name: "Outdoor Recreation", icon: Icons.house.codePoint),
      TransactCategory(id: "6.8", type: false, name: "Sports", icon: Icons.house.codePoint),
      TransactCategory(id: "6.9", type: false, name: "Toys/Gadgets", icon: Icons.house.codePoint),
      TransactCategory(id: "6.10", type: false, name: "Travel", icon: Icons.house.codePoint)
    ],
  ),
  TransactCategory(id: "7", type: false, name: "Personal care", icon: CupertinoIcons.bus.codePoint,
    subCategories: [
      TransactCategory(id: "7.1", type: false, name: "Clothing", icon: Icons.house.codePoint),
      TransactCategory(id: "7.2", type: false, name: "Personal Supplies", icon: Icons.house.codePoint),
      TransactCategory(id: "7.3", type: false, name: "Salon/Barber", icon: Icons.house.codePoint),
      TransactCategory(id: "7.4", type: false, name: "Accessories", icon: Icons.house.codePoint),
      TransactCategory(id: "7.5", type: false, name: "Pet", icon: Icons.house.codePoint),
    ],
  ),
  TransactCategory(id: "8", type: false, name: "Healthcare", icon: CupertinoIcons.bus.codePoint,
    subCategories: [
      TransactCategory(id: "8.1", type: false, name: "Health Insurance", icon: Icons.house.codePoint),
      TransactCategory(id: "8.2", type: false, name: "Doctor", icon: Icons.house.codePoint),
      TransactCategory(id: "8.3", type: false, name: "Medicine", icon: Icons.house.codePoint),
      TransactCategory(id: "8.4", type: false, name: "Medical supplies", icon: Icons.house.codePoint),
      TransactCategory(id: "8.5", type: false, name: "Other", icon: Icons.house.codePoint),
    ],
  ),
  TransactCategory(id: "9", type: false, name: "Giveaway", icon: CupertinoIcons.bus.codePoint,
    subCategories: [
      TransactCategory(id: "9.1", type: false, name: "Gift", icon: Icons.house.codePoint),
      TransactCategory(id: "9.2", type: false, name: "Donations", icon: Icons.house.codePoint),
      TransactCategory(id: "9.4", type: false, name: "Other", icon: Icons.house.codePoint),
    ],
  ),
  TransactCategory(id: "10", type: false, name: "Subcriptions", icon: CupertinoIcons.bus.codePoint,
    subCategories: [
      TransactCategory(id: "10.1", type: false, name: "Newspaper", icon: Icons.house.codePoint),
      TransactCategory(id: "10.2", type: false, name: "Magazines", icon: Icons.house.codePoint),
      TransactCategory(id: "10.3", type: false, name: "Memberships", icon: Icons.house.codePoint),
      TransactCategory(id: "10.4", type: false, name: "Other", icon: Icons.house.codePoint),
    ],
  ),
  TransactCategory(id: "11", type: true, name: "Income", icon: Icons.currency_pound_sharp.codePoint,
    subCategories: [
      TransactCategory(id: "11.1", type: true, name: "Newspaper", icon: Icons.house.codePoint),
      TransactCategory(id: "11.2", type: true, name: "Magazines", icon: Icons.house.codePoint),
      TransactCategory(id: "11.3", type: true, name: "Memberships", icon: Icons.house.codePoint),
      TransactCategory(id: "11.4", type: true, name: "Other", icon: Icons.house.codePoint),
    ]
  ),
];

// void main() {
//   List<Map<String, dynamic>> data = [];
//   for (var cate in builtInCategories) {
//     data.add(cate.toJson());
//   }
//   File('categories.json').writeAsString(jsonEncode({"data": data}));
// }
