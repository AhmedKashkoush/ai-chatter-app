part of '../introduction_screen.dart';

class _IntroductionScreenLandscape extends StatelessWidget {
  const _IntroductionScreenLandscape();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Lottie.asset(
                Lotties.intro,
                height: 240,
              ),
            ),
          ),
          15.w,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.introTitle,
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLarge,
                ),
                10.h,
                Text(
                  AppStrings.introBody,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                40.h,
                const StartChattingButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
