import 'package:ai_chatter/core/enums/request_state.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/strings.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/logic/chat_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatField extends StatefulWidget {
  final TextEditingController? controller;
  final void Function()? onSend;
  const ChatField({
    super.key,
    this.controller,
    this.onSend,
  });

  @override
  State<ChatField> createState() => _ChatFieldState();
}

class _ChatFieldState extends State<ChatField> {
  bool _canSend = false;
  @override
  void initState() {
    widget.controller?.addListener(() {
      if (context.mounted) {
        if (_canSend != widget.controller?.text.trim().isNotEmpty) {
          _canSend = widget.controller?.text.trim().isNotEmpty ?? false;
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
      return TextField(
        enabled: state.requestState != RequestState.loading,
        controller: widget.controller,
        minLines: 1,
        maxLines: 4,
        decoration: InputDecoration(
          filled: true,
          fillColor: context.colorScheme.onBackground.withOpacity(0.2),
          suffixIconColor: context.colorScheme.primary,
          suffixIcon: IconButton(
            onPressed: _canSend ? widget.onSend : null,
            icon: const Icon(
              Icons.send_outlined,
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          hintText: context.tr(AppStrings.writeYourQuestion),
        ),
      );
    });
  }
}
