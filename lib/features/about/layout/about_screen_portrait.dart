part of '../about_screen.dart';

class AboutScreenPortrait extends StatelessWidget {
  const AboutScreenPortrait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const AppLogo(size: 160),
        20.h,
        const DescriptionSection(),
        20.h,
        const ContactsSection(),
      ],
    );
  }
}
