import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruhun_sehbali/features/home/provider/navigation_provider.dart';

class MainButton extends StatelessWidget {
  final String text;
  final String nav;
  const MainButton({super.key, required this.text, required this.nav});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<NavigationProvider>().setPage(nav);
        // context.read<MainBloc>().add(ResetInactivityTimerEvent());
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        constraints: const BoxConstraints(minHeight: 65, minWidth: 120),
        decoration: BoxDecoration(
          color: const Color(0xFFF0D9BC),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            letterSpacing: 1,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
