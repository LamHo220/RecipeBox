import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_box/common/components/searcher/cubit/searcher_cubit.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/paddings.dart';
import 'package:recipe_box/common/constants/style.dart';

class SearcherWidget extends StatelessWidget {
  SearcherWidget({super.key, this.placeholder});
  final placeholder;
  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
        controller: context.read<SearcherCubit>().state.controller,
        padding: Pad.pa12,
        onChanged: (String x) {
          context.read<SearcherCubit>().controllerChanged(x);
        },
        onSubmitted: (String x) {
          // TODO: Show result after Submitting it?
        },
        borderRadius: BorderRadius.circular(16),
        placeholder: placeholder,
        style: Style.search,
        backgroundColor: ThemeColors.card,
        prefixInsets: const EdgeInsetsDirectional.fromSTEB(18, 4, 0, 4));
  }
}

class Searcher extends StatelessWidget {
  const Searcher({super.key, this.placeholder});
  final placeholder;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearcherCubit(),
      child: SearcherWidget(placeholder: placeholder),
    );
  }
}
