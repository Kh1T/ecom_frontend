import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  final selectedIndex = 0.obs;

  final menuItems = <String>['Dashboard', 'Products', 'Orders', 'Users'];

  final menuIcons = <IconData>[
    Icons.dashboard,
    Icons.inventory_2,
    Icons.shopping_cart,
    Icons.people,
  ];

  final stats = <Map<String, dynamic>>[
    {'title': 'Total Sales', 'value': '\$12,450', 'icon': Icons.attach_money},
    {'title': 'Orders', 'value': '320', 'icon': Icons.shopping_bag},
    {'title': 'Users', 'value': '1,240', 'icon': Icons.people},
    {'title': 'Products', 'value': '86', 'icon': Icons.inventory_2},
  ].obs;

  void selectIndex(int index) => selectedIndex.value = index;
}
