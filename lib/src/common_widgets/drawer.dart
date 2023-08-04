// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:benji_rider/app/earning/earning.dart';
import 'package:flutter/material.dart';

import '../../app/delivered_history/history.dart';
import '../../theme/colors.dart';
import '../providers/constants.dart';
import 'list_tile.dart';

class MyDrawer extends StatefulWidget {
  final bool isOnline;
  final Function() toggleOnline;
  const MyDrawer({
    Key? key,
    required this.isOnline,
    required this.toggleOnline,
  }) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kPrimaryColor,
      elevation: 10.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(5.0),
          bottomRight: Radius.circular(5.0),
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 106.67,
                  height: 107.68,
                  decoration: ShapeDecoration(
                    image: const DecorationImage(
                      image:
                          AssetImage("assets/images/profile/avatar-image.jpg"),
                      fit: BoxFit.cover,
                    ),
                    shape: OvalBorder(
                      side: BorderSide(
                        width: 1.65,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: ShapeDecoration(
                      color: kAccentColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.50,
                          color: kAccentColor,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: kTextWhiteColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: kDefaultPadding),
              width: MediaQuery.of(context).size.width * 0.4,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Princewill Okafor',
                    softWrap: true,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 19.86,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  kHalfSizedBox,
                  Text(
                    'princewillokafor@gmail.com',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF929292),
                      fontSize: 15.44,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
            kSizedBox,
            kSizedBox,
            kSizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isOnline ? 'Online' : 'Offline',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF232323),
                    fontSize: 26.47,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  splashRadius: 5,
                  onPressed: widget.toggleOnline,
                  icon: Icon(
                    widget.isOnline ? Icons.toggle_on : Icons.toggle_off,
                    color: widget.isOnline
                        ? kAccentColor
                        : const Color(0xFF8D8D8D),
                    size: 35,
                  ),
                ),
              ],
            ),
            kSizedBox,
            MyListTile(
              text: 'Earnings',
              isOnline: widget.isOnline,
              icon: Icons.money,
              nav: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const Earning();
                    },
                  ),
                );
              },
            ),
            MyListTile(
              text: 'Delivery History',
              isOnline: widget.isOnline,
              icon: Icons.location_on_outlined,
              nav: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const DeliveredHistory();
                    },
                  ),
                );
              },
            ),
            MyListTile(
              text: 'Help & Support',
              isOnline: widget.isOnline,
              icon: Icons.question_mark_outlined,
              nav: () {},
            ),
            MyListTile(
              text: 'Settings',
              isOnline: widget.isOnline,
              icon: Icons.settings,
              nav: () {},
            ),
            MyListTile(
              text: 'Logout',
              isOnline: widget.isOnline,
              icon: Icons.logout,
              nav: () {},
            ),
          ],
        ),
      ),
    );
  }
}