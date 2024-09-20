import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class TermsOfUse extends StatelessWidget {
  const TermsOfUse({super.key});


  Future _launcherUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) await launchUrl(Uri.parse(url));
  }

  Future openLink({
    required String url,
  }) =>
      _launcherUrl(url);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      right: false,
      left: false,
      child: Material(
        color: const Color.fromRGBO(235, 236, 247, 1),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all( 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("User-Generated Content License Agreement" , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w700 , color: Colors.black), ),
                const SizedBox(height: 16),
                Text("This User-Generated Content License Agreement (“Agreement”) is by and between Vivadoo.com and you or the organization you represent.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7)), ),
                const SizedBox(height: 10),
                Text("These terms and conditions of the Agreement apply to our use of any words, pictures, images, data, video, information or any other ‘user-generated content’ (the “User Generated Content” or “UGC”) that you upload, post, or share via Vivadoo website, mobile apps, social media pages, or other related services or via third-party websites and platforms including but not limited to Instagram, Facebook, Pinterest, YouTube, Snapchat, and Twitter and which we use on our website, platforms, apps, in other marketing channels or in any Vivadoo owned social media platforms.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7)), ),
                const SizedBox(height: 10),
                Text("If you choose to allow us to use your ‘user-generated content’ (the “User Generated Content” or “UGC”), you agree to these Terms of Use.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7)),),
                const SizedBox(height: 10),
                const Text("By agreeing to these Terms of Use, you grant Vivadoo, its legal representatives and successors, as well as persons and companies acting with its permission (collectively, “we”, “us”, or “our”), a perpetual, irrevocable, royalty-free, fully-paid, non-exclusive, transferable, sublicensable right and license to use, copy, modify, delete in its entirety, adapt, publish, translate, create derivative works from and/or sell and/or distribute such content and/or incorporate such content into any form, medium or technology throughout the world in any manner in their sole discretion, without compensation or obligation to you.",style:TextStyle(fontSize: 14 , color: Colors.black, fontWeight: FontWeight.w700),),

                const Divider(height: 36),
                const Text("GOOD PRACTICES" , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w700 , color: Colors.black), ),
                const SizedBox(height: 16),
                Text("Here are some things to remember when posting an ad:" , style: TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7)),),
                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("The text of the advertisement must describe the product / good / service of the advertisement. Ads containing a general text such as \"many products for sale in our store\" are not accepted. The text of the same advertisement must not propose several goods.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("The ad must be placed in a category corresponding to the purpose of the ad.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("The announcement of a property for sale must be filed in the municipality where the property is located.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("You must delete an old ad before inserting a new one for the same property. You can not have the same ad multiple times on the site (in multiple departments or multiple categories) at the same time.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text("We inform you that we allow an identical ad:",style:TextStyle(fontSize: 14 , color: Colors.black,fontWeight: FontWeight.w700),),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("By region when the advertiser has a large stock and a national delivery network as part of a good offer.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("By department, as part of a service offer.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("By city, up to 5 ads per department, as part of a job offer.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Any advertising advertisement is prohibited. The promotion of a service is only allowed in the category Services.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Exchanges are allowed on the site. However, it is not possible to list more than 5 model references that could serve as a basis for an exchange.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("You must indicate the total price in the \"Price\" field.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),

                const Divider(height: 36),
                // const SizedBox(height: 24),
                const Text("GENERAL PROHIBITIONS" , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w700 , color: Colors.black), ),
                const SizedBox(height: 16),
                Text("It is forbidden to deposit an advertisement:" , style: TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7)),),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Containing terms or descriptions unrelated to the proposed content.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Presenting an abusive use of keywords.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Directing directly or indirectly to a site other than ours.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Political, sectarian, discriminatory, sexist, in connection with organizations or persons responsible for crimes against humanity etc.",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),

                const Divider(height: 36),
                const Text("Unauthorized products and services" , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w700 , color: Colors.black), ),
                const SizedBox(height: 16),
                Text("As a Vivadoo user, you must ensure that the property you are seeking to sell or buy is an authorized product on the site and the sale of which is legal." , style: TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7)),),
                const SizedBox(height: 10),
                Text("We invite you to read the prohibited products / goods / services on our site:" , style: TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7)),),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Tobacco, drugs and related objects, dangerous and illicit substances",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Cosmetics, medicine and parapharmacy",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("White weapons of combat or self-defense, firearms, explosives, hunting traps",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Adult content",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Certain plant and animal species protected, threatened or taken from their natural environment",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Recorded objects",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Call for private or humanitarian financial donations",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Offers that can lead to tendentious practices",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Notice of Person Search",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("The majority of consumer products of industrial manufacture",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Slimming products, dietary supplements or presented as miraculous",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Product bearing protected emblems",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text("The misappropriation of the emblems (the sign of the red cross, the red crescent, the red crystal, the blue helmets, the white flag etc.) and their denomination and / or their illegal or abusive use are serious acts sanctioned by the law. international humanitarian",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),

                const Divider(height: 36),
                const Text("Unauthorized photographs" , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w700 , color: Colors.black),),
                const SizedBox(height: 16),
                Text("The inserted photographs must represent the property for sale and can not be used to illustrate more than one advertisement." , style: TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7)),),
                const SizedBox(height: 10),
                Text("It is forbidden to insert photos containing:" , style: TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7)),),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Recognizable minor children",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Logos (except Employment and Services ads categories)",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Link to a website",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 54,
                      child: Text("Representations unrelated to the proposed offer",style:TextStyle(fontSize: 14 , color: Colors.black.withOpacity(0.7),height: 1.2),),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                const Text("Vivadoo.com © Copyright 2024 - All rights reserved." , style: TextStyle(fontSize: 14 , color: Colors.grey),),
                const Text("Lebanese Made - A realization by Thales IT" , style: TextStyle(fontSize: 14 , color: Colors.grey),),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
