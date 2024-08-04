part of '../about_screen.dart';

class AboutScreenLandscape extends StatelessWidget {
  const AboutScreenLandscape({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Expanded(
            child: Center(
              child: AppLogo(size: 160),
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
