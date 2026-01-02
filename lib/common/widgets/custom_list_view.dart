import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:tasko_mobile/common/widgets/custom_list_item.dart';

class CustomListView<T> extends StatelessWidget {
  final List<T> values;
  final void Function(T value, int index) onDelete;
  final String Function(T value)? getTitle;
  final String Function(T value)? getSubtitle;
  final String Function(T value)? getSubtitle1;
  final String Function(T value)? getSubtitle2;
  final void Function(T value)? onTap;

  const CustomListView({
    super.key,
    required this.values,
    required this.onDelete,
    this.getTitle,
    this.getSubtitle,
    this.getSubtitle1,
    this.getSubtitle2,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const Center(child: Text('Nenhuma informação encontrada.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: values.length,
      itemBuilder: (context, index) {
        final value = values[index];
        return Dismissible(
          key: Key(values[index].hashCode.toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20.0),
            child: const Icon(Icons.delete as IconData?, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) {
            onDelete(value, index);
          },
          child: CustomListItem(
            key: ValueKey(value),
            title: getTitle != null ? getTitle!(value) : '',
            subtitle: getSubtitle != null ? getSubtitle!(value) : '',
            subtitle1: getSubtitle1 != null ? getSubtitle1!(value) : null,
            subtitle2: getSubtitle2 != null ? getSubtitle2!(value) : null,
            onTap: onTap != null ? () => onTap!(value) : null,
          ),
        );
      },
    );
  }
}

@Preview(name: 'Custom List Item Preview')
Widget customListItemPreview() {
  return CustomListView<String>(
    values: ['Item 1', 'Item 2', 'Item 3'],
    getTitle: (value) => value,
    getSubtitle: (value) => 'Subtitle for $value',
    onDelete: (value, index) {
      // Handle delete action
    },
  );
}
