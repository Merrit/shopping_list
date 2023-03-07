import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/shopping_list/cubit/shopping_list_cubit.dart';
import '../../domain/core/core.dart';
import '../../infrastructure/shopping_list_repository/shopping_list_repository.dart';

/// Displays a list of aisles and allows the user to edit them.
class AislesPage extends StatelessWidget {
  static const id = 'aisles_page';

  const AislesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Round button with icon and background color to create aisle.
    final Widget createAisleButton = FloatingActionButton.small(
      heroTag: null,
      onPressed: () => _showAisleDialog(context: context),
      backgroundColor: Colors.greenAccent.shade400,
      child: const Icon(Icons.add),
    );

    final Widget floatingDoneButton = FloatingActionButton.extended(
      onPressed: () => Navigator.pop(context),
      label: const Text('Done'),
      icon: const Icon(Icons.done),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Aisle'),
          actions: [
            createAisleButton,
            const SizedBox(width: 10),
          ],
        ),
        body: const AislesView(),
        floatingActionButton: floatingDoneButton,
      ),
    );
  }
}

class AislesView extends StatelessWidget {
  const AislesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AislesList();
  }
}

class _AislesList extends StatelessWidget {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // ignore: no_leading_underscores_for_local_identifiers
    final _isLargeFormFactor = isLargeFormFactor(context);

    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, shoppingListState) {
        return Scrollbar(
          controller: _controller,
          thumbVisibility: _isLargeFormFactor ? true : false,
          child: ReorderableListView(
            // Padding added on large screens to prevent the [ListTile]s from
            // taking up the entire width of the screen.
            padding: _isLargeFormFactor
                ? EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width * 0.3,
                    vertical: 30,
                  )
                : const EdgeInsets.all(30),
            children: shoppingListState.aisles.map((aisle) {
              return ListTile(
                  key: ValueKey(aisle.name),
                  title: Chip(
                    label: Text(aisle.name),
                    backgroundColor: Color(aisle.color),
                  ),
                  enabled: aisle.name != 'None',
                  onTap: () => _showAisleDialog(
                        context: context,
                        aisle: aisle,
                      ));
            }).toList(),
            onReorder: (int oldIndex, int newIndex) {
              context
                  .read<ShoppingListCubit>()
                  .reorderAisles(oldIndex, newIndex);
            },
          ),
        );
      },
    );
  }
}

/// Show a dialog where the user can either create, edit, or delete an aisle.
///
/// If [aisle] is null, the user is creating a new aisle.
/// If [aisle] is not null, the user is editing an existing aisle.
void _showAisleDialog({required BuildContext context, Aisle? aisle}) {
  final focusNode = FocusNode();

  showDialog(
    context: context,
    builder: (context) {
      Color color = Color(aisle?.color ?? 0);
      final nameController = TextEditingController(text: aisle?.name ?? '');
      final colorController = TextEditingController(
        text: color.value.toRadixString(16),
      );

      final Widget deleteButton;
      if (aisle == null) {
        deleteButton = const SizedBox.shrink();
      } else {
        deleteButton = TextButton(
          onPressed: () async {
            final navigator = Navigator.of(context);

            final deleteConfirmed = await _deleteAisle(
              context: context,
              aisle: aisle,
            );

            if (deleteConfirmed) navigator.pop();
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        );
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        // If the user is creating a new aisle, focus the text field.
        if (aisle == null) {
          focusNode.requestFocus();
        }
      });

      return AlertDialog(
        title: Text(aisle == null ? 'Create aisle' : 'Edit aisle'),
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              focusNode: focusNode,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            ColorPicker(
              color: color,
              onColorChanged: (newColor) {
                color = newColor;
                colorController.text = newColor.value.toRadixString(16);
              },
            ),
          ],
        ),
        actions: [
          deleteButton,
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              if (aisle == null) {
                if (nameController.text.trim().isEmpty) return;
                await context.read<ShoppingListCubit>().createAisle(
                      name: nameController.text.capitalize,
                      color: color.value,
                    );
              } else {
                await context.read<ShoppingListCubit>().updateAisle(
                      oldAisle: aisle,
                      color: color.value,
                      name: nameController.text.capitalize,
                    );
              }
              navigator.pop();
            },
            child: Text(aisle == null ? 'Create' : 'Save'),
          ),
        ],
      );
    },
  );
}

/// Delete an aisle.
///
/// If the aisle is the same as the item's aisle, the item's aisle is set to 'None'.
///
/// Returns `true` if the aisle was deleted, `false` otherwise.
Future<bool> _deleteAisle({
  required BuildContext context,
  required Aisle aisle,
}) async {
  final deleteConfirmed = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete aisle'),
        content: const Text('Are you sure you want to delete this aisle?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await context.read<ShoppingListCubit>().deleteAisle(aisle: aisle);
              navigator.pop(true);
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );

  return deleteConfirmed;
}
