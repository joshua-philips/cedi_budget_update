import 'package:flutter/material.dart';

class AuthTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool? obscureText;
  final FormFieldValidator<String>? validator;
  final bool? autofocus;

  const AuthTextFormField({Key? key, 
    required this.controller,
    this.validator,
    this.hintText,
    this.obscureText,
    this.autofocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.redAccent,
        autofocus: autofocus ?? false,
        obscureText: obscureText ?? false,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          focusColor: Colors.white,
          hintText: hintText ?? '',
          hintStyle: const TextStyle(color: Colors.black),
          errorStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: const EdgeInsets.all(8),
        ),
        validator: validator,
      ),
    );
  }
}

class UpdateTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? helperText;
  final String? label;
  final bool? obscureText;
  final FormFieldValidator<String>? validator;
  final bool? autofocus;

  const UpdateTextFormField({Key? key, 
    required this.controller,
    this.validator,
    this.helperText,
    this.obscureText,
    this.autofocus,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        controller: controller,
        cursorColor: Colors.redAccent,
        autofocus: autofocus ?? false,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          helperText: helperText ?? '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        validator: validator,
      ),
    );
  }
}

class ItemTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? helperText;
  final bool? autofocus;

  const ItemTextField({
    Key? key,
    required this.controller,
    this.helperText,
    this.autofocus,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15.0,
        bottom: 10,
      ),
      child: TextField(
        controller: controller,
        maxLines: 1,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          helperText: helperText,
          helperStyle: const TextStyle(color: Colors.black),
          hintText: 'Item',
          hintStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: const EdgeInsets.all(8),
        ),
        autofocus: autofocus ?? false,
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}

class MoneyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? helperText;
  final bool? autofocus;

  const MoneyTextField({
    Key? key,
    required this.controller,
    this.helperText,
    this.autofocus,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15.0,
        bottom: 10,
        left: 50,
      ),
      child: TextField(
        controller: controller,
        maxLines: 1,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefix: const Text('GH¢'),
          prefixStyle: const TextStyle(color: Colors.black),
          helperText: helperText,
          hintText: '0.00',
          hintStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: const EdgeInsets.all(8),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        autofocus: autofocus ?? false,
      ),
    );
  }
}
