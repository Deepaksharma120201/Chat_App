import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.user,
    this.onTap,
  });

  final String user;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(255, 237, 210, 210),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.person),
            const SizedBox(width: 20),
            Text(user),
          ],
        ),
      ),
    );
  }
}
