import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/screen_saver/view/components/screen_saver.dart';
import '../../settings/providers/data_models.dart';

import '../bloc/screen_saver.dart';

class ScreenSaverView extends StatelessWidget {
  final ScreenSaver screenSaver;
  const ScreenSaverView({super.key, required this.screenSaver});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreenSaverBloc, ScreenSaverState>(
      builder: (context, state) {
        if (state.saverStateData.showScreenSaver) {
          return state.saverStateData.screenSaverFull ?  ScreenSaverFull(saverStateData: state.saverStateData,) :  ScreenSaverMini(saverStateData: state.saverStateData,);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
