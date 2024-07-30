part of '../introduction_screen.dart';

class _IntroductionScreenPortrait extends StatelessWidget {
  const _IntroductionScreenPortrait();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            Lotties.intro,
            height: 200,
          ),
          15.h,
          const IntroTitle(),
          10.h,
          const IntroBody(),
          const Spacer(),
          const StartChattingButton(),
        ],
      ),
    );
  }
}
