part of '../introduction_screen.dart';

class _IntroductionScreenPortrait extends StatelessWidget {
  const _IntroductionScreenPortrait();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: const Text(AppStrings.startChatting),
            )
          ],
        ),
      ),
    );
  }
}
