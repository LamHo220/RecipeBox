import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:recipe_box/common/components/searcher/cubit/searcher_cubit.dart';

class SearcherWidget extends StatelessWidget {
  SearcherWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openElevation: 0,
      closedElevation: 0,
      closedBuilder: (context, action) =>
          IconButton(onPressed: () => action(), icon: const Icon(Icons.search)),
      openBuilder: (context, action) => Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: [
          FloatingSearchBar(
            hint: 'Search...',
            scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
            transitionDuration: const Duration(milliseconds: 800),
            transitionCurve: Curves.easeInOut,
            physics: const BouncingScrollPhysics(),
            openAxisAlignment: 0.0,
            debounceDelay: const Duration(milliseconds: 500),
            onQueryChanged: (query) {
              // Call your model, bloc, controller here.
              // TODO
            },
            // Specify a custom transition to be used for
            // animating between opened and closed stated.
            transition: CircularFloatingSearchBarTransition(),
            actions: [
              // FloatingSearchBarAction(
              //   showIfOpened: false,
              //   child: CircularButton(
              //     icon: const Icon(Icons.place),
              //     onPressed: () {},
              //   ),
              // ),
              FloatingSearchBarAction.searchToClear(
                showIfClosed: false,
              ),
            ],
            // TODO
            builder: (context, transition) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Colors.white,
                  elevation: 4.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: Colors.accents.map((color) {
                      return Container(height: 112, color: color);
                    }).toList(),
                  ),
                ),
              );
            },
          )
        ],
      )),
    );
  }
}

class Searcher extends StatelessWidget {
  const Searcher({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearcherCubit(),
      child: SearcherWidget(),
    );
  }
}
