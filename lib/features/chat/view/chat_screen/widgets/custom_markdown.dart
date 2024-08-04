import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomMarkdown extends StatelessWidget {
  final String data;
  final bool isSelect;

  const CustomMarkdown({
    super.key,
    required this.data,
    this.isSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    // final bool isDark = context.colorScheme.brightness == Brightness.dark;

    return isSelect
        ? SelectionArea(
            child: MarkdownBody(
              data: data,
              shrinkWrap: true,
              onTapLink: (text, href, title) => launch(href ?? ''),
            ),
          )
        : MarkdownBody(
            data: data,
            shrinkWrap: true,
            onTapLink: (text, href, title) => launch(href ?? ''),
          );
    // MarkdownWidget(
    //   data: data,
    //   selectable: isSelect,
    //   shrinkWrap: true,
    //   physics: const NeverScrollableScrollPhysics(),
    //   config: markdownConfig(isDark).copy(configs: [
    //     LinkConfig(
    //       onTap: launch,
    //       style: TextStyle(
    //         color: context.colorScheme.primary,
    //         decoration: TextDecoration.underline,
    //       ),
    //     ),
    //     isDark
    //         ? PreConfig.darkConfig.copy(
    //             textStyle: hasError ? errorTextStyle : darkTextStyle,
    //           )
    //         : PreConfig(
    //             textStyle: hasError ? errorTextStyle : lightTextStyle,
    //           ),
    //   ]),
    // );
  }

  void launch(String url) async {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }
}
