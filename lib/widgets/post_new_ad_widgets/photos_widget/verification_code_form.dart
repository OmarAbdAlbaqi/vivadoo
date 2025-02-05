import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/providers/post_new_ad_provider/post_new_ad_provider.dart';

import '../../../constants.dart';

class VerificationCodeForm extends StatefulWidget {
  const VerificationCodeForm({super.key});
  // final List<TextEditingController> controllers;

  @override
  _VerificationCodeFormState createState() => _VerificationCodeFormState();
}

class _VerificationCodeFormState extends State<VerificationCodeForm> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _currentIndex = 0;

  late PostNewAdProvider postNewAdProvider;
  @override
  void initState() {
    super.initState();
    postNewAdProvider = context.read<PostNewAdProvider>();
    _focusNodes[0].requestFocus(); // Autofocus the first field
  }

  @override
  void dispose() {
    postNewAdProvider.verificationCode = "";
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
        _currentIndex = index + 1;
      } else {
        _focusNodes[index].unfocus();
        _submitCode();
      }
    }
  }

  void _onBackspacePressed(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].text = '';
      _currentIndex = index - 1;
    }
  }

  void _submitCode() {
    final code = _controllers.map((controller) => controller.text).join();
    context.read<PostNewAdProvider>().verificationCode = code.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            width: 50,
            height: 50,
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (event) {
                if (HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.backspace)) {
                  _onBackspacePressed(index);
                }
              },
              child: TextFormField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: const TextStyle(fontSize: 14 , fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Constants.orange , width: 1)
                  )
                ),
                onChanged: (value) => _onChanged(value, index),
              ),
            ),
          );
        }),
      ),
    );
  }
}
