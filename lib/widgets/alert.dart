import 'package:flutter/material.dart';

class AlertMessage {
  showAlert(BuildContext context, String message, bool status) {
    Color warnaFill;
    Color warnaGaris;
    IconData icon;

    if (status) {
      warnaFill = Colors.green.shade200;
      warnaGaris = Colors.green;
      icon = Icons.check_circle;
    } else {
      warnaFill = Colors.red.shade200;
      warnaGaris = Colors.red;
      icon = Icons.error;
    }

    SnackBar snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      content: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: warnaFill,
          border: Border.all(color: warnaGaris, width: 2),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 8,
              offset: Offset(2, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: warnaGaris),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: const Icon(Icons.close, size: 18),
            )
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
