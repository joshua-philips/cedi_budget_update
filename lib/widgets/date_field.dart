import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateField extends StatelessWidget {
  final String? label;
  final DateTime date;
  final IconData? icon;
  final VoidCallback onIconPressed;

  const DateField({
    Key? key,
    this.label,
    required this.date,
    this.icon,
    required this.onIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Text(label ?? ''),
            ],
          ),
          Row(
            children: [
              Text(
                DateFormat('MMM dd, yyyy').format(date).toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onIconPressed,
                child: Icon(icon, size: 40),
              ),
            ],
          ),
          const Divider(thickness: 2),
        ],
      ),
    );
  }
}
