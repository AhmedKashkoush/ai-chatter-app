part of '../about_screen.dart';

class AboutScreenLandscape extends StatelessWidget {
  const AboutScreenLandscape({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                Images.appLogo,
                height: 160,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                const DescriptionSection(),
                20.h,
                const ContactsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}