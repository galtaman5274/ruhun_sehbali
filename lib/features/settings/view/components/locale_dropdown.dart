import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruhun_sehbali/features/localization/localization.dart';
import 'package:ruhun_sehbali/features/settings/providers/ayine_json_cubit.dart';
import 'package:ruhun_sehbali/features/settings/providers/locale_provider.dart';

import 'dropdown_builder.dart';

class LocaleDropdown extends StatelessWidget {
  LocaleDropdown({super.key});
  final Map<String, String> lang = {
    'en': 'English',
    'de': 'Deutsch',
    'ar': 'العربية',
    'tr': 'Türkçe',
  };
  @override
  Widget build(BuildContext context) {
    final selectedLocale = context.watch<LocaleProvider>().locale;
    return CustomDropdown<Locale>(
      value: selectedLocale,
      items: AppLocalizations.supportedLocales,
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          context.read<LocaleProvider>().setLocale(newLocale);
          context.read<AyineJsonCubit>().saveToStorage(newLocale.languageCode);
          //final locale = context.read<LocaleProvider>().locale;
          //context.read<ContentBloc>().add(LoadContentList(locale));
        }
      },
      itemBuilder: (context, locale) {
        return Text(
            lang[locale.toString()] as String); // Build each dropdown item
      },
      hint: "Select a language", // Optional hint text
    );
  }
}
