import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartgear_store/common_widgets/loading_indicator.dart';
import 'package:smartgear_store/consts/consts.dart';
import 'package:smartgear_store/consts/lists.dart';
import 'package:smartgear_store/controllers/home_controller.dart';
import 'package:smartgear_store/services/firestore_services.dart';
import 'package:smartgear_store/views/category_screen/item_details.dart';
import 'package:smartgear_store/views/home_screen/components/featured_button.dart';
import 'package:smartgear_store/common_widgets/home_buttons.dart';
import 'package:smartgear_store/views/home_screen/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
          child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 60,
            color: lightGrey,
            child: TextFormField(
              controller: controller.searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: Icon(Icons.search).onTap(() {
                  if (controller.searchController.text.isNotEmptyAndNotNull) {
                    Get.to(() => SearchScreen(
                          title: controller.searchController.text,
                        ));
                  }
                }),
                filled: true,
                fillColor: whiteColor,
                hintText: searchAnything,
                hintStyle: TextStyle(color: textfieldGrey),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  //Swiper brands
                  VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 150,
                      enlargeCenterPage: true,
                      itemCount: firstSlidersList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          firstSlidersList[index],
                          fit: BoxFit.fill,
                        )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 8))
                            .make();
                      }),

                  //Deals Buttons
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        2,
                        (index) => homeButtons(
                              height: context.screenHeight * 0.15,
                              width: context.screenWidth / 2.5,
                              icon: index == 0 ? icTodaysDeal : icFlashDeal,
                              title: index == 0 ? todayDeal : flashSale,
                            )),
                  ),

                  10.heightBox,
                  //2nd Swiper
                  VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 150,
                      enlargeCenterPage: true,
                      itemCount: secondSlidersList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          secondSlidersList[index],
                          fit: BoxFit.fill,
                        )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 8))
                            .make();
                      }),

                  //Category buttons
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        3,
                        (index) => homeButtons(
                              height: context.screenHeight * 0.15,
                              width: context.screenWidth / 3.5,
                              icon: index == 0
                                  ? icTopCategories
                                  : index == 1
                                      ? icBrands
                                      : icTopSeller,
                              title: index == 0
                                  ? topCategories
                                  : index == 1
                                      ? brand
                                      : topSellers,
                            )),
                  ),

                  //Featured categories
                  20.heightBox,
                  Align(
                      alignment: Alignment.centerLeft,
                      child: featuredCategories.text
                          .color(darkFontGrey)
                          .size(18)
                          .fontFamily(semibold)
                          .make()),

                  20.heightBox,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                          3,
                          (index) => Column(
                                children: [
                                  featuredButton(
                                    icon: featuredImages1[index],
                                    title: featuredTitles1[index],
                                  ),
                                  10.heightBox,
                                  featuredButton(
                                    icon: featuredImages2[index],
                                    title: featuredTitles2[index],
                                  ),
                                ],
                              )).toList(),
                    ),
                  ),

                  //Featured Products
                  20.heightBox,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(color: redColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        featuredProduct.text.white
                            .fontFamily(semibold)
                            .size(18)
                            .make(),
                        10.heightBox,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FutureBuilder(
                              future: FirestoreServices.getFeaturedProducts(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: loadingIndicator());
                                } else if (snapshot.data!.docs.isEmpty) {
                                  return "No Featured Products!"
                                      .text
                                      .white
                                      .makeCentered();
                                } else {
                                  var featuredData = snapshot.data!.docs;
                                  return Row(
                                    children: List.generate(
                                      featuredData.length,
                                      (index) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            featuredData[index]['p_imgs'][0],
                                            width: 130,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          ),
                                          10.heightBox,
                                          "${featuredData[index]['p_name']}"
                                              .text
                                              .fontFamily(semibold)
                                              .color(darkFontGrey)
                                              .maxLines(
                                                  2) // As the name suggest
                                              .overflow(TextOverflow
                                                  .ellipsis) // If the name/text too long
                                              .make()
                                              .box
                                              .width(
                                                  130) // Set same width as image
                                              .make(),
                                          10.heightBox,
                                          "${featuredData[index]['p_price']}"
                                              .numCurrency
                                              .text
                                              .fontFamily(bold)
                                              .color(redColor)
                                              .make(),
                                        ],
                                      )
                                          .box
                                          .white
                                          .margin(const EdgeInsets.symmetric(
                                              horizontal: 4))
                                          .roundedSM
                                          .padding(const EdgeInsets.all(8))
                                          .make()
                                          .onTap(() {
                                        Get.to(ItemDetails(
                                          title:
                                              "${featuredData[index]['p_name']}",
                                          data: featuredData[index],
                                        ));
                                      }),
                                    ),
                                  );
                                }
                              }),
                        ),
                      ],
                    ),
                  ),

                  //Third Swiper
                  20.heightBox,
                  VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 150,
                      enlargeCenterPage: true,
                      itemCount: secondSlidersList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          secondSlidersList[index],
                          fit: BoxFit.fill,
                        )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 8))
                            .make();
                      }),

                  //all products section
                  20.heightBox,
                  Align(
                      alignment: Alignment.centerLeft,
                      child: "All Products"
                          .text
                          .fontFamily(bold)
                          .color(darkFontGrey)
                          .size(18)
                          .make()),
                  20.heightBox,
                  StreamBuilder(
                      stream: FirestoreServices.allProducts(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return loadingIndicator();
                        } else {
                          var allProductsData = snapshot.data!.docs;
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: allProductsData.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    mainAxisExtent: 300),
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    allProductsData[index]['p_imgs'][0],
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  const Spacer(),
                                  "${allProductsData[index]['p_name']}"
                                      .text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .make(),
                                  10.heightBox,
                                  "${allProductsData[index]['p_price']}"
                                      .text
                                      .fontFamily(bold)
                                      .color(redColor)
                                      .make(),
                                ],
                              )
                                  .box
                                  .white
                                  .margin(
                                      const EdgeInsets.symmetric(horizontal: 4))
                                  .roundedSM
                                  .padding(const EdgeInsets.all(12))
                                  .make()
                                  .onTap(() {
                                Get.to(ItemDetails(
                                  title: "${allProductsData[index]['p_name']}",
                                  data: allProductsData[index],
                                ));
                              });
                            },
                          );
                        }
                      })
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
