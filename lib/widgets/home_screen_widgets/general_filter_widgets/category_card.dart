import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:vivadoo/models/filters/category_model.dart';
import 'package:vivadoo/widgets/home_screen_widgets/general_filter_widgets/sub_category_card.dart';

Widget categoryCard (BuildContext context , CategoryModel categoryModel ,  int index) {
  return StickyHeader(
    header: Container(
      padding: const EdgeInsets.only(left: 20 , right: 12),
      width: MediaQuery.of(context).size.width ,
      height: 30,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(170, 170, 170, 1),
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: categoryModel.icon,
            width: 20,
          ),
          const SizedBox(width: 16),
          Text(categoryModel.name , style: const TextStyle(fontSize: 16 , color: Color(0xFFffffff) , fontWeight: FontWeight.w700),)
        ],
      ),
    ),
    content: ListView.separated(
      shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      itemCount: categoryModel.subCategoryModel.length,
      itemBuilder: (context , index){
          return subCategoryCard(context, categoryModel.subCategoryModel[index] ,categoryModel.id );
      },
      separatorBuilder: (ctx , index) => const Divider(indent: 20,),
    ),
  );
}