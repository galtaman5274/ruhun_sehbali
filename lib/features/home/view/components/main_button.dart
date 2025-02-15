import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        width: 60.w, // Set the desired width of the button
        height: 30.h, // Set the desired height of the button
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: const Color.fromARGB(255, 177, 146, 135) // Rounded corners
            ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            text, // Your button text
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white, // Text color for better contrast
            ),
          ),
        ),
      ),
    );
  }
}
