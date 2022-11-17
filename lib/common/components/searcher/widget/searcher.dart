import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:recipe_box/recipe/widgets/recipe_item.dart';

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
            IconButton(onPressed: () => null, icon: const Icon(Icons.search)),
        openBuilder: (context, action) => Container()
        //  Scaffold(
        //     body: Stack(
        //   fit: StackFit.expand,
        //   children: [
        //     FloatingSearchBar(
        //       hint: 'Search...',
        //       scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        //       transitionDuration: const Duration(milliseconds: 800),
        //       transitionCurve: Curves.easeInOut,
        //       physics: const BouncingScrollPhysics(),
        //       openAxisAlignment: 0.0,
        //       debounceDelay: const Duration(milliseconds: 500),
        //       onQueryChanged: (String query) {
        //         // Call your model, bloc, controller here.
        //         // TODO
        //         print(query);
        //       },
        //       // Specify a custom transition to be used for
        //       // animating between opened and closed stated.
        //       transition: CircularFloatingSearchBarTransition(),
        //       actions: [
        //         // FloatingSearchBarAction(
        //         //   showIfOpened: false,
        //         //   child: CircularButton(
        //         //     icon: const Icon(Icons.place),
        //         //     onPressed: () {},
        //         //   ),
        //         // ),
        //         FloatingSearchBarAction.searchToClear(
        //           showIfClosed: false,
        //         ),
        //       ],
        //       // TODO
        //       builder: (context, transition) {
        //         return FutureBuilder(
        //           future: null,
        //           builder: (context, snapshot) => ListView.separated(
        //               itemBuilder: (context, index) => RecipeItem(recipe: recipe),
        //               separatorBuilder: (context, index) => const Divider(
        //                     color: Colors.white,
        //                   ),
        //               itemCount: 0),
        //         );
        //       },
        //     )
        //   ],
        // )
        // );
        );
  }
}

class Searcher extends StatelessWidget {
  const Searcher({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return SearcherWidget();
  }
}
