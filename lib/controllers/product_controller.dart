import 'package:flutter/services.dart';
import 'package:smartgear_store/consts/consts.dart';
import 'package:smartgear_store/models/category_model.dart';

class ProductController extends GetxController {
  var quantity = 0.obs, colorIndex = 0.obs;
  var totalPrice = 0.0.obs;
  var subcat = [];

  getSubCategories(title) async {
    subcat.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decoded = categoryModelFromJson(data);
    var s =
        decoded.categories.where((element) => element.name == title).toList();
    for (var e in s[0].subcategory) {
      subcat.add(e);
    }
  }

  changeColorIndex(index) {
    colorIndex.value = index;
  }

  increaseQuantity(totalQuantity) {
    if (quantity.value < totalQuantity) quantity.value++;
  }

  decreaseQuantity() {
    if (quantity.value > 0) quantity.value--;
  }

  calculatePrice(double price) {
    totalPrice.value = price * quantity.value;
  }
}
