import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../application/item_details/cubit/item_details_cubit.dart';
import '../../../infrastructure/shopping_list_repository/shopping_list_repository.dart';
import 'aisles_page.dart';
import 'item_details_page_state.dart';
import 'item_details_view.dart';

late ItemDetailsCubit itemDetailsCubit;

class ItemDetailsPage extends StatelessWidget {
  static const id = 'item_details_page';

  final Item item;

  const ItemDetailsPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  static Future<bool> popItemDetails(BuildContext context) async {
    final item = context.read<ItemDetailsCubit>().updatedItem();
    // Return the modified item.
    Navigator.pop(context, item);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemDetailsCubit(item),
      child: Builder(builder: (context) {
        itemDetailsCubit = context.read<ItemDetailsCubit>();
        return WillPopScope(
          onWillPop: () => popItemDetails(context),
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  if (isWide) {
                    return const TwoColumnView();
                  } else {
                    return const ItemDetailsView();
                  }
                },
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.check),
                onPressed: () => popItemDetails(context),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class TwoColumnView extends StatelessWidget {
  const TwoColumnView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ItemDetailsPageState(),
      builder: (context, child) {
        return Row(
          children: const [
            Flexible(
              flex: 2,
              child: ItemDetailsView(),
            ),
            VerticalDivider(),
            Flexible(
              flex: 3,
              child: TwoColumnSubPage(),
            ),
          ],
        );
      },
    );
  }
}

class TwoColumnSubPage extends StatelessWidget {
  const TwoColumnSubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemDetailsPageState>(
      builder: (context, state, child) {
        switch (state.subpage) {
          case '':
            return Container();
          case AislesPage.id:
            return const AislesView();
          default:
            return Container();
        }
      },
    );
  }
}
