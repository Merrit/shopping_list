import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';
import 'package:shopping_list/shopping_list/item_details/pages/aisles_page.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';

import '../../item_details.dart';
import 'item_details_view.dart';

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
        return WillPopScope(
          onWillPop: () => popItemDetails(context),
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  if (isWide) {
                    return TwoColumnView();
                  } else {
                    return ItemDetailsView();
                  }
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}

class DetailsPageState extends ChangeNotifier {
  String _subpage = '';

  String get subpage => _subpage;

  set subpage(String value) {
    _subpage = value;
    notifyListeners();
  }
}

class TwoColumnView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DetailsPageState(),
      builder: (context, child) {
        return Row(
          children: [
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
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailsPageState>(
      builder: (context, state, child) {
        switch (state.subpage) {
          case '':
            return Container();
          case AislesPage.id:
            return AislesView();
          case LabelsPage.id:
            return LabelsView();
          default:
            return Container();
        }
      },
    );
  }
}
