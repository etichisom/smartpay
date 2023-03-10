
import 'package:apex_task/core/res/text_stlye.dart';
import 'package:apex_task/widget/text_field.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// {@template country_code_picker_modal}
/// Widget that can be used on showing a modal as bottom sheet that
/// contains all of the [CountryCode]s.
///
/// After pressing the [CountryCode]'s [ListTile], the widget pops
/// and returns the selected [CountryCode] which can be manipulated.
/// {@endtemplate}
class KCountryCodePickerModal extends StatefulWidget {
  /// {@macro country_code_picker_modal}
  const KCountryCodePickerModal({
    Key? key,
    this.favorites = const [],
    this.filteredCountries = const [],
    required this.favoritesIcon,
    required this.showSearchBar,
    required this.showDialCode,
    this.focusedCountry,
  }) : super(key: key);

  /// {@macro favorites}
  final List<String> favorites;

  /// {@macro filtered_countries}
  final List<String> filteredCountries;

  /// {@macro favorite_icon}
  final Icon favoritesIcon;

  /// {@macro show_search_bar}
  final bool showSearchBar;

  /// {@macro show_dial_code}
  final bool showDialCode;

  /// If not null, automatically scrolls the list view to this country.
  final String? focusedCountry;

  @override
  State<KCountryCodePickerModal> createState() => _KCountryCodePickerModalState();
}

class _KCountryCodePickerModalState extends State<KCountryCodePickerModal> {
  late final List<CountryCode> baseList;
  final availableCountryCodes = <CountryCode>[];

  late TextEditingController textController;
  late ItemScrollController itemScrollController;

  @override
  void initState() {
    super.initState();
    _initCountries();
  }

  Future<void> _initCountries() async {
    final allCountryCodes = codes.map(CountryCode.fromMap).toList();
    textController = TextEditingController();
    itemScrollController = ItemScrollController();

    final favoriteList = <CountryCode>[
      if (widget.favorites.isNotEmpty)
        ...allCountryCodes.where((c) => widget.favorites.contains(c.code))
    ];
    final filteredList = [
      ...widget.filteredCountries.isNotEmpty
          ? allCountryCodes.where(
            (c) => widget.filteredCountries.contains(c.code),
      )
          : allCountryCodes,
    ]..removeWhere((c) => widget.favorites.contains(c.code));

    baseList = [...favoriteList, ...filteredList];
    availableCountryCodes.addAll(baseList);

    // Temporary fix. Bug when initializing scroll controller.
    // https://github.com/google/flutter.widgets/issues/62
    await Future<void>.delayed(Duration.zero);

    if (!itemScrollController.isAttached) return;

    if (widget.focusedCountry != null) {
      final index = availableCountryCodes.indexWhere(
            (c) => c.code == widget.focusedCountry,
      );

      await itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 600),
      );
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24,right: 24,top: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Field(
                  onChanged: (query) {
                    availableCountryCodes
                      ..clear()
                      ..addAll(
                        List<CountryCode>.from(
                          baseList.where(
                                (c) =>
                            c.code
                                .toLowerCase()
                                .contains(query!.toLowerCase()) ||
                                c.dialCode
                                    .toLowerCase()
                                    .contains(query.toLowerCase()) ||
                                c.name.toLowerCase().contains(query.toLowerCase()),
                          ),
                        ),
                      );
                    setState(() {});
                  },
                  hint: 'Search',
                  prefixIcon: const Icon(CupertinoIcons.search),
                ),
              ),
              const SizedBox(width: 16,),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Text('Cancel',style: AppTextTheme.h3.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16
                ),),
              )
            ],
          ),
          const SizedBox(height: 32,),
          Expanded(
            child: ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              itemCount: availableCountryCodes.length,
              itemBuilder: (context, index) {
                final code = availableCountryCodes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, code),
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          code.flagImage,
                          const SizedBox(width: 16,),
                          Text(code.code,style: AppTextTheme.light.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),),
                          const SizedBox(width: 16,),
                          Text(code.name,style: AppTextTheme.h3.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


